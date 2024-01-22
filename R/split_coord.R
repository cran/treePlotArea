split_coord <- function(coord) {
    # split a triple of coords into to lines
    if (isTRUE(do_split(coord))) {
        res <- data.frame(x1 = c(coord[["x1"]], coord[["x0"]]),
                          y1 = c(coord[["y1"]], coord[["y0"]]),
                          x0 = c(NA, NA),
                          y0 = c(NA, NA),
                          x2 = c(coord[["x0"]], coord[["x2"]]),
                          y2 = c(coord[["y0"]], coord[["y2"]]))
    } else {
        res <- coord
    }
    return(res)
}
