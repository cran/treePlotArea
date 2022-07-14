if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}

expectation <- 12.625
br <- treePlotArea::get_boundary_radius(505, unit = "m")
result <- fritools::strip_off_attributes(br)
expect_identical(result, expectation)
