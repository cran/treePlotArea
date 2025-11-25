#' Convert Boundaries to Polygons
#'
#' Used by \code{\link{get_correction_factors}} to convert a boundary table
#' to polygons. You may want to see the polygons, that is why we exported this
#' function.
#' @inheritParams get_correction_factors
#' @param stop_on_error Throw an error if invalid boundaries are encountered?
#' (There was tract 6878, corner 1, boundary 1 in the federal
#' database for the 2012 survey, runs through the plot.
#' There is no stand defined that way!).
#' @param clean_data Omit invalid boundaries in any further calculations?
#' @return A list with all boundary polygons for each corner for each tract.
#' @export
#' @family boundary functions
#' @examples
#' boundaries <- get(data("boundaries", package = "treePlotArea"))
#' boundary_polygons <- get_boundary_polygons(boundaries)
get_boundary_polygons <- function(boundaries, stop_on_error = TRUE,
                                  clean_data = FALSE, counting_factor = 4) {
    options <- get_options("boundaries")
    current_boundaries <- get_current_boundaries(boundaries)
    current_boundaries <- check_boundaries(current_boundaries,
                                           stop_on_error = stop_on_error,
                                           clean_data = clean_data)
    tract <- options[["tract_id"]]
    corner <- options[["corner_id"]]
    res <- fritools::tapply(current_boundaries,
                            index = list(current_boundaries[[tract]]),
                            function(boundaries) {
                                fritools::tapply(boundaries,
                                                 boundaries[[corner]],
                                                 boundaries2polygons,
                                                 counting_factor = counting_factor,
                                                 simplify = FALSE)
                            },
                            simplify = FALSE)
    class(res) <- c(class(res), "boundaries")
    return(res)
}
