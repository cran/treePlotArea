if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}
tnr <- 10056
enr <- 4
bnr <- 3
trees <- bw2bwi2022de(get0(data("trees", package = "treePlotArea")))
trees <- select_valid_angle_count_trees(trees)
trees <- trees[trees[["tnr"]] == tnr & trees[["enr"]] == enr, TRUE]
boundaries <- get(data("boundaries", package = "treePlotArea"))
bounds <- boundaries[boundaries$tnr == tnr & boundaries$enr == enr, TRUE]
result <- plot_tree_plot_area(angle_counts = trees, boundaries = boundaries,
                    tnr = tnr, enr = enr, bnr = bnr)
expectation <- get_correction_factors(trees[trees$bnr == bnr, TRUE], bounds)
expect_identical(result$correction_factors, expectation$correction_factor)


result <- plot_tree_plot_area(angle_counts = trees, boundaries = boundaries,
                    tnr = tnr, enr = enr)
expectation <- get_correction_factors(trees, bounds)
expect_identical(result$correction_factors, expectation$correction_factor)
