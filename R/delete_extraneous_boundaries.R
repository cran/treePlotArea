delete_extraneous_boundaries <- function(x) {
    rart_var <- get_options("boundaries")[["boundary_type"]]
    res <- x
    if (nrow(res) > 2) {
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
