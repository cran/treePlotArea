if (interactive()) pkgload::load_all(".")
test_check_boundaries <- function() {
    # create a boundary which runs through the plot. This is not a real
    # boundary, there was one in bwi3:
    boundary <- structure(list(tnr = 9999L, enr = 5L,
                                  rk = 1L, rart = 1L,
                                  spa_gon = 329L, spa_m = 2200L,
                                  spk_gon = 329L, spk_m = 3470L,
                                  spe_gon = 20L, spe_m = 1010L),
                             row.names = 1598L, class = "data.frame")
    RUnit::checkException(treePlotArea:::check_boundaries(boundary))
    # Now the boundary points away from the plot
    boundary <- structure(list(tnr = 9999L, enr = 5L,
                                  rk = 1L, rart = 1L,
                                  spa_gon = 329L, spa_m = 3470,
                                  spk_gon = 329L, spk_m = 2200,
                                  spe_gon = 20L, spe_m = 1010L),
                             row.names = 1598L, class = "data.frame")
    RUnit::checkIdentical(treePlotArea:::check_boundaries(boundary), boundary)
    # Boundary without nook
    boundary <- structure(list(tnr = 9999L, enr = 5L,
                                  rk = 1L, rart = 1L,
                                  spa_gon = 329L, spa_m = 3470,
                                  spk_gon = NA, spk_m = NA,
                                  spe_gon = 20L, spe_m = 1010L),
                             row.names = 1598L, class = "data.frame")
    RUnit::checkIdentical(treePlotArea:::check_boundaries(boundary), boundary)
    # pointing towards plot
    boundary <- structure(list(tnr = 9999L, enr = 5L,
                                  rk = 1L, rart = 1L,
                                  spa_gon = 20, spa_m = 3470,
                                  spk_gon = NA, spk_m = NA,
                                  spe_gon = 20L, spe_m = 1010L),
                             row.names = 1598L, class = "data.frame")
    RUnit::checkException(treePlotArea:::check_boundaries(boundary))

}
if (interactive()) {
    test_check_boundaries()
}
test_get_boundary_polygons <- function() {
    # create a boundary which runs through the plot. This is not a real
    # boundary, there was one in bwi3:
    boundary <- structure(list(tnr = 2607L, enr = 2L, vbl = 804L, rnr = 1L,
                                  rk = 1L, rart = 1L, rterrain = 3L,
                                  spa_gon = 329L, spa_m = 2200L,
                                  spk_gon = 329L, spk_m = 3470L,
                                  spe_gon = 20L, spe_m = 1010L),
                             row.names = 1598L, class = "data.frame")
    RUnit::checkException(get_boundary_polygons(boundary))

    boundaries <- get(data("boundaries", package = "treePlotArea"))
    boundary_polygons <- get_boundary_polygons(boundaries,
                                               stop_on_error = FALSE)
    result <- c(length(boundary_polygons[["2607"]][["1"]]),
                length(boundary_polygons[["2607"]][["2"]]))
    expectation <- c(3L, 1L)
    RUnit::checkIdentical(result, expectation)
}
if (interactive()) {
    test_get_boundary_polygons()
}
