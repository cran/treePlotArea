geodatic2math <- function(x, gon = FALSE) {
    if (isTRUE(gon)) {
        max <- 400
    } else {
        max <- 360
    }
    res <- max - x
    res <- ifelse(res < 3 / 4 * max, res + 90, res - 3 / 4 * max)
    return(res)
}
