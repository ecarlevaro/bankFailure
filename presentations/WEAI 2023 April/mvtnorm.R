library(mvtnorm)
library(MASS)
library(mnormt)


set.seed(12345)

x     <- seq(-3, 3, 0.1) 
y     <- seq(-3, 3, 0.1)

f     <- function(x, y) if_else(y == 0, dnorm(x), 0)
z     <- outer(x, y, f)

close3d()
open3d()
persp3d(x,y,z,
        alpha=0.5, front='lines', color='green', 
        xlab=latex2exp::TeX(r"($y^{*}_{1}$)"), 
        ylab=latex2exp::TeX(r"($y^{*}_{2}$)"), 
        zlab=latex2exp::TeX(r"($p(y^{*}_{1}, y^{*}_{2})$)"))

title3d(sub='Joint probability distribution for a non-spatial probit',
        floating=FALSE)

f     <- function(x, y) if_else(x == 0, dnorm(y), 0)
z     <- outer(x, y, f)

persp3d(x,y,z,
        alpha=0.5, front='lines', color='blue', add=TRUE)

widget <- rglwidget()
filename <- "joint PDF probit.html"
htmlwidgets::saveWidget(rglwidget(), filename)

writeOBJ('ind.obj')

#create bivariate normal distribution
Sigma <- rbind(c(1, 0.5),
               c(0.5, 1))

close3d()
open3d()

mu    <- c(0, 0)
f     <- function(x, y) dmnorm(cbind(x, y), mu, Sigma)
z     <- outer(x, y, f)

#create surface plot
persp3d(x,y,z,
        alpha=0.5, front='lines', color='yellow',
        xlab=latex2exp::TeX(r"($y^{*}_{1}$)"), 
        ylab=latex2exp::TeX(r"($y^{*}_{2}$)"), 
        zlab=latex2exp::TeX(r"($p(y^{*}_{1}, y^{*}_{2})$)"))

title3d(sub='Joint PDF for a SAR probit',
        floating=FALSE)


widget <- rglwidget()
filename <- "joint PDF SAR probit.html"
htmlwidgets::saveWidget(rglwidget(), filename)


////
  
  
y_1 <- rnorm(300)
y_2 <- rnorm(300)
Sigma <- rbind(c(1, 0.3),
               c(0.3, 1))
Y <- cbind('y_1'=y_1, 'y_2'=y_2) %*% t(Sigma)
colnames(Y)  <- c('y_1', 'y_2')
p <- dmvnorm(Y, sigma=Sigma)

z <- outer(y_1, y_2, p)

f     <- function(x, y) dmnorm(cbind(x, y), 0, Sigma)
z     <- outer(y_1, y_2, f)

persp(Y[,'y_1'], Y[,'y_2'], z)



persp(x, y, z)

try(close3d())

open3d() # see https://cran.r-project.org/web/packages/rgl/vignettes/rgl.html#documents-with-rgl-scenes
#options(rgl.useNULL=FALSE)
# Left Top Right Bottom
par3d(windowRect = c(0, 23, 1280, 689))
par3d(cex=1.5) # text size
title3d(main=NULL, sub=setName, 
        xlab=latex2exp::TeX(r"($\phi_{\pi})"), 
        ylab=latex2exp::TeX(r"($\phi_{X}$)"), 
        zlab=latex2exp::TeX(r"($\psi_{b}$)"),
        cex=2)



aSh <- alphashape3d::ashape3d(cbind('x'=y_1, 'y'=y_2, 'z'=p)) %>% shade3d(),
         alpha = 0.9,
         pert = TRUE, eps=3)
aMesh <- as.mesh3d(aSh)# %>%
#addNormals
shade3d(aMesh, color='blue',  
        alpha=0.4,add=TRUE)
library(tidyverse)
D <- tibble('x'= y_1,
            'y' = y_2,
            'z' = p)
D <- arrange(D, x, y)
close3d()
open3d()
persp3d(list('x'= c(1,2,3),
               'y' = c(1,2,3),
               'z' = c(0, 0.1, ,0.2)))

