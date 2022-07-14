#' Convert Coordinates of the German National Forest Inventory to Cartesian
#' Coordinates
#'
#' Coordinates of the German national forest inventory are measured in gon
#' eastward from north at distance in centimeter.
#' We need cartesian coordinates for relational computations.
#' @param azimuth The azimuths, from north, eastern side, in gon.
#' @param distance The distances from the origin, typically measured in
#' centimeter.
#' @return Matrix of cartesian coordinates in the unit of \code{distance}.
#' @export
#' @keywords internal
#' @examples
#' a1 <- c(0, 100)
#' d1 <- c(100, 200)
#' print(coords <- bwi2cartesian(a1, d1))
#' all.equal(coords, matrix(c(0, 100, 200, 0), nrow = 2, byrow = TRUE),
#'           check.attributes = FALSE)
bwi2cartesian <- function(azimuth, distance) {
    res <- polar2cartesian(geodatic2math(gon2degree(azimuth)), distance)
    return(res)
}
