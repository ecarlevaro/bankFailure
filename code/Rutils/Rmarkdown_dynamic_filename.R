# The input file must have been saved and the sample_spaces chunk run!
inputRmdFile <- 'code/SAR/SAR_dev.Rmd'

fileName <- paste0('C:/Users/emi.ABLE-22868/OneDrive/UWA PhD/bankFailure/', specs$savingFolder, specs$idSample, '.html')

if (file.exists(fileName)) {
  print('The file already exists!')
} else {
  rmarkdown::render(
    inputRmdFile,
    output_file = fileName,
    envir = globalenv() )
}
  


