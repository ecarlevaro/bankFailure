library(rmatio)
library(spatialreg)
library(spdep)
setwd('C:/Users/emi.ABLE-22868/OneDrive/UWA PhD/bankFailure/code/simulations/SAR_sim')

s <- read.mat('sim_SAR.mat')
colnames(s$simData$X[[1]]) <- c('intercept', 'capital', 'liquidity', 'shortFunding')
sim_tibble <- bind_cols( tibble('Y' = s$simData$Y[[1]]), as_tibble(s$simData$X[[1]]) )

# Dimensions of W should equal # of banks
# Row-normalised weight matrix
W <- s$simData$W[[1]]
Wstd <- apply(W, MARGIN=1, FUN=function(row) { 
  rowSum = sum(row)
  if (rowSum != 0) {
    row/rowSum
  } else {
    row
  }}) %>% t(.)

spatialRegNetwork <-  spdep::mat2listw(Wstd)

model <- spatialreg::lagsarlm(formula='Y ~  capital + liquidity + shortFunding',
                              data = sim_tibble,
                              listw = spatialRegNetwork,
                              zero.policy = TRUE)

summary(model)

