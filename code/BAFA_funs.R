save2Excel <- function(obj, sName, file) {
  write.xlsx2(obj, file, 
              sheetName=sName, append=TRUE)
}

# Export adjacency matrix from an igraph object
# INPUT: network. An igraph object
# OUTPUT: an standarised NxN matrix with weights if any in the input
create_adj_matrix <- function(network, weighted=TRUE) {
  #network <- Sams[[1]]$network
  if (weighted) {
    print("Weighted network")
	W <- as_adjacency_matrix(network, attr='weight', sparse=FALSE) 
  } else {
    if(is.weighted(network) == TRUE) {
      print("Unweighted but notice the netowork has a weight attribute")
    }
    print("Non-weighted network")
    W <- as_adjacency_matrix(network, attr=NULL, sparse=FALSE)  
  }
  # Dimensions of W should equal # of banks
  # Row-normalised weight matrix
  
  apply(W, MARGIN=1, FUN=function(row) { 
    rowSum = sum(row)
    if (rowSum != 0) {
      row/rowSum
    } else {
      row
    }}) %>% t(.) 
  
}

# Modified varion of ProbitSpatial::ProbitSpatialFit() function that does not stop when
# W has regions without neighbours (row of zero in W)
PSfit2 <- function (formula, data, W, DGP = "SAR", method = "conditional", 
                    varcov = "varcov", M = NULL, control = list()) 
{
  con <- list(iW_CL = 6, iW_FL = 0, iW_FG = 0, reltol = 1e-05, 
              prune = 1e-04, silent = TRUE)
  nmsC <- names(con)
  con[(namc <- names(control))] <- control
  if (length(noNms <- namc[!namc %in% nmsC])) 
    warning("unknown names in control: ", paste(noNms, collapse = ", "))
  mf <- match.call(expand.dots = FALSE)
  m <- match(c("formula", "data"), names(mf), 0L)
  mf <- mf[c(1L, m)]
  mf$drop.unused.levels <- TRUE
  mf[[1L]] <- as.name("model.frame")
  mf <- eval(mf, parent.frame())
  mt <- attr(mf, "terms")
  Y <- model.extract(mf, "response")
  Y <- as.numeric(Y > 0)
  X <- model.matrix(mt, mf)
  idx1 <- match(c("(Intercept)", "Intercept", "(intercept)", 
                  "intercept"), colnames(X))
  if (any(!is.na(idx1))) {
    colnames(X)[idx1[!is.na(idx1)]] <- "(Intercept)"
  }
  myenv <- new.env()
  try(rm(myenv), silent = TRUE)
  myenv <- new.env()
  myenv[["appiWCL"]] <- con$iW_CL
  myenv[["appiWFL"]] <- con$iW_FL
  myenv[["appiNFG"]] <- con$iW_FG
  myenv[["eps"]] <- con$prune
  if (is.null(W) | any(abs(Matrix::rowSums(W) - 1) > 1e-12)) 
    warning("W must be a valid row normalized spatial weight matrix")
  if (class(W) == "matrix") 
    W <- Matrix::Matrix(W)
  myenv[["WW"]] <- W
  myenv[["MM"]] <- M
  myenv[["ind"]] <- X
  myenv[["de"]] <- Y
  myenv[["reltol"]] <- con$reltol
  message <- 0
  if (varcov == "precision") 
    method_sigma = "UP"
  else method_sigma = "UC"
  if (DGP == "SAR") {
    DGP_1 = "SAR"
  }
  if (DGP == "SEM") {
    DGP_1 = "SEM"
  }
  if (DGP == "SARAR") {
    DGP_1 = "SARAR"
  }
  lik <- getFromNamespace(paste("conditional", DGP_1, method_sigma, sep = "_"), ns="ProbitSpatial")
  llik <- getFromNamespace(paste("lik", DGP_1, method_sigma, sep = "_"), ns="ProbitSpatial")
  init_cond <- Sys.time()
  out <- suppressWarnings(lik(myenv))
  fint_cond <- Sys.time()
  tim_cond <- as.numeric(difftime(fint_cond, init_cond, units = "secs"))
  mycoef_cond <- unlist(out$par)
  myenv$l_cond <- out$l
  if (DGP_1 == "SARAR") {
    second_place = c("rho", "lambda")
  }
  else {
    second_place = "rho"
  }
  names(mycoef_cond) <- c(colnames(X), second_place)
  retourcond = 1
  if (method == "full-lik" && DGP %in% c("SAR", "SEM")) {
    retourcond = 0
    if (con$prune == 0) 
      method_grad <- "FG"
    else method_grad <- "AG"
    ggrad <- get(paste("grad", DGP, method_sigma, method_grad, 
                       sep = "_"))
    init_FL <- Sys.time()
    out = optim(mycoef_cond, llik, ggrad, myenv, method = "BFGS", 
                control = list(reltol = myenv$reltol))
    fint_FL <- Sys.time()
    tim_FL <- as.numeric(difftime(fint_FL, init_FL, units = "secs"))
    if (!is.list(out)) {
      retourcond = 1
      cat("Convergence failed with Full Maximum Likelihood: try to increase iW_FL and/or decrease prune (in case of approximate gradients) and/or stick to the results of conditional likelihood estimation")
      message = 1
    }
    else {
      mycoef_FL = unlist(out$par)
      names(mycoef_FL) <- c(colnames(X), "rho")
      myenv$l_FL = out$value
    }
  }
  if (retourcond == 1) {
    mycoef <- mycoef_cond
    lhat <- myenv$l_cond
  }
  else {
    mycoef <- mycoef_FL
    lhat <- myenv$l_FL
  }
  k <- ncol(X)
  beta <- mycoef[1:k]
  rho <- mycoef[k + 1]
  if (DGP == "SARAR") 
    lambda <- mycoef[k + 2]
  if (con$silent == FALSE) {
    iW <- ApproxiW(W, rho, con$iW_CL)
    if (DGP %in% c("SAR", "SARAR")) {
      xstar <- iW %*% X
    }
    else {
      xstar <- X
    }
    if (DGP %in% c("SAR", "SEM")) {
      v <- sqrt(Matrix::diag(Matrix::tcrossprod(iW)))
    }
    else {
      iM <- ApproxiW(M, lambda, con$iW_CL)
      v <- sqrt(Matrix::diag(Matrix::tcrossprod(iW %*% 
                                                  iM)))
    }
    xb <- as.numeric(xstar %*% beta)/v
    p <- pnorm(xb)
    p[which(p == 1)] <- 0.9999
    p[which(p == 0)] <- 1e-04
    g <- (dnorm(xb)^2)/(p * (1 - p))
    gmat <- as.matrix((sqrt(g)/v) * xstar)
    vmat1 <- Matrix::solve(Matrix::crossprod(gmat))
    semat1 <- sqrt(Matrix::diag(vmat1))
    Beta0 <- coef(glm.fit(X, Y, family = binomial(link = "probit")))
    if (DGP == "SARAR") {
      LR_rho <- 2 * (llik(c(Beta0, 0, lambda), myenv) - 
                       lhat)
      LR_lambda <- 2 * (llik(c(Beta0, rho, 0), myenv) - 
                          lhat)
      LR <- c(LR_rho, LR_lambda)
    }
    else {
      LR <- 2 * (llik(c(Beta0, 0), myenv) - lhat)
    }
    cat("St. dev. of beta conditional on rho and Lik-ratio of rho", 
        "\n")
    if (DGP == "SARAR") {
      fin_res <- c(beta, rho, lambda)
    }
    else {
      fin_res <- c(beta, rho)
    }
    outmat <- cbind(fin_res, c(semat1, LR * NA), c(beta/semat1, 
                                                   LR), c(2 * (1 - pnorm(abs(beta)/semat1)), pchisq(LR, 
                                                                                                    1, lower.tail = FALSE)))
    colnames(outmat) <- c("Estimate", "Std. Error", "z-value", 
                          "Pr(>|z|)")
    if (DGP_1 == "SARAR") {
      second_place = c("rho", "lambda")
    }
    else {
      second_place = "rho"
    }
    rownames(outmat) <- c(colnames(X), second_place)
  }
  out <- new("ProbitSpatial", beta = mycoef[1:k], rho = mycoef[1 + 
                                                                 k], lambda = ifelse(DGP == "SARAR", mycoef[2 + k], 0), 
             coeff = mycoef, loglik = ifelse(retourcond == 1, myenv$l_cond, 
                                             myenv$l_FL), formula = formula, nobs = ncol(W), 
             nvar = k, y = Y, X = X, time = ifelse(retourcond == 
                                                     1, tim_cond, tim_FL), DGP = DGP, method = method, 
             varcov = varcov, W = W, M = M, iW_CL = con$iW_CL, iW_FL = con$iW_FL, 
             iW_FG = con$iW_FG, reltol = con$reltol, prune = con$prune, 
             env = myenv, message = message)
  return(out)
}
