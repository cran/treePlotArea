if (interactive()) pkgload::load_all(".")
test_get_boundary_radius <- function() {
    expectation <- 12.625
    result <-  fritools::strip_off_attributes(get_boundary_radius(505,
                                                                  unit = "m"))
    RUnit::checkIdentical(result, expectation)
}
if (interactive()) {
    test_get_boundary_radius()
}
