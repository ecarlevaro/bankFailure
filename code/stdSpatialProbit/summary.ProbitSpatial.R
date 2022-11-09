# method for summary() ProbitSpatial object
function (object, covar = FALSE, ...) 
{
  cat("-- Univariate conditional estimation of spatial probit --\n\n")
  cat("Sample size = ", object@nobs, "\n")
  cat("Number of covariates = ", object@nvar, "\n")
  cat("DGP = ", object@DGP, "\n")
  cat("estimation method = ", object@method, "\n")
  vc <- ifelse(object@varcov == "varcov", "Var-Covar Matrix", 
               "Precision Matrix")
  cat("Variance covariance = ", vc, "\n")
  if (object@iW_CL > 0) {
    cat("order of approx. of iW in the conditional step = ", 
        object@iW_CL, "\n")
  }
  if (object@method == "full-lik") {
    if (object@iW_FL > 0) {
      cat("order of approximation of iW in the likelihood function = ", 
          object@iW_FL, "\n")
    }
    if (object@iW_FG > 0) {
      cat("order of approximation of iW in the gradient function = ", 
          object@iW_FG, "\n")
    }
    if (object@prune > 0) {
      cat("pruning in the gradient functions = ", 
          object@prune, "\n")
    }
  }
  cat("Execution time = ", object@time, "\n\n")
  cat("-----------------------------------------------\n\n")
  mod_covar <- ifelse(object@varcov == "varcov", "UC", 
                      "UP")
  if (covar == TRUE) {
    mycoef <- object@coeff
    lik <- get(paste("lik", object@DGP, mod_covar, 
                     sep = "_"))
    H <- numDeriv::hessian(lik, x = mycoef, env = object@env)
    se <- sqrt(diag(abs(solve(H))))
    outmat <- cbind(mycoef, se, mycoef/se, 2 * (1 - pnorm(abs(mycoef)/se)))
    colnames(outmat) <- c("Estimate", "Std. Error", 
                          "z-value", "Pr(>z)")
    rownames(outmat) <- names(mycoef)
    cat("Unconditional standard errors with variance-covariance matrix\n\n")
  }
  else {
    lik <- get(paste("conditional", object@DGP, mod_covar, 
                     sep = "_"))
    llik <- get(paste("lik", object@DGP, mod_covar, 
                      sep = "_"))
    env1 <- object@env
    Beta0 <- suppressWarnings(coef(glm.fit(object@X, object@y, 
                                           intercept = FALSE, family = binomial(link = "probit"))))
    if (object@DGP == "SARAR") {
      LR_rho = -2 * (llik(c(Beta0, 0, object@lambda), env1) - 
                       object@loglik)
      LR_lambda = -2 * (llik(c(Beta0, object@rho, 0), env1) - 
                          object@loglik)
      LR <- c(LR_rho, LR_lambda)
    }
    else {
      LR = -2 * (llik(c(Beta0, 0), env1) - object@loglik)
    }
    LR_beta <- c()
    for (i in 1:object@nvar) {
      XX <- env1$ind
      env1$ind <- as.matrix(XX[, -i])
      lc = lik(env1)
      env1$ind <- as.matrix(XX)
      LR_beta <- c(LR_beta, -2 * (lc$l - object@loglik))
    }
    LRtheta <- abs(as.numeric(c(LR_beta, LR)))
    outmat <- cbind(object@coeff, LRtheta, pchisq(LRtheta, 
                                                  1, lower.tail = FALSE))
    colnames(outmat) <- c("Estimate", "LR test", 
                          "Pr(>z)")
    if (object@DGP == "SARAR") {
      rownames(outmat) <- c(colnames(object@X), "rho", 
                            "lambda")
    }
    else {
      rownames(outmat) <- c(colnames(object@X), "rho")
    }
    cat("Unconditional standard errors with likelihood-ratio test\n")
  }
  print(outmat)
  cat("\n-----------------------------------------------\n")
  f <- fitted(object, type = "binary")
  y <- object@y
  TP <- sum(f == 1 & y == 1)
  TN <- sum(f == 0 & y == 0)
  FP <- sum(f == 1 & y == 0)
  FN <- sum(f == 0 & y == 1)
  conf_matrix <- matrix(c(TP, FN, FP, TN), 2, 2)
  colnames(conf_matrix) <- c("pred 1", "pred 0")
  rownames(conf_matrix) <- c("true 1", "true 0")
  cat("Confusion Matrix:\n")
  print(conf_matrix)
  cat("Accuracy:\t", (TP + TN)/(TP + TN + FP + FN), "\n")
  cat("Sensitivity:\t", (TP)/(TP + FN), "\t Specificity:\t", 
      (TN)/(FP + TN), "\n")
  cat("Pos Pred Value:\t", (TP)/(TP + FP), "\t Neg Pred Value:", 
      (TN)/(TN + FN), "\n")
}
