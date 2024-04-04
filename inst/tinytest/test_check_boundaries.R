if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}

expectation <- 12.625
br <- treePlotArea::get_boundary_radius(505, unit = "m", is_ti_round = FALSE)
result <- as.numeric(br)
expect_identical(result, expectation)
