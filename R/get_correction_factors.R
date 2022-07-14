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

get_correction_factor <- function(x, boundaries) {
    options <- get_options("angle_counts")
    if (inherits(boundaries, "boundaries")) {
        boundary_polygons <- boundaries
    } else {
        boundary_polygons <- get_boundary_polygons(boundaries)
    }
    if (is.data.frame(x)) {
        tree <- x
    } else {
        tree <-  as.data.frame(as.list(x))
    }
    t <- as.character(tree[[options[["tract_id"]]]])
    e <- as.character(tree[[options[["corner_id"]]]])
    b <- boundary_polygons[[t]][[e]]
    if (!is.null(b)) {
        tree[, c("x", "y")] <- bwi2cartesian(tree[[options[["azimuth"]]]],
                                             tree[[options[["distance"]]]])
        if (is_tree_behind_a_boundary(tree, b) ||
            isTRUE(all.equal(tree[[options[["dbh"]]]], 0))) {
            c_factor <- 0
        } else {
            cir <- tree2polygon(tree)
            pc <- get_partial_circle(cir, b)
            c_factor <- sf::st_area(sf::st_polygon(list(cir))) / sf::st_area(pc)
        }
    } else {
        if (isTRUE(all.equal(tree[[options[["dbh"]]]], 0))) {
            c_factor <- 0
        } else {
            c_factor <- 1
        }
    }
    return(c_factor)
}

#' Correction Factors for Tree Plot Areas Intersected by Stand Boundaries
#'
#' Get correction factors for an angle count table (i.e. a
#' \code{\link{data.frame}}) and a corresponding boundary
#' table (i.e. a \code{\link{data.frame}}) .
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
#' @return A  \code{\link{data.frame}} containing the correction factors.
#' @export
#' @examples
#' data("trees", "boundaries", package = "treePlotArea")
#' # For CRAN's sake draw a subset
#' tracts <-  c(sample(boundaries$tnr, 20), 10056)
#' trees <- subset(trees, tnr %in% tracts)
#' boundaries <- subset(boundaries, tnr %in% tracts)
#' angle_counts <- bw2bwi2022de(trees)
#' boundary_polygons <- get_boundary_polygons(boundaries)
#' correction_factors <- get_correction_factors(angle_counts, boundary_polygons)
#' # Select a single tree
#' tnr <- 10056
#' enr <- 4
#' bnr <- 3
#' tree <- angle_counts[angle_counts[["tnr"]] == tnr &
#'                      angle_counts[["enr"]] == enr &
#'                      angle_counts[["bnr"]] == bnr, TRUE]
#' bounds <- boundaries[boundaries[["tnr"]] == tnr & boundaries[["enr"]] == enr,
#'                      TRUE]
#' get_correction_factors(tree, bounds)
get_correction_factors <- function(angle_counts, boundaries,
                                   verbose = TRUE) {
    options <- get_options("angle_counts")
    if (inherits(boundaries, "boundaries")) {
        boundary_polygons <- boundaries
    } else {
        boundary_polygons <- get_boundary_polygons(boundaries)
    }
    k <- nrow(angle_counts)
    if (isTRUE(verbose) && k > 100) {
        pb <- utils::txtProgressBar(min = 0, max = k, style = 3)
    }
    c_factor <- NULL
    for (i in 1:k) { # apply() is much slower than the loop?!!!
        t <- angle_counts[i, TRUE]
        c_factor <- rbind(c_factor,
                          cbind(t[[options[["tract_id"]]]],
                                t[[options[["corner_id"]]]],
                                t[[options[["tree_id"]]]],
                                get_correction_factor(t, boundary_polygons))
                          )
        if (isTRUE(verbose) && k > 100) {
            utils::setTxtProgressBar(pb, i)
        }
    }
    if (isTRUE(verbose) && k > 100) {
        close(pb)
    }
    res <- as.data.frame(c_factor)
    names(res) <- c(options[["tract_id"]], options[["corner_id"]],
                    options[["tree_id"]], "correction_factor")
    return(res)
}
