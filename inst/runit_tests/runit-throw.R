test_exception <- function() {
    RUnit::checkException(treePlotArea:::throw("Hello, error!"))
}
