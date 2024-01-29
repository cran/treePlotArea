if (interactive()) pkgload::load_all(".")

test_check_tree <- function() {
    check_tree <- treePlotArea:::check_tree
    tnr <- 10056
    enr <- 4
    bnr <- 3
    trees <- bw2bwi2022de(get0(data("trees", package = "treePlotArea")))
    trees <- select_valid_angle_count_trees(trees)
    tree <- trees[trees[["tnr"]] == tnr & trees[["enr"]] == enr &
                  trees[["bnr"]] == bnr,
              TRUE]
    RUnit::checkTrue(fritools::is_success(check_tree(tree)))
    tree$bhd <- 328
    tree$hori <- 835
    RUnit::checkIdentical(check_tree(tree), 20)
}
if (interactive()) {
    test_check_tree()
}


test_get_correction_factor <- function() {
    if (TRUE) {
        # the test with "all data" selected from the data provided by gerald
        # is given in the vignette:
        angle_counts <- bw2bwi2022de(get(data("trees",
                                              package = "treePlotArea")))
        angle_counts <- select_valid_angle_count_trees(angle_counts)
        boundaries <- get(data("boundaries", package = "treePlotArea"))
        correction_factors <- get_correction_factors(angle_counts,
                                                     boundaries,
                                                     verbose = FALSE)
        m <- merge(angle_counts[TRUE, c("tnr", "enr", "bnr",
                                        "kf2", "pk", "stp")],
                   correction_factors)
        rdiff <- fritools::relative_difference(m[["correction_factor"]],
                                               m[["kf2"]])
        RUnit::checkTrue(all(abs(rdiff) < 0.001))
    }

    tnr <- 10056
    enr <- 4
    bnr <- 3
    expectation <- list(correction_factor = 1.40212570888359, code = 0)
    trees <- bw2bwi2022de(get0(data("trees", package = "treePlotArea")))
    trees <- select_valid_angle_count_trees(trees)
    boundaries <- get(data("boundaries", package = "treePlotArea"))
    tree <- trees[trees[["tnr"]] == tnr & trees[["enr"]] == enr &
                  trees[["bnr"]] == bnr, TRUE]
    bounds <- boundaries[boundaries$tnr == tnr & boundaries$enr == enr, TRUE]
    result <- treePlotArea:::get_correction_factor(tree, bounds)
    RUnit::checkEquals(result, expectation)
}
if (interactive()) {
    test_get_correction_factor()
}

test_get_correction_factors <- function() {
    if (fritools::is_running_on_fvafrcu_machines("fvafr")) {
        # use the data stored in R/sysdata.rda
        trees <- treePlotArea:::trees
        boundaries <- treePlotArea:::boundaries
    } else {
        trees <- get(data(trees, package = "treePlotArea"))
        boundaries <- get(data(boundaries, package = "treePlotArea"))
    }

    angle_counts <- select_valid_angle_count_trees(bw2bwi2022de(trees))

    boundary_polygons <- get_boundary_polygons(boundaries,
                                               stop_on_error = FALSE)
    correction_factors <- get_correction_factors(angle_counts,
                                                 boundary_polygons)
    m <- merge(angle_counts[TRUE, c("tnr", "enr", "bnr", "kf2",
                                    "pk", "stp", "bhd", "hori")],
               correction_factors)
    rdiff <- fritools::relative_difference(m[["correction_factor"]], m[["kf2"]])
    RUnit::checkTrue(all(abs(rdiff) < 0.01))

    # set the options to use different names in the data.
    names(angle_counts) <- toupper(names(angle_counts))
    names(boundaries) <- toupper(names(boundaries))
    option_list <- sapply(get_defaults(), function(x) lapply(x, toupper))
    set_options(angle_counts = option_list[["angle_counts"]],
                boundaries = option_list[["boundaries"]])

    correction_factors_upper <- get_correction_factors(angle_counts, boundaries)
    RUnit::checkEquals(correction_factors_upper, correction_factors,
                       checkNames = FALSE)
}
if (interactive()) {
    test_get_correction_factors()
}
