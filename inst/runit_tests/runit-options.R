if (interactive()) pkgload::load_all(".")
test_options <- function() {
    options("treePlotArea" = NULL)
    RUnit::checkTrue(treePlotArea:::set_defaults())
    expectation <- unlist(treePlotArea::get_defaults())
    result <- fritools::get_options(package_name = "treePlotArea",
                                    flatten_list = TRUE)
    RUnit::checkIdentical(fritools::strip_off_attributes(expectation),
                          fritools::strip_off_attributes(result))

    ol <- list(angle_counts = list(dbh = "FOO"),
              boundaries = list(boundary_status = "BAR"))
    RUnit::checkTrue(set_options(angle_counts = ol[["angle_counts"]],
                                 boundaries = ol[["boundaries"]]))

    RUnit::checkException(set_options(not_defined = ol[["angle_counts"]],
                                      boundaries = ol[["boundaries"]]))

    ol <- list(angle_counts = list(dbh = "FOO", NOT_DEF = "NA"),
               boundaries = list(boundary_status = "BAR",
                                 not_defined = "BAR"))

    RUnit::checkException(set_options(angle_counts = ol[["angle_counts"]],
                                      boundaries = ol[["boundaries"]]))
}
if (interactive()) {
    test_options()
}
