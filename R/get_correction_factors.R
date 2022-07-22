get_status_codes <- function() {
    res  <- c("corner has boundaries" = -1,
              "corner has no boundaries" = 0,
              "tree behind boundary" = 1,
              "dbh = 0" = 2,
              "azimuth not in [0, 400]" = 10,
              "distance <= 0" = 11,
              "dbh <= 0" = 12,
              "error in angle_counts" = 20)
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
    } else if (x[[options[["dbh"]]]] <= 0) {
        res <- status_codes[["dbh <= 0"]]
    } else {
        res <- TRUE
    }
    return(res)
}

get_correction_factor <- function(x, boundaries, stop_on_error = FALSE) {
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
        tree <-  as.data.frame(as.list(x))
    }
    check <- check_tree(tree)
    if (isTRUE(check)) {
        t <- as.character(tree[[options[["tract_id"]]]])
        e <- as.character(tree[[options[["corner_id"]]]])
        b <- boundary_polygons[[t]][[e]]
        if (is.null(b)) {
            if (isTRUE(all.equal(tree[[options[["dbh"]]]], 0))) {
                correction_factor <- 1
                code <- status_codes[["dbh = 0"]]
            } else {
                correction_factor <- 1
                code <- status_codes[["corner has no boundaries"]]
            }
        } else {
            tree[, c("x", "y")] <- bwi2cartesian(tree[[options[["azimuth"]]]],
                                                 tree[[options[["distance"]]]])
            if (is_tree_behind_a_boundary(tree, b)) {
                correction_factor <- 0
                code <- status_codes[["tree behind boundary"]]
            } else {
                cir <- tree2polygon(tree)
                pc <- get_partial_circle(cir, b)
                correction_factor <- sf::st_area(sf::st_polygon(list(cir))) /
                    sf::st_area(pc)
                code <-  status_codes[["corner has boundaries"]]
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
#' \code{\link{get_defaults}("angle_counts")} or \cr
#' \code{fritools::get_options(package_name = "treePlotArea",
#'       flatten_list = FALSE )[["angle_counts"]]}.\cr
#' Could be
#' \code{bw2bwi2022de(get(data("trees", package = "treePlotArea")))}).
#' @param boundaries A \code{\link{data.frame}} containing boundaries.
#' It has to have columns named by the contents of
#' either\cr
#' \code{\link{get_defaults}("boundaries"} or \cr
#' \code{fritools::get_options(package_name = "treePlotArea",
#'       flatten_list = FALSE )[["boundaries"]]}.\cr
#' Could be
#' \code{get(data("boundaries", package = "treePlotArea"))} or the
#' output of
#' \code{\link{get_boundary_polygons}}.
#' @param verbose Be verbose?
#' @param stop_on_error Passed to \code{\link{get_boundary_polygons}}.
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
#' summary(correction_factors$info)
#'
#' #  Select valid angle count trees only
#' valid_angle_counts <- select_valid_angle_count_trees(angle_counts)
#' correction_factors <- get_correction_factors(valid_angle_counts,
#'                                              boundary_polygons)
#' summary(correction_factors$info)
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
get_correction_factors <- function(angle_counts, boundaries,
                                   verbose = TRUE, stop_on_error = FALSE) {
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
        cf <- tryCatch(get_correction_factor(t, boundary_polygons),
                       error = error_func(status_codes))
        correction_factor <- rbind(correction_factor,
                                   cbind(t[[options[["tract_id"]]]],
                                         t[[options[["corner_id"]]]],
                                         t[[options[["tree_id"]]]],
                                         rbind(unlist(cf)))
                                   )
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
