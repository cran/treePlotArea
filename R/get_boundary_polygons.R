#' Convert Boundaries to Polygons
#'
#' Used by \code{\link{get_correction_factors}} to convert a boundary table
#' to polygons. You may want to see the polygons, that is why we exported this
#' function.
#' @param boundaries A \code{\link{data.frame}} containing boundaries.
#' It has to have columns named by the contents of
#' either\cr
#' \code{\link{get_defaults}("boundaries")} or \cr
#' \code{fritools::get_options(package_name = "treePlotArea")[["boundaries"]]}.
#' \cr
#' Could be
#' \code{get(data("boundaries", package = "treePlotArea"))}.
#' @return A list with all boundary polygons for each corner for each tract.
#' @export
#' @examples
#' boundaries <- get(data("boundaries", package = "treePlotArea"))
#' boundary_polygons <- get_boundary_polygons(boundaries)
get_boundary_polygons <- function(boundaries) {
    options <- get_options("boundaries")
    current_boundaries <- get_current_boundaries(boundaries)
    tract <- options[["tract_id"]]
    corner <- options[["corner_id"]]
    res <- fritools::tapply(current_boundaries,
                            index = list(current_boundaries[[tract]]),
                            function(boundaries) {
                                fritools::tapply(boundaries,
                                                 boundaries[[corner]],
                                                 boundaries2polygons,
                                                 simplify = FALSE)
                            },
                            simplify = FALSE)
    class(res) <- c(class(res), "boundaries")
    return(res)
}
