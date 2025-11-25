split_coords <- function(coords, counting_factor) {
    res <- do.call("rbind", apply(coords, 1, split_coord, counting_factor = counting_factor, simplify = FALSE))
    return(res)
}
