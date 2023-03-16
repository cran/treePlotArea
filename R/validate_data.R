#' Validate Data and Optionally Delete Missing Data
#'
#' The 2012 data of the federal database contains tract 18063, corner 2.
#' There are boundaries recorded for that corner, nevertheless tree 14 has no
#' azimuth measurement. This function therefore checks for the data sets not
#' having missing
#' data in the columns needed by \code{\link{get_correction_factors}} and
#' optionally removes affected observations.
#' It does not cross check whether missing data is really needed (azimuth is
#' not when there is no boundary recorded for that tracts corner).
#' @param x  A tree or angle count data set.
#' @param type The type of data, stick with the default to let us guess.
#' @param clean Omit missing data? If the input contains missing data in the
#' columns needed by \code{\link{get_correction_factors}}, the affected
#' observations
#' may be deleted. Otherwise an error is thrown.
#' @export
#' @return  A tree data set. The input, if that was valid data, the cleaned
#' input otherwise. Throws an error if columns are missing.
#' @examples
#' boundaries <- get(data("boundaries", package = "treePlotArea"))
#' nrow(boundaries)
#' nrow(validate_data(x = boundaries))
#' boundaries[1, "enr"] <- NA
#' try(validate_data(boundaries))
#' nrow(validate_data(boundaries, clean = TRUE))
validate_data <- function(x, type = c(NA, "angle_counts", "boundaries"),
                          clean = FALSE) {
    data_type <- match.arg(type)
    if (is.na(data_type)) {
        o <- get_options("all")
        data_type <- names(o[sapply(o, function(y) all(y %in% names(x)))])
        message("Setting type to \"", data_type, "\".")
    }
    o <- get_options(data_type)
    if (all(o %in% names(x))) {
        df <- x[TRUE, unlist(o)]
        missing <- apply(df, 2, function(x) any(is.na(x)))
        # flexing points in boundaries may be missing, so we skip these:
        missing <- missing[!names(missing) %in% c(o[["azimuth_flexing"]],
                                                  o[["distance_flexing"]])]
        msg <- paste0("Data \"", deparse(substitute(x)), "\" passed.")
        if (any(missing)) {
            # flexing points in boundaries may be missing, so we skip these:
            df_names <- names(df)[!names(df) %in% c(o[["azimuth_flexing"]],
                                                    o[["distance_flexing"]])]
            msg <- paste0("Found missing values for \"",
                           paste(df_names[missing],
                                 collapse = "\", \""), "\". ")
            if (isTRUE(clean)) {
                omit <- stats::na.omit(df[TRUE, df_names])
                res <- x[-as.integer(attr(omit, "na.action")), TRUE]
                msg <- paste0(msg,
                              "Will omit these observations.\n",
                              "Original number of observations was ", nrow(df),
                              ",\nnow returning ", nrow(res), " observations.")
                warning(msg)
            } else {
                throw(msg)
            }
        } else {
            res <- x
        }
    } else {
        msg <- paste0("Can not find columns ",
                     paste(o[!o %in% names(x)], collapse = ", "),
                     " in ", deparse(substitute(x)), ".")
        throw(msg)
    }
    message(msg)
    return(invisible(res))
}
