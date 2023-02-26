
# model is an sphet object from the sphet package.
extract_sphet <- function(model, ...) {
  co <- coefficients(model)[,1]
  names <- names(co)
  # Std errors
  
  theS <- summary(model)
  se <- theS$CoefTable[,'Std. Error']
  pval <- theS$CoefTable[,'Pr(>|t|)']
  rs <- NA
  adj <- NA
  n <- NROW(theS$model)
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


# Register the new method
setMethod('extract', 
          signature = className('sphet', 'sphet'), 
          definition = extract_sphet)