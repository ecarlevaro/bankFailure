# The input file must have been saved and the sample_spaces chunk run!
setwd("C:/Users/emi.ABLE-22868/OneDrive/UWA PhD/bankFailure")
inputRmdFile <- 'code/build_panel_sam_dev.Rmd'

#outFileHTML <- paste0('presentations/PhD Conference 34/', specs$savingFolder, specs$idSample, '.html')

outFileHTML <- paste0("C:/Users/emi.ABLE-22868/OneDrive/UWA PhD/bankFailure/data/SAMS/", specs$idSample, '.html')


if (file.exists(outFileHTML)) {
  print('The file already exists!')
} else {
  rmarkdown::render(
    inputRmdFile,
    output_file = outFileHTML,
    envir = globalenv() )
}
  


