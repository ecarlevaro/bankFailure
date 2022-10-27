# The input file must have been saved and the sample_spaces chunk run!
#inputRmdFile <- 'code/build_panel_sam_dev.Rmd'
inputRmdFile <- 'code/build_sam_dev.Rmd'

#outFileHTML <- paste0('presentations/PhD Conference 34/', specs$savingFolder, specs$idSample, '.html')

outFileHTML <- paste0("../data/SAMS/", specs$idSample, '.html')


if (file.exists(outFileHTML)) {
  print('The file already exists!')
} else {
  rmarkdown::render(
    inputRmdFile,
    output_file = outFileHTML,
    envir = globalenv() )
}
  
anti_join(avgRelations, samBanks, by=('IDENT_ACREEDORA' = 'IDENT'))
anti_join(avgRelations, samBanks, by=('IDENT_DEUDORA' = 'IDENT'))

