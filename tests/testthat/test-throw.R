testthat::context("Testing treePlotArea:::throw()")
testthat::test_that("throw the treePlotArea exception", {
                        error_message <- "hello, testthat"
                        string <- "hello, testthat"
                        testthat::expect_error(treePlotArea:::throw(string),
                            error_message)
}
)
