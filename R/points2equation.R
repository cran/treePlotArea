#' Get a Slope–intercept Form from a Two-point Form of an Equation
#'
#' Two-point from is often seen in German national forest inventory data,
#' we want to get an equation of form
#' \emph{y = a + bx}.
#' @param p1 The first point (x, y).
#' @param p2 The second point (x, y).
#' @return A named vector with intercept ["a"] and slope ["b"].
#' If both points have the same value for x, no function exists. Then
#' the intercept is \code{\link{NA}} and the slope gives the value of x.
#' @export
#' @keywords internal
#' @examples
#' points2equation(c(0, 4), c(1, 5))
points2equation <- function(p1, p2 = c(0, 0)) {
    x1 <- as.numeric(p1[1])
    y1 <- as.numeric(p1[2])
    x2 <- as.numeric(p2[1])
    y2 <- as.numeric(p2[2])
    if (isTRUE(all.equal(x2, x1))) {
        b <- x2
        a <- Inf
    } else {
        b <- (y2 - y1) / (x2 - x1)
        a <- y1 - x1 * b
    }
    res <- c(a = a, b = b)
    return(res)
}
