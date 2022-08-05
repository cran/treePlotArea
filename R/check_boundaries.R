#' Check Validity of Boundaries
#'
#' There is a boundary (tract 6878, corner 1, boundary 1)in the federal database
#' for the 2012 survey that runs exactly through the plot. If that boundary
#' would be valid, at that corner the term "stand" is not defined.
#'
#' So we check for such boundaries. These are straight boundaries with identical
#' azimuth values for start and end, and flexed boundaries where azimuth values
#' for either start or end and the azimuth value for the nook are identical and
#' the nook is farther away form the plot than the corresponding start or end.
#' @param x A \code{\link{data.frame}} containing boundaries.
#' It has to have columns named by the contents of
#' either\cr
#' \code{\link{get_defaults}("boundaries")} or \cr
#' \code{fritools::get_options(package_name = "treePlotArea")[["boundaries"]]}.
#' \cr
#' Could be
#' \code{get(data("boundaries", package = "treePlotArea"))}.
#' @param stop_on_error Throw an error if invalid boundaries are found?
#' @param clean_data Get rid of invalid boundaries?
#' @return A (possibly cleansed) \code{\link{data.frame}} containing boundaries.
#' @export
#' @family boundary functions
check_boundaries <- function(x, stop_on_error = TRUE, clean_data = FALSE) {
    options <- get_options("boundaries")
    res <- x
    index_invalid <- apply(res, 1, goes_through_origin)
    if (any(index_invalid)) {
        msg <- paste0("Found boundary through the plot in corner ",
                      res[index_invalid, options[["corner_id"]]],
                      " of tract ", res[index_invalid, options[["tract_id"]]],
                      "!", sep = " ", collapse = "\n")
        if (isTRUE(stop_on_error)) {
            msg <- paste("\n", msg, "\nStopping.")
            throw(msg)
        } else {
            if (isTRUE(clean_data)) {
                msg <- paste(msg, "\nDeleting that boundary.")
                res <- res[!index_invalid, TRUE]
            } else {
                msg <- paste(msg, "\n*Not* deleting that boundary.",
                             "How do you define `stand` here?\n")
            }
            warning(msg)
        }
    }
    return(res)
}

goes_through_origin <- function(x) {
    options <- get_options("boundaries")
    res <- FALSE
    if (is.na(x[[options[["azimuth_flexing"]]]])) {
        # boundary has no nook
        # boundary runs from start through end to origin or the other way since
        if (x[[options[["azimuth_start"]]]] == x[[options[["azimuth_end"]]]])
            res <- TRUE
    } else {
        # boundary has nook
        if (# boundary runs from nook through start to origin
            x[[options[["azimuth_flexing"]]]] ==
                x[[options[["azimuth_start"]]]] &&
                x[[options[["distance_flexing"]]]] >
            x[[options[["distance_start"]]]] ||
                # boundary runs from nook through end to origin
                x[[options[["azimuth_flexing"]]]] ==
                x[[options[["azimuth_end"]]]] &&
                x[[options[["distance_flexing"]]]] >
            x[[options[["distance_end"]]]])
            res <- TRUE
    }
    return(res)
}
