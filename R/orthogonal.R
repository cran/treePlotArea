#' Get the Slope–intercept Form of an Orthogonal
#'
#' If slope-point form of an equation is given, we might be interested in the
#' slope-intercept form of the orthogonal to the equation running through the
#' point.
#' @param b The slope.
#' @param xy The point.
#' @return A named vector with intercept ["a"] and slope ["b"], as in
#' \code{\link[graphics:abline]{graphics::abline}}.
#' If the slope was 0, there is no slope-intercept form as this is a vertical
#' line. Then the intercept is \code{\link{NA}} and the slope gives the value of
#' x.
#' @export
#' @keywords internal
#' @examples
#' orthogonal(1, c(x = 0, y = 0))
#' orthogonal(0, c(x = 4, y = 0))
#' orthogonal(-1, c(x = -2, y = -2))
#' orthogonal(Inf, c(x = 0, y = 4))
orthogonal <- function(b, xy) {
    if (identical(unname(b), 0)) {
        res <- c(a = Inf, b = unname(xy["x"]))
    } else {
        b1 <- - 1 / unname(b)
        a <- b1 * unname(xy["x"]) +  unname(xy["y"])
        res <- c(a = a, b = b1)
    }
    return(res)
}
