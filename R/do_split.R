do_split <- function(boundary, counting_factor) {
    res <- is_boundary_encloses_origin(boundary, counting_factor)
    return(res)
}
