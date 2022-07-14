if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}
tnr <- 10056
enr <- 4
bnr <- 3
trees <- bw2bwi2022de(get0(data("trees", package = "treePlotArea")))
trees <- select_valid_angle_count_trees(trees)
boundaries <- get(data("boundaries", package = "treePlotArea"))
result <- plot_tree_plot_area(angle_counts = trees, boundaries = boundaries,
                    tnr = tnr, enr = enr, bnr = bnr)
tree <- trees[trees[["tnr"]] == tnr & trees[["enr"]] == enr &
              trees[["bnr"]] == bnr, TRUE]
bounds <- boundaries[boundaries$tnr == tnr & boundaries$enr == enr, TRUE]
expectation <- get_correction_factors(tree, bounds)
expect_identical(result, expectation$correction_factor)
