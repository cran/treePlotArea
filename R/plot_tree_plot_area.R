#' Plot Tree Plot Area
#'
#' Visualize a corner, its boundaries and tree plot areas.
#' @inheritParams get_correction_factors
#' @param tnr Number of the tract.
#' @param enr Number of the tract's corner.
#' @param bnr If given, the number of a corner's tree.
#' @param use_sub Deprecated.
#' @param frame_factor Plotting from as a factor of the tree plot area. Stick
#' with the default.
#' @return A list with the corrections factors for the plot's trees' plot areas,
#' the plot's trees
#' and the plot's boundaries.
#' @export
#' @examples
#' tnr <- 166
#' enr <- 2
#' bnr <- 7
#' angle_counts <- bw2bwi2022de(get(data("trees", package = "treePlotArea")))
#' boundaries <- get(data("boundaries", package = "treePlotArea"))
#' plot_tree_plot_area(angle_counts = angle_counts,
#'                     boundaries = boundaries,
#'                     tnr =  tnr, enr = enr, bnr = bnr, frame_factor = 4)
#' plot_tree_plot_area(angle_counts = angle_counts,
#'                     boundaries = boundaries,
#'                     tnr =  tnr, enr = enr, frame_factor = 1)
#' tnr <- 9823
#' enr <- 1
#' bnr <- 2
#' plot_tree_plot_area(angle_counts = angle_counts,
#'                     boundaries = boundaries,
#'                     tnr =  tnr, enr = enr, bnr = bnr, frame_factor = 4)
#' plot_tree_plot_area(angle_counts = angle_counts,
#'                     boundaries = boundaries,
#'                     tnr =  tnr, enr = enr, frame_factor = 1)
plot_tree_plot_area <- function(angle_counts, boundaries, tnr, enr, bnr = NULL,
                                frame_factor = 1, use_sub = NULL, counting_factor = 4) {
    if (!is.null(use_sub)) warning("Argument `use_sub` is deprecated.")
    options <- get_options("all")
    o_a <- options[["angle_counts"]]
    o_b <- options[["boundaries"]]
    col_plot1 <- "black"
    col_plot2 <- "gray74"
    col_tree_center <- "brown"
    col_border_tetragon <- "blue"
    col_border_pentagon <- "yellow"
    col_boundaries <- "orange"

    trees <- angle_counts[angle_counts[[o_a[["tract_id"]]]] == tnr &
                          angle_counts[[o_a[["corner_id"]]]] == enr,
                      TRUE]
    bounds <- boundaries[boundaries[[o_b[["tract_id"]]]] == tnr &
                         boundaries[[o_b[["corner_id"]]]] == enr,
                     TRUE]
    bounds <- get_current_boundaries(bounds)
    bl <- get_boundary_polygons(bounds)
    correction_factors <- NULL
    plot(0, 0, col = col_plot1, pch = "+",
         xlim = c(-get_r_max(counting_factor = counting_factor) * frame_factor,
                  get_r_max(counting_factor = counting_factor) * frame_factor),
         ylim = c(-get_r_max(counting_factor = counting_factor) * frame_factor,
                  get_r_max(counting_factor = counting_factor) * frame_factor),
         xlab = "x [cm]", ylab = "y [cm]", asp = TRUE)
    if (!is.null(bnr)) {
        trees <- trees[trees[[o_a[["tree_id"]]]] == bnr, TRUE]
        col_eff <- "green4"
        col_tree <- "red"
        col_eff_b <- "green4"
        col_tree_b <- "red"
        is_single_tree <- TRUE
    } else {
        col_eff <- NA
        col_tree <- NA
        col_eff_b <- "green4"
        col_tree_b <- "red"
        is_single_tree <- FALSE
    }
    if (!identical(nrow(bounds), 0L)) {
        coords <- boundaries2coords(bounds)
        add_boundaries_to_plot(coords)
        coords_split <- split_coords(coords, counting_factor = counting_factor)
        add_boundaries_to_plot(as.data.frame(coords_split),
                               col = c(col_border_tetragon,
                                       col_border_pentagon))
        b <- boundaries2polygons(bounds, counting_factor = counting_factor)
        plot(sf::st_polygon(b), add = TRUE, border = col_boundaries)
    }
    plot(sf::st_polygon(list(circle2polygon(r = get_r_max(counting_factor = counting_factor)))),
         add = TRUE, border = col_plot1)
    plot(sf::st_polygon(list(circle2polygon(r = 2 * get_r_max(counting_factor = counting_factor)))),
         add = TRUE, border = col_plot2)
    graphics::abline(h = 0, col = col_plot1)
    graphics::abline(v = 0, col = col_plot1)


    for (i in seq_len(nrow(trees))) {
        tree <- trees[i, TRUE]
        tree[, c("x", "y")]  <- bwi2cartesian(tree[[o_a[["azimuth"]]]],
                                              tree[[o_a[["distance"]]]])
        circ <- tree2polygon(tree, counting_factor = counting_factor)
        plot(sf::st_polygon(list(circ)), border = col_tree_b, col = col_tree,
             add = TRUE)
        if (!identical(nrow(bounds), 0L)) {
            pc <- get_partial_circle(circ, b)
            plot(pc, add = TRUE, border = col_eff_b, col = col_eff)
        }
        if (is_single_tree) {
            graphics::points(tree[["x"]], tree[["y"]], pch = "+",
                             col = col_tree_center)
        } else {
            tree_basal_area <- circle2polygon(c(x = tree[["x"]],
                                                y = tree[["y"]]),
                                              tree[[o_a[["dbh"]]]]/10)
            plot(sf::st_polygon(list(tree_basal_area)), add = TRUE,
                 border = "black", col = "brown")
        }
        correction_factor <- get_correction_factor(tree, bl)
        correction_factor <- correction_factor[["correction_factor"]]
        correction_factors <- c(correction_factors, correction_factor)
        graphics::title(main = paste("tract:", tnr, "corner:", enr))
        if (isTRUE(is_single_tree)) {
            graphics::title(sub = paste("bnr:", tree[[o_a[["tree_id"]]]],
                                        "/ dbh:", tree[[o_a[["dbh"]]]],
                                        "/ correction factor:", correction_factors))

        } else {
            graphics::text(x = tree[["x"]], y = tree[["y"]],
                           labels = tree[[o_a[["tree_id"]]]], adj = c(0, 1))
        }

    }
    res <- list(correction_factors = correction_factors, boundaries = bounds, trees = trees)
    return(res)
}

