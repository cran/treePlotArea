# for manually double checking on trees and boundaries - no need to export!
# We just calculate
# the intersection between line from plot through tree and the boundary.
# We then return its distance form plot and the tree's distance from plot and
# the value from is_tree_behind_a_boundary().
tree_and_boundary <- function(tree, boundary) {
    options <- get_options("angle_counts")
    azi <- tree[[options[["azimuth"]]]]
    dist <- tree[[options[["distance"]]]]
    tmp <- tree
    tmp[, c("x", "y")] <- bwi2cartesian(azi, dist)
    boundary_polygons <- get_boundary_polygons(boundary)
    t <- as.character(tmp[[options[["tract_id"]]]])
    e <- as.character(tmp[[options[["corner_id"]]]])
    b <- boundary_polygons[[t]][[e]]
    res <- list(is_tree_behind_a_boundary = is_tree_behind_a_boundary(tmp, b))

    coords <- boundaries2coords(boundary)
    bl <- points2equation(coords[c("x1", "y1")], coords[c("x0", "y0")])
    tl <- points2equation(p1 = c(tmp[["x"]], tmp[["y"]]), p2 = c(0, 0))
    # schnittpunkt berechnen, dessen entfernung mit hori vergleichen
    res["distance_boundary"] <- vector_length(get_intersection(tl, bl))
    res["distance_tree"] <- tmp[["hori"]]
    return(res)
}
