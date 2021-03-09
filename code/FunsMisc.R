save2Excel <- function(obj, sName, file) {
  write.xlsx2(obj, file, 
              sheetName=sName, append=TRUE)
}
