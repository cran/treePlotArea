### R code from vignette source '/home/qwer/git/cyclops/fvafrcu/treePlotArea/vignettes/An_Introduction_to_treePlotArea.Rnw'

###################################################
### code chunk number 1: ptpa
###################################################
library("treePlotArea")
tnr <- 166
enr <- 2
bnr <- 7
angle_counts <- bw2bwi2022de(get(data("trees",
                                      package = "treePlotArea")))
angle_counts <- select_valid_angle_count_trees(angle_counts)
boundaries <- get(data("boundaries", package = "treePlotArea"))
cf <- plot_tree_plot_area(angle_counts = angle_counts,
                          boundaries = boundaries,
                          tnr =  tnr, enr = enr, bnr = bnr,
                          frame_factor = 0.35)


###################################################
### code chunk number 2: An_Introduction_to_treePlotArea.Rnw:84-85
###################################################
library("treePlotArea")
tnr <- 166
enr <- 2
bnr <- 7
angle_counts <- bw2bwi2022de(get(data("trees",
                                      package = "treePlotArea")))
angle_counts <- select_valid_angle_count_trees(angle_counts)
boundaries <- get(data("boundaries", package = "treePlotArea"))
cf <- plot_tree_plot_area(angle_counts = angle_counts,
                          boundaries = boundaries,
                          tnr =  tnr, enr = enr, bnr = bnr,
                          frame_factor = 0.35)


###################################################
### code chunk number 3: cf
###################################################
print(cf)
angle_counts[angle_counts[["tnr"]] == tnr &
             angle_counts[["enr"]] == enr &
             angle_counts[["bnr"]] == bnr, "kf2"]


###################################################
### code chunk number 4: nrow
###################################################
nrow(angle_counts)
nrow(boundaries)


###################################################
### code chunk number 5: cf
###################################################
correction_factors <- get_correction_factors(angle_counts,
                                             boundaries,
                                             verbose = FALSE)


###################################################
### code chunk number 6: comparison
###################################################
m <- merge(angle_counts[TRUE, c("tnr", "enr", "bnr",
                                "kf2", "pk", "stp")],
           correction_factors)
rdiff <- fritools::relative_difference(m[["correction_factor"]], m[["kf2"]])
works <- RUnit::checkTrue(all(abs(rdiff) < 0.001))
if (works) {
    print("Concurs with tests in runit/")
} else {
    stop("Break vignette.")
}


###################################################
### code chunk number 7: options
###################################################
set_options()
str(getOption("treePlotArea"))


###################################################
### code chunk number 8: data_rename
###################################################
names(angle_counts) <- toupper(names(angle_counts))
names(boundaries) <- toupper(names(boundaries))


###################################################
### code chunk number 9: data_options
###################################################
option_list <- sapply(get_defaults(), function(x) lapply(x, toupper))
set_options(angle_counts = option_list[["angle_counts"]],
            boundaries = option_list[["boundaries"]])


###################################################
### code chunk number 10: data_runit
###################################################
correction_factors_upper <- get_correction_factors(angle_counts,
                                                   boundaries,
                                                   verbose = FALSE)
RUnit::checkEquals(correction_factors_upper, correction_factors,
                   checkNames = FALSE)


###################################################
### code chunk number 11: ptpa_1
###################################################
cf <- plot_tree_plot_area(angle_counts = angle_counts,
                          boundaries = boundaries,
                          tnr =  tnr, enr = enr, bnr = bnr,
                          frame_factor = 1)


###################################################
### code chunk number 12: ptpa_4
###################################################
cf <- plot_tree_plot_area(angle_counts = angle_counts,
                          boundaries = boundaries,
                          tnr =  tnr, enr = enr, bnr = bnr,
                          frame_factor = 4)


