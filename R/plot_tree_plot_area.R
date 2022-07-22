#' Plot a Single Tree
#'
#' Visualize a tree, it's plot area and its corner's boundaries.
#' @inheritParams get_correction_factors
#' @param tnr Number of the tract.
#' @param enr Number of the tract's corner.
#' @param bnr Number of the corner's tree.
#' @param use_sub Use the subtitle (or leave it blank)? Stick with the default.
#' @param frame_factor Plotting from as a factor of the tree plot area. Stick
#' with the default.
#' @return The corrections factor for the tree's plot area
#' @export
#' @examples
#' tnr <- 166
#' enr <- 2
#' bnr <- 7
#' angle_counts <- bw2bwi2022de(get(data("trees", package = "treePlotArea")))
#' plot_tree_plot_area(angle_counts = angle_counts,
#'                     boundaries = get(data("boundaries",
#'                                           package = "treePlotArea")),
#'                     tnr =  tnr, enr = enr, bnr = bnr, frame_factor = 4)
plot_tree_plot_area <- function(angle_counts, boundaries, tnr, enr, bnr,
                                frame_factor = 4, use_sub = TRUE) {
    options <- get_options("all")
    o_a <- options[["angle_counts"]]
    o_b <- options[["boundaries"]]
    col_eff <- "green4"
    col_plot1 <- "black"
    col_plot2 <- "gray74"
    col_tree <- "red"
    col_tree_center <- "cyan"
    col_border_tetragon <- "blue"
    col_border_pentagon <- "yellow"
    col_boundaries <- "orange"

    tree <- angle_counts[angle_counts[[o_a[["tract_id"]]]] == tnr &
                         angle_counts[[o_a[["corner_id"]]]] == enr &
                         angle_counts[[o_a[["tree_id"]]]] == bnr,
                     TRUE]
    bounds <- boundaries[boundaries[[o_b[["tract_id"]]]] == tnr &
                         boundaries[[o_b[["corner_id"]]]] == enr,
                     TRUE]
    bounds <- get_current_boundaries(bounds)
    tree[, c("x", "y")]  <- bwi2cartesian(tree[[o_a[["azimuth"]]]],
                                          tree[[o_a[["distance"]]]])
    circ <- tree2polygon(tree)
    coords <- boundaries2coords(bounds)
    coords_split <- split_coords(coords)
    b <- boundaries2polygons(bounds)
    pc <- get_partial_circle(circ, b)

    plot(0, 0, col = col_plot1, pch = "+",
         xlim = c(-get_r_max() * frame_factor, get_r_max() * frame_factor),
         ylim = c(-get_r_max() * frame_factor, get_r_max() * frame_factor),
         xlab = "x [cm]", ylab = "y [cm]")
    plot(sf::st_polygon(list(circ)), border = col_tree, col = col_tree,
         add = TRUE)
    plot(pc, add = TRUE, border = col_eff, col = col_eff)
    plot(sf::st_polygon(b), add = TRUE, border = col_boundaries)
    graphics::abline(h = 0, col = col_plot1)
    graphics::abline(v = 0, col = col_plot1)
    plot(sf::st_polygon(list(circle2polygon(r = get_r_max()))), add = TRUE,
         border = col_plot1)
    plot(sf::st_polygon(list(circle2polygon(r = 2 * get_r_max()))), add = TRUE,
         border = col_plot2)
    graphics::points(tree[["x"]], tree[["y"]], pch = "+", col = col_tree_center)
    add_boundaries_to_plot(coords)
    add_boundaries_to_plot(as.data.frame(coords_split),
                           col = c(col_border_tetragon, col_border_pentagon))

    bl <- get_boundary_polygons(bounds)
    res <- get_correction_factor(tree, bl)["correction_factor"]
    if (isTRUE(use_sub)) {
        graphics::title(main = paste("tract:", tnr, "corner:", enr, "tree:",
                                     bnr),
                        sub = paste("correction factor:", res))
    } else {
        graphics::title(main = paste("tract:", tnr, "corner:", enr, "tree:",
                                     bnr,
                                     "correction factor:", res))
    }
    return(res)
}
