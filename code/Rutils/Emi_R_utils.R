library(DT)
# Descriptive statistics
# Data is a data frame where each column is a variable. Make sure data only contains the variables you are interested in computing desc stats.
# The output is a tibble that can be later send to DT::datatable where each row is a variable and each column is a measure (e.g, mean, SD) 
descStats2 <- function(data) {
  #data <- Sams[[1]]
  #varList <- c('i_t', 's_t')
  dSVals <- data %>% 
    summarise(across(everything(), 
                     list(
                       'min' = ~min(.x, na.rm=TRUE),
                       'median' = ~median(.x, na.rm=TRUE),
                       'mean' = ~mean(.x, na.rm=TRUE),
                       'max' = ~max(.x, na.rm=TRUE),
                       'SD' = ~sd(.x, na.rm=TRUE),
                       #'kurtosis' = ~round(e1071::kurtosis(.x, na.rm=TRUE)),
                       'numObs' = ~sum(!is.na(.x)))))
  
  colName = c('min', 'median', 'mean', 'max', 'SD')
  out <- map_dfc(colName, function(colName) {
    colVector <- select(dSVals, ends_with(colName)) %>%
      map_dbl(., function(col) { 
        as_vector(col)
        round(col, digits=3) 
      })
  })
  descStatsTibble <- tibble('variable' = names(data), 
                            'min' = as_vector(select(dSVals, ends_with('min'))),
                            'median' = as_vector(select(dSVals, ends_with('median'))),
                            'mean' = as_vector(select(dSVals, ends_with('mean'))),
                            'SD' = as_vector(select(dSVals, ends_with('sd'))),
                            'max' = as_vector(select(dSVals, ends_with('max'))),
                            'CV' = as_vector(SD/mean),
                            #'kurtosis' = as_vector(select(dSVals, ends_with('kurtosis'))),
                            'numObs' = as_vector(select(dSVals, ends_with('numObs'))))
  
  descStatsTibble
  
}

# Descriptive statistics for panel data
# Data is a data frame where each row is an observation at time t
# varList is a vector of variables
descStatsT <- function (data, varList) {
  #data <- Sams[[1]]
  #varList <- c('i_t', 's_t')
  dSVals <- data %>% 
    summarise(across(all_of(!!varList), 
                     list(
                       'min' = ~min(.x, na.rm=TRUE),
                       'median' = ~round(median(.x, na.rm=TRUE)),
                       'mean' = ~mean(.x, na.rm=TRUE),
                       'max' = ~max(.x, na.rm=TRUE),
                       'SD' = ~sd(.x, na.rm=TRUE),
                       'CV' = SD/mean,
                       #'kurtosis' = ~round(e1071::kurtosis(.x, na.rm=TRUE)),
                       'numObs' = ~sum(!is.na(.x))
                     )))
  
  colName = c('min', 'median', 'mean', 'sd', 'cv', 'max')
  out <- map_dfc(colName, function(colName) {
    colVector <- select(dSVals, ends_with(colName)) %>%
      map_dbl(., function(col) { 
        as_vector(col)
        round(col, digits=3) 
      })
  })
  descStatsTibble <- tibble('min' = as_vector(select(dSVals, ends_with('min'))),
                            'median' = as_vector(select(dSVals, ends_with('median'))),
                            'mean' = as_vector(select(dSVals, ends_with('mean'))),
                            'sd' = as_vector(select(dSVals, ends_with('sd'))),
                            'max' = as_vector(select(dSVals, ends_with('max'))),
                            'cv' = as_vector(select(dSVals, ends_with('cv'))),
                            #'kurtosis' = as_vector(select(dSVals, ends_with('kurtosis'))),
                            'numObs' = as_vector(select(dSVals, ends_with('numObs')))
  )
  
  rownames(descStatsTibble) <- varList
  datatable(descStatsTibble) %>%
    formatRound(columns=c('min', 'median', 'mean', 'sd', 'cv', 'max'))  
  
}

# Generates a time stamp for files
time_Stamp = function () { return( paste0(substr(Sys.time(), start=12, stop=13), 
                                          substr(Sys.time(), start=15, stop=16),
                                          substr(Sys.time(), start=18, stop=19)) ) }
                                          
# INPUT: a (T x K) tibble
# OUTPUT: a K list in which each element is a string with the five num of column of table
# Ex: OUTPUT$colI = '-10; -4; 0; 3; 12'
five_Num_Str = function(table) {
	 imap(table,
        function(x, varName) {
          c(str_c(round(fivenum(x), 2), collapse='; '))
      })
}

# INPUT: a (T x K) tibble
# OUTPUT: a list that contains a string with the mean and 5 numbers (min, 25th, median, 75th, max) of each
# column of the input tibble 
# Ex: OUTPUT$colI = 'Mean: 0.22, -10; -4; 0; 3; 12'
desc_Stats <- function(table, naRm=FALSE, decimals=3, scNotation=FALSE) {
  formato = if_else(scNotation==TRUE, 'e', 'f') 
  imap(table,
        function(x, varName) {
          fig <- list('mean' = mean(x, na.rm=naRm),
                    'var' = var(x, na.rm=naRm),
                    'fiveNum' = fivenum(x))
          figStr <- map(fig, function(x) { formatC(x, digits=decimals, format=formato) })
          
          glue::glue("Mean: {figStr$mean}-Var: {figStr$var}-5Num: {str_c(figStr$fiveNum, collapse=';')}")
        
        })
}

save2Excel <- function(obj, sName, file) {
  write.xlsx2(obj, file, 
              sheetName=sName, append=TRUE)
}

df <- tibble('col1' = c('a'),
             'col2' = 3)
df_2_latex <- function(df) {
  
  content <- unite(df, col="str", sep=" & ") %>%
              {str_c(.$str,  collapse=" \\\\ \n")}
  header <- colnames(df)%>%
    str_c(., collapse = " & ") %>%
    str_c(.,"  \\\\ \n")
  cat(header)
  cat(content)
  cat("  \\\\ \n")
  cat("  \\\\ \n")
  
} 
# Converts a matrix to a latex matrix (outputs text)
matrix_2_latex <- function(matr) {
  
  printmrow <- function(x) {
    
    cat(cat(x,sep=" & "),"\\\\ \n")
  }
  
  cat("\n")
  cat("\\begin{bmatrix}","\n")
  body <- apply(matr,1,printmrow)
  cat("\\end{bmatrix}\n\n")
}