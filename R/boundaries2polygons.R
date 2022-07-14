boundaries2polygons <- function(x, use_only_two_boundaries = TRUE, ...) {
    current_boundaries <- get_current_boundaries(x)
    if (isTRUE(use_only_two_boundaries) && nrow(current_boundaries) > 2)
        current_boundaries <- delete_extraneous_boundaries(current_boundaries,
                                                           ...)
    coords <- boundaries2coords(current_boundaries)
    coords_split <- split_coords(coords)
    res <- apply(coords_split, 1, get_polygon, simplify = FALSE)
    return(res)
}
