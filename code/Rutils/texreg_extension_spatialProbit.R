require(texreg)
# see the example of extract.lm function for an lm object on pag19 LEIFELD Philip
# texreg
extractCaca <- function(model) {

  co <- coefficients(model)
  names <- names(co)
  # Std errors
  theS <- summary_spatial(model, covar = TRUE) # see the function below. it ouputs a matrix with std errors
  se <- theS[, 'Std. Error']
  pval <- theS[, 'Pr(>z)']
  rs <- model$loglik
  adj <- rs
  n <- model$nobs
  # Goodness of fit
  gof <- c(rs, adj, n)
  gof.names <- c("logLik", "logLik", "Num.\\ obs.")
  
  tr <- createTexreg(
    coef.names = names,
    coef = co,
    se = se,
    pvalues = pval,
    gof.names = gof.names,
    gof = gof
  )
  
  tr

}
library(texreg)
# Register the new method
setMethod('extract', 
          signature = className('ProbitSpatial', 'ProbitSpatial'), 
          definition = extractCaca)


summary_spatial <- function(object, covar=FALSE, ...) {
  vc <- ifelse(object@varcov == "varcov", "Var-Covar Matrix", 
               "Precision Matrix")
  cat("Variance covariance = ", vc, "\n")
  mod_covar <- ifelse(object@varcov == "varcov", "UC", 
                      "UP")
  if (covar == TRUE) {
    mycoef <- object@coeff
    lik <- getFromNamespace(paste("lik", object@DGP, mod_covar, 
                     sep = "_"), ns="ProbitSpatial")
    H <- numDeriv::hessian(lik, x = mycoef, env = object@env)
    se <- sqrt(diag(abs(solve(H))))
    outmat <- cbind(mycoef, se, mycoef/se, 2 * (1 - pnorm(abs(mycoef)/se)))
    colnames(outmat) <- c("Estimate", "Std. Error", 
                          "z-value", "Pr(>z)")
    rownames(outmat) <- names(mycoef)
    cat("Unconditional standard errors with variance-covariance matrix\n\n")
  }  else {
    lik <- get(paste("conditional", object@DGP, mod_covar, 
                     sep = "_"))
    llik <- getFromNamespace(paste("lik", object@DGP, mod_covar, 
                                   sep = "_"), ns="ProbitSpatial")
    env1 <- object@env
    Beta0 <- suppressWarnings(coef(glm.fit(object@X, object@y, 
                                           intercept = FALSE, family = binomial(link = "probit"))))
    if (object@DGP == "SARAR") {
      LR_rho = -2 * (llik(c(Beta0, 0, object@lambda), env1) - 
                       object@loglik)
      LR_lambda = -2 * (llik(c(Beta0, object@rho, 0), env1) - 
                          object@loglik)
      LR <- c(LR_rho, LR_lambda)
    }    else {
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
    }    else {
      rownames(outmat) <- c(colnames(object@X), "rho")
    }
    cat("Unconditional standard errors with likelihood-ratio test\n")
  }
  
  outmat  
}
