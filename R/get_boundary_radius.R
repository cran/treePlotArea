#' Get the Boundary Radius for a Given Diameter at Breast Height
#'
#' The boundary radius is the maximum distance a tree with a given diameter at
#' breast height may be
#' away from the center of the plot to still be part of the sample.
#' @param dbh Diameter at breast height in millimeter.
#' @param unit The unit for the return value.
#' @inheritParams get_correction_factors
#' @param area The reference surface in [m^2].
#' @details \code{counting_factor} and \code{area} really don't have to be
#' square meters as long as they are in the same unit.
#' @return Minimum diameter at breast height in \code{units}.
#' @export
#' @keywords internal
#' @examples
#' # A diameter at breast height of 50.5 cm
#' get_boundary_radius(505, unit  = "m")
#' get_boundary_radius(1000, unit  = "cm")
get_boundary_radius <- function(dbh, unit = c("mm", "cm",
                                              "dm", "m"),
                                counting_factor = 4,
                                area = 1e04) {
    u <- match.arg(unit)

    res <- .get_boundary_radius(dbh = dbh / 1000, area = area,
                                counting_factor = counting_factor)
    res <- switch(u,
                  "mm" = res * 1000,
                  "cm" = res * 100,
                  "dm" = res * 10,
                  "m" = res)
    attr(res, "unit") <- u
    return(res)
}

.get_boundary_radius <- function(dbh, counting_factor, area) {
    res <- sqrt(area) / sqrt(counting_factor) * dbh / 2
    return(res)
}
