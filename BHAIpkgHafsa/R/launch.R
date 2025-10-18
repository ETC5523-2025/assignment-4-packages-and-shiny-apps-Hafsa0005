#' Launch the HAI Explorer Shiny App
#'
#' This function launches the interactive Shiny application included in the
#' BHAIpkgHafsa package. The app allows users to explore healthcare-associated
#' infection (HAI) burden data by infection type with interactive plots and tables.
#'
#' @return Starts a Shiny app in your default web browser.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   launch_haiexplorer()
#' }

launch_haiexplorer <- function() {
  app_dir <- system.file("shiny", package = "BHAIpkgHafsa")

  if (app_dir == "") {
    stop("Could not find the Shiny app directory. Please reinstall the BHAIpkgHafsa package.",
         call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = "normal")
}

