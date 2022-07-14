is_boundary_encloses_origin <- function(boundary) {
    if (has_nook(boundary)) {
        tri <- create_triangle(boundary, r = 1000 * get_r_max())
        res <- sf::st_contains(sf::st_polygon(list(tri)),
                               sf::st_point(c(0, 0)),
                               sparse = FALSE)

    } else {
        res <- FALSE
    }
    return(as.vector(res))
}
