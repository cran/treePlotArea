tree2polygon <- function(tree) {
    options <- get_options("angle_counts")
    boundary_radius <- get_boundary_radius(tree[[options[["dbh"]]]],
                                           unit = "cm")
    res <- circle2polygon(c(x = tree[["x"]], y = tree[["y"]]),
                          boundary_radius)
    return(res)
}
