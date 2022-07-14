get_current_boundaries <- function(x) {
    boundary_column  <- get_options("boundaries")[["boundary_status"]]
    res <- x[x[[boundary_column]] < 9, TRUE]
    return(res)
}
