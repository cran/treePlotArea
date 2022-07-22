if (interactive()) pkgload::load_all(".")
test_get_boundary_polygons <- function() {
    boundaries <- get(data("boundaries", package = "treePlotArea"))
    # For the boundary in tract 2607, corner 2 the azimuth values in `spa_gon`
    # and `spk_gon` are identical:
    expectation <- structure(list(tnr = 2607L, enr = 2L, vbl = 804L, rnr = 1L,
                                  rk = 1L, rart = 1L, rterrain = 3L,
                                  spa_gon = 329L, spa_m = 3470L,
                                  spk_gon = 329L, spk_m = 2200L,
                                  spe_gon = 20L, spe_m = 1010L),
                             row.names = 1598L, class = "data.frame")
    result <- boundaries[boundaries$tnr == 2607 & boundaries$enr == 2, TRUE]
    RUnit::checkIdentical(result, expectation)

    RUnit::checkException(get_boundary_polygons(boundaries))

    # There's three boundaries in tract 2607, corner 1, and in corner 2:
    boundary_polygons <- get_boundary_polygons(boundaries,
                                               stop_on_error = FALSE)
    result <- c(length(boundary_polygons[["2607"]][["1"]]),
                length(boundary_polygons[["2607"]][["2"]]))
    expectation <- c(3L, 1L)
    RUnit::checkIdentical(result, expectation)

    # Clean the data
    boundary_polygons <- get_boundary_polygons(boundaries,
                                               stop_on_error = FALSE,
                                               clean_data = TRUE)
    result <- c(length(boundary_polygons[["2607"]][["1"]]),
                length(boundary_polygons[["2607"]][["2"]]))
    expectation <- c(3L, 0L)
    RUnit::checkIdentical(result, expectation)
}
if (interactive()) {
    test_get_boundary_polygons()
}
