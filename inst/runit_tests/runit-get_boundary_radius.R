if (interactive()) pkgload::load_all(".")
test_get_boundary_radius <- function() {
    expectation <- 12.625
    dbh <- 505
    boundary_radius <- get_boundary_radius(dbh, unit = "m", is_ti_round = FALSE) 
    result <- fritools::strip_off_attributes(boundary_radius)
    RUnit::checkIdentical(result, expectation)

    # no rounding:
    expectation <- 1262.5
    dbh <- 505
    boundary_radius <- get_boundary_radius(dbh, unit = "cm",
                                           is_ti_round = FALSE) 
    result <- fritools::strip_off_attributes(boundary_radius)
    RUnit::checkIdentical(result, expectation)

    # rounding to even:
    expectation <- 1262
    dbh <- 505
    boundary_radius <- get_boundary_radius(dbh, unit = "cm", is_ti_round = TRUE) 
    result <- fritools::strip_off_attributes(boundary_radius)
    RUnit::checkIdentical(result, expectation)
}
if (interactive()) {
    test_get_boundary_radius()
}
