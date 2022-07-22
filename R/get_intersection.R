#' Get Intersection Point of Two Lines
#'
#' Get the intersection point of two straight lines given in slope–intercept
#' form.
#' @param x  A named vector with intercept ["a"] and slope ["b"].
#' @param y  A named vector with intercept ["a"] and slope ["b"].
#' @return A named vector giving the intersection, \code{\link{NULL}} if the
#' lines do not intersect,  \code{\link{NaN}} if they are identical.
#' @keywords internal
#' @export
#' @family geometry functions
#' @examples
#' get_intersection(x = c(a = 0, b = 1), y = c(a = 2, b = -1))
#' get_intersection(x = c(a = 0, b = 1), y = c(a = 2, b = 1))
#' x <- c(a = 0, b = 1)
#' get_intersection(x = x, y = x)
get_intersection <- function(x, y) {
    xi <- (y["a"] - x["a"]) / (x["b"] - y["b"])
    yi <- x["a"] + x["b"] * xi
    res <- c(x = unname(xi), y = unname(yi))
    if (all(is.infinite(res))) res <- NULL
    if (all(is.nan(res))) res <- NaN
    return(res)
}
