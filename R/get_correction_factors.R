# FIXME: I need status codes for trees and boundaries in different scales,
# they need to be converted to logical
get_status_codes <- function() {
    res  <- c("regular tree" = 0,
              "azimuth not in [0, 400]" = 1,
              "distance <= 0" = 2,
              "dbh <= 0" = 3,
              "dbh missing" = 4,
              "tree behind boundary" = 10,
              "corner's center outside tree's plot area" = 20,
              "error in angle_counts" = 30)
    return(res)
}
is_tree_behind_a_boundary <- function(tree, boundaries) {
    st_boundaries <- sf::st_polygon(boundaries)
    any(sapply(st_boundaries,
               function(x, t = tree) {
                   sf::st_contains(sf::st_polygon(list(x)),
                                   sf::st_point(c(t[["x"]], t[["y"]])),
                                   sparse = FALSE)
               },
               ))
}

check_tree <- function(x) {
    options <- get_options("angle_counts")
    status_codes <- get_status_codes()
    if (x[[options[["azimuth"]]]] < 0 ||
        x[[options[["azimuth"]]]] > 400) {
        res <- status_codes["azimuth not in [0, 400]"]
    } else if (x[[options[["distance"]]]] <= 0) {
        res <- status_codes["distance <= 0"]
    } else if (is.na(x[[options[["dbh"]]]])) {
        res <- status_codes[["dbh missing"]]
    } else if (x[[options[["dbh"]]]] <= 0) {
        res <- status_codes[["dbh <= 0"]]
    } else if (get_boundary_radius(x[[options[["dbh"]]]], unit = "cm") <
               x[[options[["distance"]]]]) {
        res <- status_codes[["corner's center outside tree's plot area"]]
    } else {
        res <- status_codes[["regular tree"]]
    }
    return(res)
}

get_correction_factor <- function(x, boundaries, stop_on_error = FALSE,
                                  is_skip_check = FALSE, counting_factor = 4) {
    options <- get_options("angle_counts")
    status_codes <- get_status_codes()
    if (inherits(boundaries, "boundaries")) {
        boundary_polygons <- boundaries
    } else {
        boundary_polygons <- get_boundary_polygons(boundaries, stop_on_error)
    }
    if (is.data.frame(x)) {
        tree <- x
    } else {
        tree <- as.data.frame(as.list(x))
    }
    check <- check_tree(tree)
    if (fritools::is_success(check) || isTRUE(is_skip_check)) {
        t <- as.character(tree[[options[["tract_id"]]]])
        e <- as.character(tree[[options[["corner_id"]]]])
        b <- boundary_polygons[[t]][[e]]
        if (is.null(b)) {
            correction_factor <- 1
            code <- status_codes[["regular tree"]]
        } else {
            tree[, c("x", "y")] <- bwi2cartesian(tree[[options[["azimuth"]]]],
                                                 tree[[options[["distance"]]]])
            if (is_tree_behind_a_boundary(tree, b)) {
                correction_factor <- 0
                code <- status_codes[["tree behind boundary"]]
            } else {
                cir <- tree2polygon(tree, counting_factor = counting_factor)
                pc <- get_partial_circle(cir, b)
                correction_factor <- sf::st_area(sf::st_polygon(list(cir))) /
                    sf::st_area(pc)
                code <- status_codes[["regular tree"]]
            }
        }
    } else {
        correction_factor <- 0
        code <- check
    }
    res <- list(correction_factor = correction_factor, code = code)
    return(res)
}

