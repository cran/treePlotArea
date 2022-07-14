if (interactive()) pkgload::load_all(".")
test_get_correction_factors <- function() {
    if (fritools::is_running_on_fvafrcu_machines("fvafr")) {
        # use the data stored in R/sysdata.rda
    } else {
        data(trees, package = "treePlotArea")
        data(boundaries, package = "treePlotArea")
    }

    angle_counts <- bw2bwi2022de(trees)

    boundary_polygons <- get_boundary_polygons(boundaries)
    correction_factors <- get_correction_factors(angle_counts,
                                                 boundary_polygons)
    m <- merge(angle_counts[TRUE, c("tnr", "enr", "bnr", "kf2", "pk", "stp")],
               correction_factors)
    m[["diff"]] <- m[["correction_factor"]] - m[["kf2"]]
    m <- select_valid_angle_count_trees(m)
    rdiff <- ifelse(m[["kf2"]] == 0,
                    m[["diff"]] / (m[["kf2"]] + 1e-10),
                    m[["diff"]] / m[["kf2"]])
    RUnit::checkTrue(all(abs(rdiff) < 0.001))
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
