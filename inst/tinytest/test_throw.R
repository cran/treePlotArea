if (interactive()) {
    pkgload::load_all(".")
    library("tinytest")
}
expect_error(treePlotArea::throw("hello, error"))
