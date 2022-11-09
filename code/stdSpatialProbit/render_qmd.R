# The input file must have been saved and the sample_spaces chunk run!
inputRmdFile <- 'code/build_panel_sam_dev.Rmd'
#inputRmdFile <- 'Spatial probit MartinettiGeniaux2017.qmd'
#inputRmdFile <- 'quarto_test.qmd'

#outFileHTML <- paste0('presentations/PhD Conference 34/', specs$savingFolder, specs$idSample, '.html')
IDSAMS = 'A99_pastAvgW_creWs_b97q4_s01q4'


IDRESULT = 'stdSpProbit_W_creditors_debtors'
RESULT_TITLE = ""
RESULT_DESC = ""

#outFileHTML <- paste0("../../output/stdSpatialProbit/", IDRESULT, '.html')
outFileHTML <- paste0('A99_pastAvgW_creWs_b97q4_s01q4', '.html')

library(here)
library(tidyverse)
library(quarto)
here()
#WD = 'C:/Users/emi/OneDrive/UWA PhD/Fiscal_Monetary_Interaction/Codes/Plotting/'


#execute_params = list('IDSAMS' = IDSAMS,
#'TITLE' = RESULT_TITLE, 'DESC'=RESULT_DESC),

quarto::quarto_render(inputRmdFile, 
                      cache_refresh = FALSE,
                      output_file = outFileHTML)

