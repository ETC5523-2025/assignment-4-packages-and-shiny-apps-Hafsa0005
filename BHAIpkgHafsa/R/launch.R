#' Launch the HAI Explorer Shiny App
#'
#' Start the interactive Shiny application bundled with the `BHAIpkgHafsa`
#' package. The app visualises healthcare-associated infection (HAI) burden
#' by infection type and provides interactive plotting and summary tables.
#'
#' @return Invisibly returns the `shiny` application object (invisibly). The
#'   primary effect is to open a browser window or viewer containing the app.
#' @export
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

