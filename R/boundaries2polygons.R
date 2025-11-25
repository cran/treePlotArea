boundaries2polygons <- function(x, use_only_two_boundaries = TRUE, counting_factor) {
    current_boundaries <- get_current_boundaries(x)
    if (isTRUE(use_only_two_boundaries) && nrow(current_boundaries) > 2)
        current_boundaries <- delete_extraneous_boundaries(current_boundaries)
    coords <- boundaries2coords(current_boundaries)
    coords_split <- split_coords(coords, counting_factor = counting_factor)
    res <- apply(coords_split, 1, get_polygon,
                 r = 2 * get_r_max(counting_factor = counting_factor), 
                 simplify = FALSE)
    return(res)
}
