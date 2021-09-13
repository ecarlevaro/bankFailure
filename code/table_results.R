library(modelsummary)
library(huxtable)
library(spatialreg)

models <- list('Linear OLS' = readRDS('output/linearOLS/Annual99/A99_Wtill98q4_creW_b97q4_s03q4_model.rds'),
        'Probit' = readRDS('output/probit/Annual99/p_A99_b97q4_fh03q4_reg.rds'),
        'Linear spatial autoregressive (SAR)' = readRDS('output/SAR/Annual99/A99_Wtill98q4_creW_b97q4_s03q4_model.rds'))

varNamesPub <- c('(Intercept)' = 'Intercept2', 'ActivoN'='Assets in ARS', 'C8Est_w'='Capital ratio ()', 
  'CAR_IRR_3A6'='Non performing loans ()', 'P_ROA'='ROA ()',
  'P_DEP_ARS_RATE'='Deposits interest rate ()',  'P_LOANS_ARS_RATE_W'='Loans interest rate ()', 
  'APRSpNF_RATE_W'='Govt. loans to loans ()', 'APR_USD_RATE'='USD nominated loans to loans ()', 
  'APR_RATE_W'='Loans-to-Assets ratio ()', 'rho'='rho')

modelsummary(models, 
             stars = c('*' = 0.15, '**'=0.10, '***'=0.05),
             coef_map = varNamesPub,
             #options(modelsummary_format_numeric_latex = "plain"),
             #output = 'huxtable')
              output = 'bankFailure_res_table.tex')