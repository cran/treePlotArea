split_coords <- function(coords) {
    res <- do.call("rbind", apply(coords, 1, split_coord, simplify = FALSE))
    return(res)
}
