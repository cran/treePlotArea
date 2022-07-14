do_split <- function(boundary) {
    res <- is_boundary_encloses_origin(boundary)
    return(res)
}
