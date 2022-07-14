get_partial_circle <- function(circle, boundaries) {
    st_boundaries <- sf::st_polygon(boundaries)
    res <- sf::st_polygon(list(circle))
    for (b in st_boundaries) {
        res <- sf::st_difference(res, sf::st_polygon(list(b)))
    }
    return(res)
}