# This example requires the MASS package
library(MASS)
# from the fitdistr example
set.seed(123)
x <- rgamma(100, shape = 5, rate = 0.1)
fit <- fitdistr(x, dgamma, list(shape = 1, rate = 0.1), lower = 0.001)
loglik <- function(shape, rate) sum(dgamma(x, shape=shape, rate=rate, 
                                           log=TRUE))
loglik <- Vectorize(loglik)
xlim <- fit$estimate[1]+4*fit$sd[1]*c(-1,1)
ylim <- fit$estimate[2]+4*fit$sd[2]*c(-1,1)

mfrow3d(1, 2, sharedMouse = TRUE)
persp3d(loglik, 
        xlim = xlim, ylim = ylim,
        n = 30)
zlim <- fit$loglik + c(-qchisq(0.99, 2)/2, 0)
next3d()
persp3d(loglik, 
        xlim = xlim, ylim = ylim, zlim = zlim,
        n = 30)


, 
      theta=-30, phi=25, expand=0.6, ticktype='detailed')


aSh <-  tryCatch({theSet[Regime==thisReg, ] %>%
    {ashape3d(cbind('x'=.$phiPi, 'y'=.$phiX, 'z'=.$psiB),
              alpha = 0.9,
              pert = TRUE, eps=3)}},
    error=function(cond) {
      message(paste("Error puto when building mesh"))
      message("Here's the original error message:")
      message(cond)
      # Choose a return value in case of error
      return(NA)
    })
if(is.list(aSh)) { thisColor <- filter(regimes, Regime == thisReg)$COLOR
aMesh <- as.mesh3d(aSh)# %>%
#addNormals
shade3d(aMesh, color='blue',  
        alpha=0.4,add=TRUE)}


plot_ly(data = Y, 
        x=~phiPi, y=~phiX, z=~psiB, color=~Regime, colors=thisColors) %>%
  layout(title = paste0(testStr, " set (90% confidence)"),
         scene=list(
           xaxis = list(title=plotly::TeX("\\phi_{pi}"), 
                        tickvals=seq(from=PARAMS_CFG$minVal[2], to=PARAMS_CFG$maxVal[2], by=0.5),
                        range=c(PARAMS_CFG$minVal[2], PARAMS_CFG$maxVal[2])),
           yaxis = list(title=plotly::TeX("\\phi_{x}"),  
                        tickvals=seq(from=PARAMS_CFG$minVal[3], to=PARAMS_CFG$maxVal[3], by=0.5),
                        range=c(PARAMS_CFG$minVal[3], PARAMS_CFG$maxVal[3])),
           zaxis = list(title=plotly::TeX("\\psi_{B}"),
                        tickvals=seq(from=PARAMS_CFG$minVal[PARAMS_CFG$name=='psiB'],                                                        to=PARAMS_CFG$maxVal[PARAMS_CFG$name=='psiB'], by=0.5),
                        range = c(PARAMS_CFG$minVal[PARAMS_CFG$name=='psiB'],
                                  PARAMS_CFG$maxVal[PARAMS_CFG$name=='psiB'])))) 
pScatter3D <- pBase %>%
  add_trace(type="scatter3d", mode='markers',
            marker = list(size = 3,
                          text = ~paste(PCONF, ' confidence set'))) 

pScatter3D %>%
  config(mathjax = "cdn")

try(close3d())

open3d() # see https://cran.r-project.org/web/packages/rgl/vignettes/rgl.html#documents-with-rgl-scenes
#options(rgl.useNULL=FALSE)
# Left Top Right Bottom
par3d(windowRect = c(0, 23, 1280, 689))
par3d(cex=1.5) # text size
title3d(main=NULL, sub=setName, 
        xlab=latex2exp::TeX(r"($\phi_{\pi})"), 
        ylab=latex2exp::TeX(r"($\phi_{X}$)"), 
        zlab=latex2exp::TeX(r"($\psi_{b}$)"),
        cex=2)

axes3d(floating=TRUE)
limParamSpace %>% 
  {points3d('x'=.$phiPi, 'y'=.$phiX, 'z'=.$psiB, size=30, color='orange', add=TRUE)}
grid3d(c("x", "y+", 'z'))
# Useless background to add the title
bgplot3d({
  plot.new()
  title(main = paste0(setName, ' 90\\%'), line = 3)
  mtext(side = 1, samSpecs$fullName, line = 4)
  