#' Correction Factors for Tree Plot Areas Intersected by Stand Boundaries
#'
#' Get correction factors for an angle count table (i.e. a
#' \code{\link{data.frame}}) and a corresponding boundary
#' table (i.e. a \code{\link{data.frame}}).
#'
#' The columns in the names have to be named according to the values of
#' \code{getOption("treePlotArea")}.
#' If they do not: you can either rename the columns
#' or set the option accordingly, probably using \code{\link{set_options}}.
#' @param angle_counts A \code{\link{data.frame}} containing angle counts.
#' It has to have columns named by the contents of
#' either\cr
#' \code{\link{get_defaults}()[["angle_counts"]]} or \cr
#' \code{getOption("treePlotArea")[["angle_counts"]]}.\cr
#' Could be
#' \code{bw2bwi2022de(get(data("trees", package = "treePlotArea")))}).
#' @param boundaries A \code{\link{data.frame}} containing boundaries.
#' It has to have columns named by the contents of
#' either\cr
#' \code{\link{get_defaults}()[["boundaries"]]} or \cr
#' \code{getOption("treePlotArea")[["boundaries"]]}.\cr
#' Could be
#' \code{get(data("boundaries", package = "treePlotArea"))} or the
#' output of
#' \code{\link{get_boundary_polygons}}.
#' @param verbose Be verbose?
#' @param counting_factor The basal area factor used in counting the trees. For
#' tally trees in the German national forest inventory its value is 4 [m^2].
#' @param stop_on_error Passed to \code{\link{get_boundary_polygons}}.
#' @param skip_check We usually check if the angle counts are
#' suitable
#' (for example whether a diameter at breast height, a horizontal distance and
#' an azimuth
#' measurement are given). Skip this check? This might be of interest if you
#' want to check whether another plot with no dbh recorded (for example a
#  deadwood plot (radius 5 m, centered around the
#' corner) is intersected by a boundary.
#' @seealso set_options
#' @return A  \code{\link{data.frame}} containing the correction factors and a
#' status giving information on possibly errors.
#' @export
#' @examples
#' data("trees", "boundaries", package = "treePlotArea")
#'
#' # For CRAN's sake: draw a subset
#' tracts <-  c(sample(boundaries[["tnr"]], 20), 10056)
#'
#' # Calculate correction factors
#' trees <- subset(trees, tnr %in% tracts)
#' boundaries <- subset(boundaries, tnr %in% tracts)
#' angle_counts <- bw2bwi2022de(trees)
#' validate_data(x = boundaries)
#' validate_data(x = angle_counts)
#' boundary_polygons <- get_boundary_polygons(boundaries)
#' correction_factors <- get_correction_factors(angle_counts, boundary_polygons)
#' summary(correction_factors$status)
#'
#' #  Select valid angle count trees only
#' valid_angle_counts <- select_valid_angle_count_trees(angle_counts)
#' correction_factors <- get_correction_factors(valid_angle_counts,
#'                                              boundary_polygons)
#' summary(correction_factors$status)
#'
#' # Select a single tree
#' tnr <- 10056
#' enr <- 4
#' bnr <- 3
#' tree <- valid_angle_counts[valid_angle_counts[["tnr"]] == tnr &
#'                      valid_angle_counts[["enr"]] == enr &
#'                      valid_angle_counts[["bnr"]] == bnr, TRUE]
#' bounds <- boundaries[boundaries[["tnr"]] == tnr & boundaries[["enr"]] == enr,
#'                      TRUE]
#' get_correction_factors(tree, bounds)
#'
#' # Dead wood plots:
#' dead_wood_plots <- unique(trees[TRUE, c("tnr", "enr")])
#' dead_wood_plots[["bnr"]] <- 0
#' dead_wood_plots[["hori"]] <- 0
#' dead_wood_plots[["azi"]] <- 0
#' dead_wood_plots[["bhd"]] <- 200
#' get_correction_factors(dead_wood_plots, boundary_polygons,
#'                        skip_check = TRUE)
#' # Set the deadwood plot's radius to 500 mm
#' dead_wood_plots[["bhd"]] <- 5000
#' # The counting factor has unit square meters per area.
#' # Area is hardcoded to 10000 [square meters], so to get a plot radius that's
#' # equal to the dbh, we need 2 * sqrt(counting_factor) / sqrt(10000) to be
#' # equal to 1.
#' get_correction_factors(dead_wood_plots, boundary_polygons,
#'                        skip_check = TRUE,
#'                        counting_factor = 2500)
get_correction_factors <- function(angle_counts, boundaries,
                                   verbose = TRUE, stop_on_error = FALSE,
                                   skip_check = FALSE,
                                   counting_factor = 4) {
    options <- get_options("angle_counts")
    status_codes <- get_status_codes()
    if (inherits(boundaries, "boundaries")) {
        boundary_polygons <- boundaries
    } else {
        stop <- stop_on_error
        boundary_polygons <- get_boundary_polygons(boundaries,
                                                   stop_on_error = stop)
    }
    k <- nrow(angle_counts)
    if (isTRUE(verbose) && k > 100) {
        pb <- utils::txtProgressBar(min = 0, max = k, style = 3)
    }
    correction_factor <- NULL
    error_func <- function(x) {
        res <- c(NA, as.numeric(x["error in angle_counts"]))
        return(res)
    }
    for (i in 1:k) { # apply() is much slower than the loop?!!!
        t <- angle_counts[i, TRUE]
        cf <- tryCatch(get_correction_factor(t, boundary_polygons,
                                             is_skip_check = skip_check,
                                             counting_factor = counting_factor),
                       error = error_func(status_codes))
        correction_factor <- rbind(correction_factor,
                                   cbind(t[[options[["tract_id"]]]],
                                         t[[options[["corner_id"]]]],
                                         t[[options[["tree_id"]]]],
                                         rbind(unlist(cf))))
        if (isTRUE(verbose) && k > 100) {
            utils::setTxtProgressBar(pb, i)
        }
    }
    if (isTRUE(verbose) && k > 100) {
        close(pb)
    }
    res <- as.data.frame(correction_factor)
    names(res) <- c(options[["tract_id"]], options[["corner_id"]],
                    options[["tree_id"]], "correction_factor", "status")
    res[["status"]] <- factor(res[["status"]],
                              labels = names(status_codes),
                              levels = status_codes)
    return(res)
}
