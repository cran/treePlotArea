#' Get Default Options for \pkg{treePlotArea}
#'
#' Used to see (not \emph{set}) the default options set by \pkg{treePlotArea}.
#' Use \code{\link{set_options}} to change these default values.
#'
#' @return A named list.
#' It has the following entries giving the column names of the
#' angle count or boundary data that hold information on:
#' \describe{
#'     \item{angle_counts}{ \describe{
#'         \item{tract_id}{The tract id.}
#'         \item{corner_id}{The corner id.}
#'         \item{tree_id}{The tree id.}
#'         \item{distance}{The distance from the center of the tract's corner.}
#'         \item{azimuth}{The azimuth from North.}
#'         \item{dbh}{The diameter at breast height.}
#'     }}
#'     \item{boundaries}{ \describe{
#'         \item{tract_id}{The tract id.}
#'         \item{corner_id}{The corner id.}
#'         \item{boundary_type}{Type of boundary.}
#'         \item{boundary_status}{Validity of the boundary.}
#'         \item{distance_start}{The starting point's distance.}
#'         \item{distance_flexing}{The flexing point's distance.}
#'         \item{distance_end}{The ending point's distance.}
#'         \item{azimuth_start}{The starting point's azimuth.}
#'         \item{azimuth_flexing}{The flexing point's azimuth.}
#'         \item{azimuth_end}{The ending point's azimuth.}
#'         }}
#' }
#' @family option functions
#' @export
#' @examples
#' get_defaults()
get_defaults <- function() {
    res <- list(angle_counts = list(tract_id = "tnr",
                                    corner_id = "enr",
                                    tree_id = "bnr",
                                    distance = "hori",
                                    azimuth = "azi",
                                    dbh = "bhd"),
                boundaries = list(tract_id = "tnr",
                                  corner_id = "enr",
                                  boundary_type = "rart",
                                  boundary_status = "rk",
                                  distance_start = "spa_m",
                                  distance_flexing = "spk_m",
                                  distance_end = "spe_m",
                                  azimuth_start = "spa_gon",
                                  azimuth_flexing = "spk_gon",
                                  azimuth_end = "spe_gon")
                )
    return(res)
}

#' Set Default Options for \pkg{treePlotArea}
#'
#' Just convenience function for \code{\link{options}}.
#' \pkg{treePlotArea} has a set of default options to define the columns of the
#' \code{\link{data.frame}s} that are passed to
#' \code{\link{get_correction_factors}}.
#' See \code{\link{get_defaults}} for a description of these options.
#' @param ... See \code{\link{options}}.
#' Leave empty to initialize the defaults if need be.
#' @template return_invisibly_true
#' @family option functions
#' @export
#' @examples
#' # Set the default
#' set_options()
#' getOption("treePlotArea")
#' # Overwrite some
#' option_list <- list(angle_counts = list(dbh = "diameter"),
#'                     boundaries = list(boundary_status = "boundart_stat"))
#' set_options(angle_counts = option_list[["angle_counts"]],
#'             boundaries = option_list[["boundaries"]])
#' getOption("treePlotArea")$angle_counts$dbh
#' # restore default
#' option_list <- get_defaults()
#' set_options(angle_counts = option_list[["angle_counts"]],
#'             boundaries = option_list[["boundaries"]])
#' getOption("treePlotArea")$angle_counts$dbh
set_options <- function(...) {
    res <- FALSE
    set_defaults()
    option_list <- list(...)
    index <- !names(option_list) %in% names(get_defaults())
    if (any(index)) {
        throw(paste0("Option(s) `",
                    paste(names(option_list[index]), collapse = ", "),
                    "` not defined as default(s) for package treePlotArea."))
    } else {
        for (i in seq(along = option_list)) {
            l <- option_list[[i]]
            d <- get_defaults()[[names(option_list[i])]]
            index  <- ! names(l) %in% names(d)
            if (any(index)) {
                throw(paste0("Options for ",
                            names(option_list[i]), " may not contain `",
                            paste(names(l)[index], collapse = "`, `"),
                            "` for package treePlotArea."))
            }
        }
        res <- fritools::set_options(..., package_name = "treePlotArea",
                                     overwrite = TRUE)
    }
    return(invisible(res))
}

set_defaults <- function() {
  defaults <- get_defaults()
  res <- fritools::set_options(defaults, package_name = "treePlotArea",
                               overwrite = FALSE)
  return(res)
}

get_options <- function(type = c("angle_counts", "boundaries", "all")) {
    set_defaults()
    t <- match.arg(type)
    if (t == "all") {
        res <- fritools::get_options(package_name = "treePlotArea",
                                     flatten_list = FALSE)
    } else {
        res <- fritools::get_options(package_name = "treePlotArea",
                                     flatten_list = FALSE)[[t]]
    }
    return(res)
}
