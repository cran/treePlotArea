#' Calculate Intersections of Circle by a Straight Line
#'
#' The circle is centered a (0, 0) and has radius r, the line is given in
#' slope-intercept from.
#' @param a The secant's intercept.
#' @param b The secant's slope.
#' @param verbose Be verbose?
#' @param r The circle's radius
#' @return A matrix of x und y values. For a tangent, both rows are identical,
#' for a straight line missing the circle, a matrix of \code{\link{NA}}.
#' @export
#' @keywords internal
#' @examples
#' secant_intersections(a = 0, b = 1, r = 2)
#' # A tangent
#' secant_intersections(a = 2, b = 0, r = 2, verbose = TRUE)
#' # Missing the circle
#' secant_intersections(a = 3, b = 0, r = 2)
#' # Creating a circle boundary approximation
#' plot(0, 0, col = "red", pch = "+",
#'      xlim = c(-2, 2),
#'      ylim = c(-2, 2))
#' for (i in seq(-1, 1, by = 0.01)) {
#'          points(secant_intersections(Inf, i, 1), pch = "+")
#' }
secant_intersections <- function(a, b, r, verbose = FALSE) {
    if (is.infinite(a)) {
        x1 <- x2 <- as.numeric(b)
        y1 <- sqrt(abs(r^2 - b^2))
        y2 <- -y1
    } else {
        p <- (2 * a * b) / (b^2 + 1)
        q <- (a^2 - r^2) / (b^2 + 1)
        x1 <- suppressWarnings(- p / 2 + sqrt((p / 2)^2 - q))
        y1 <- a + b * x1
        x2 <- suppressWarnings(- p / 2 - sqrt((p / 2)^2 - q))
        y2 <- a + b * x2
    }
    res <- matrix(c(x1, y1, x2, y2), nrow = 2, byrow = TRUE,
                  dimnames = list(c("1", "2"), c("x", "y")))

    if (identical(res[1, TRUE], res[2, TRUE])) {
        if (all(is.na(res))) {
            warning("This line misses the circle!")
        } else {
            if (isTRUE(verbose)) message("This is a tangent only!")
        }
    }
    return(res)
}
