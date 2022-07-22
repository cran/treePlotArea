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
#' @param stop_on_error Throw an error if invalid boundaries are encountered?
#' (There is at least one boundary in the 2022 survey,
#' tract 2607, corner 2, boundary 1, which exactly
#' splits the plot. There is no stand defined that way!).
#' @param clean_data Omit invalid boundaries in any further calculations?
#' @return A list with all boundary polygons for each corner for each tract.
#' @export
#' @examples
#' boundaries <- get(data("boundaries", package = "treePlotArea"))
#' # For the boundary in tract 2607, corner 2 the azimuth values in `spa_gon`
#' # and `spk_gon` are identical:
#' subset(boundaries, tnr == 2607) # It runs exactly through the plot!
#' try(boundary_polygons <- get_boundary_polygons(boundaries))
#' boundary_polygons <- get_boundary_polygons(boundaries, stop_on_error = FALSE)
#' # There are boundaries in  tract 2607, corner 1, and in corner 2:
#' length(boundary_polygons[["2607"]][["1"]])
#' length(boundary_polygons[["2607"]][["2"]])
#' boundary_polygons <- get_boundary_polygons(boundaries, stop_on_error = FALSE,
#'                                            clean_data = TRUE)
#' # Now there's boundaries in in tract 2607, corner 1, but not in corner 2:
#' length(boundary_polygons[["2607"]][["1"]])
#' length(boundary_polygons[["2607"]][["2"]])
get_boundary_polygons <- function(boundaries, stop_on_error = TRUE,
                                  clean_data = FALSE) {
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
                                                 simplify = FALSE)
                            },
                            simplify = FALSE)
    class(res) <- c(class(res), "boundaries")
    return(res)
}
