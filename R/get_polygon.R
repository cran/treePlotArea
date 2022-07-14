get_polygon <- function(coord, r = 2 * get_r_max()) {
    if (is.matrix(coord)) {
            cv <- as.vector(coord)
            names(cv) <- colnames(coord)
    } else {
        cv <- coord
    }
    if (has_nook(cv)) {
        res <- create_pentagon(xy1xy0xy2 = cv, verbose = FALSE, r = r)
    } else {
        res <- create_tetragon(xy1xy2 = cv, verbose = FALSE, r = r)
    }
    return(res)
}
