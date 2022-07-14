#' Convert Preprocessed Data Back to Original Units
#'
#' The data tree coming with this package was processed by Gerald Kaendler for
#' the
#' country of  Baden-Wuerttemberg, and is the reference for testing as he
#' adjusted diameter measurements to breast height where they had been measured
#' in diverging heights (due to deformations of trees at breast height).
#' \emph{Which we really need to do.}
#' But he did some other things we need to revert if we want to follow the
#' standards
#' from the federal database. He
#' \enumerate{
#'     \item converted the diameter at breast height from millimeter to
#'     centimeter and renamed it,
#'     \item converted horizontal distance from centimeter to meter and renamed
#'     it.
#' }
#' So we add two variables holding the diameter in millimeter and the horizontal
#' distance in centimeter, named by the output of \cr
#' \code{fritools::get_options(package_name =
#' "treePlotArea")["angle_counts.dbh"]}\cr
#' and\cr
#' \code{fritools::get_options(package_name =
#' "treePlotArea")["angle_counts.distance"]}\cr
#' respectively.
#' @param x A tree data set, typically
#' \code{get(data("trees", package = "treePlotArea"))}.
#' @return A tree data set prepared to work with the package.
#' @family data functions
#' @export
#' @examples
#' trees <- get(data("trees", package = "treePlotArea"))
#' summary(trees)
#' angle_counts <- bw2bwi2022de(trees)
#' summary(angle_counts)
bw2bwi2022de <- function(x) {
    options <- get_options("angle_counts")
    res <- x
    # Gerald had converted horizontal distance to meter
    res[[options[["distance"]]]] <- res[["entf"]] * 100
    # Gerald had converted dbh to centimeter
    res[[options[["dbh"]]]] <- res[["bhd2"]] * 10
    return(res)
}

#' Select Valid Angle Counts Only
#'
#' The data coming with this package was processed by Gerald Kaendler for the
#' country of  Baden-Wuerttemberg, and is the reference for testing as he
#' adjusted diameter measurements to breast height where they had been measured
#' in diverging heights (due to deformations of trees at breast height).
#' Which we really need to do.
#' But he also
#' added trees that are not part of the angle count sampling, which this
#' function removes. We need that mainly to run tests against the reference
#' values computed by \command{grenzkreis} because we would not be able to
#' easily find the keys to merge the data. \emph{So this function is probably of
#' no use to you.}
#' @param x A tree data set, typically
#' \code{get(data(trees, package = "treePlotArea"))}.
#' @param sample_type An indicator giving the type of sample the tree was
#'     in. 0 marks the angle count sample with counting factor 4.
#' @param tree_status An indicator giving the status of a tree in the German
#'     national forest inventory. 0 marks ingrowth, 1 marks ongrowth.
#' @return A tree data containing valid angle count trees only.
#' @family data functions
#' @export
#' @examples
#' trees <- get(data("trees", package = "treePlotArea"))
#' fritools::is_valid_primary_key(trees, c("tnr", "enr", "bnr"))
#' angle_counts <- select_valid_angle_count_trees(trees)
#' fritools::is_valid_primary_key(angle_counts, c("tnr", "enr", "bnr"))
select_valid_angle_count_trees <- function(x, sample_type = "stp",
                                           tree_status = "pk") {
    options <- get_options("angle_counts")
    res <- x
    res <- res[res[[tree_status]] %in% c(0, 1) &
               res[[sample_type]] == 0 &
               !is.na(res[[options[["dbh"]]]]) &
               !is.na(res[[options[["distance"]]]]),
           TRUE]
    return(res)
}
