
samIDstr = '
A98_W98undRest_B2L_nz_99FT01q3
A98_W97undRest_B2L_nz_99FT01q3
A98_W99t01q3undRest_B2L_nz_99FT01q3
'

IDSAMS <-  str_split(samIDstr, "\\n", simplify=TRUE) %>% .[1,] %>% 
  str_trim(., side='both') %>%
  .[2:(length(.)-1)]

library(tidyverse)
library(purrr)
library(readODS)


purrr::walk(IDSAMS, function(idSam) { 
  
  print(idSam)
  Sys.sleep(4)
  
  
  samS <- read_ods('../Data/sams_specs_BAFA.ods') %>% filter(IDSAM == idSam)
  if(NROW(samS) > 1) { stop(paste0("The provided SAMID, ", idSam, " is NOT unique!")) }
  if(NROW(samS) == 0) { stop(paste0("The provided SAMID, ", idSam, " cant be found!")) }
  
  # The input file must have been saved and the sample_spaces chunk run!
  #inputRmdFile <- 'code/build_panel_sam_dev.Rmd'
  inputRmdFile <- 'build_sam_dev.Rmd'
  
  #outFileHTML <- paste0('presentations/PhD Conference 34/', specs$savingFolder, specs$idSample, '.html')
  outFileHTML <- paste0("../data/SAMS/", idSam, '.html')

    if (file.exists(outFileHTML)) {
    print('The file already exists!')
  } else {
    rmarkdown::render(
      inputRmdFile,
      output_file = outFileHTML,
      params = list('IDSAM'=idSam),
      envir = globalenv() )
  }
  
  
})
