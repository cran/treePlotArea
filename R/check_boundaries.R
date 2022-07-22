any_two_identical <- function(x) {
    tmp <- unname(x)
    res <- identical(tmp[1], tmp[2]) || identical(tmp[1], tmp[3]) ||
        identical(tmp[2], tmp[3])
    return(res)
}

check_boundaries <- function(x, stop_on_error = TRUE, clean_data = FALSE) {
    # boundaries with identical azimth values for an two measurements cut
    # through the origin. Get rid of them.
    options <- get_options("boundaries")
    res <- x
    azi <- res[TRUE, c(options[["azimuth_start"]], options[["azimuth_flexing"]],
                       options[["azimuth_end"]])]
    index_invalid <- apply(azi, 1, any_two_identical)
    if (any(index_invalid)) {
        msg <- paste0("Found boundary through the plot in corner ",
                      res[index_invalid, options[["corner_id"]]],
                      " of tract ", res[index_invalid, options[["tract_id"]]],
                      "!")
        if (isTRUE(stop_on_error)) {
            msg <- paste(msg, "\nStopping.")
            throw(msg)
        } else {
            if (isTRUE(clean_data)) {
                msg <- paste(msg, "\nDeleting that boundary.")
                res <- res[!index_invalid, TRUE]
            } else {
                msg <- paste(msg, "\n*Not* deleting that boundary.",
                             "How do you define `stand` here?")
            }
            warning(msg)
        }
    }
    return(res)
}
