#' Custom Knit function for RStudio
#' Compiles the current file to the input filename
#'
#' @export
knit_2_filename <- function(input, ...) {
  rmarkdown::render(
    input,
    output_file = input,
    envir = globalenv()
  )
}