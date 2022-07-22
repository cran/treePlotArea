#' Give the Length of a Vector
#'
#' A vector given by two points in a plane.
#' @param p1 The first point (x, y).
#' @param p2 The second point (x, y).
#' @return The length of the vector.
#' @keywords internal
#' @export
#' @family geometry functions
#' @examples
#' p1 <- c(0, 4)
#' vector_length(p1)
#' p2 <- c(3, 4)
#' vector_length(p1, p2)
vector_length <- function(p1, p2 = c(0, 0)) {
    x <- p1 - p2
    res <- sqrt(sum(as.numeric(x)^2))
    return(res)
}
