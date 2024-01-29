if (interactive()) {
    pkgload::load_all()
    library("tinytest")
}
b <- read.csv2(system.file("tinytest", "data", "grenze_te_62541_1.csv", package = "treePlotArea"))
expect_identical(b, check_boundaries(b))

# mv the end towards the corner's center, such that the boundary runs through
# it:
b[["spe_m"]] <- 533
expect_error(check_boundaries(b))
