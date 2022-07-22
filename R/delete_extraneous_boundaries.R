delete_extraneous_boundaries <- function(x) {
    res <- x
    o <- get_options("boundaries")

    # more than two boundaries in survey data -> delete some.
    if (nrow(res) > 2) {
        rart_var <- o[["boundary_type"]]
        if (1 %in% res[[rart_var]]) {
            res <- res[res[[rart_var]] == 1, TRUE]
            if (nrow(res) > 2) {
                res <- res[1:2, TRUE]
            }
        } else {
            res <- res[1:2, TRUE]
        }
    }
    return(res)
}
