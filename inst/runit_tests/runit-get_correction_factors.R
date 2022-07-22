if (interactive()) pkgload::load_all(".")


test_get_correction_factor <- function() {
    tnr <- 10056
    enr <- 4
    bnr <- 3
    expectation <- list(correction_factor = 1.40212570888359, code = -1)
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
    } else {
        data(trees, package = "treePlotArea")
        data(boundaries, package = "treePlotArea")
    }

    angle_counts <- select_valid_angle_count_trees(bw2bwi2022de(trees))

    boundary_polygons <- get_boundary_polygons(boundaries,
                                               stop_on_error = FALSE)
    correction_factors <- get_correction_factors(angle_counts,
                                                 boundary_polygons)
    m <- merge(angle_counts[TRUE, c("tnr", "enr", "bnr", "kf2",
                                    "pk", "stp", "bhd", "hori")],
               correction_factors)
    m[["diff"]] <- m[["correction_factor"]] - m[["kf2"]]
    m$rdiff <- ifelse(m[["kf2"]] == 0,
                      m[["diff"]] / (m[["kf2"]] + 1e-10),
                      m[["diff"]] / m[["kf2"]])
    RUnit::checkTrue(all(abs(m$rdiff) < 0.001))
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
