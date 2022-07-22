### R code from vignette source 'An_Introduction_to_treePlotArea.Rnw'

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
### code chunk number 6: cft
###################################################
# Fake the above warning swallowed up by Sweave
w <- tryCatch(
              correction_factors <- get_correction_factors(angle_counts,
                                                           boundaries,
                                                           verbose = FALSE),
              warning = identity
)
cat("Warning message:", w$message, sep = "\n")


###################################################
### code chunk number 7: bo
###################################################
subset(boundaries, tnr == 2607)


###################################################
### code chunk number 8: cf
###################################################
print(subset(correction_factors, tnr == 2607 & enr == 2))


###################################################
### code chunk number 9: comparison
###################################################
m <- merge(angle_counts[TRUE, c("tnr", "enr", "bnr",
                                "kf2", "pk", "stp")],
           correction_factors)
m[["diff"]] <- m[["correction_factor"]] - m[["kf2"]]
rdiff <- ifelse(m[["kf2"]] == 0,
                m[["diff"]] / (m[["kf2"]] + 1e-10),
                m[["diff"]] / m[["kf2"]])
works <- RUnit::checkTrue(all(abs(rdiff) < 0.001))
if (works) {
    print("Concurs with tests in runit/")
} else {
    stop("Break vignette.")
}


###################################################
### code chunk number 10: options
###################################################
set_options()
str(getOption("treePlotArea"))


###################################################
### code chunk number 11: data_rename
###################################################
names(angle_counts) <- toupper(names(angle_counts))
names(boundaries) <- toupper(names(boundaries))


###################################################
### code chunk number 12: data_options
###################################################
option_list <- sapply(get_defaults(), function(x) lapply(x, toupper))
set_options(angle_counts = option_list[["angle_counts"]],
            boundaries = option_list[["boundaries"]])


###################################################
### code chunk number 13: data_runit
###################################################
correction_factors_upper <- get_correction_factors(angle_counts,
                                                   boundaries,
                                                   verbose = FALSE)
RUnit::checkEquals(correction_factors_upper, correction_factors,
                   checkNames = FALSE)


###################################################
### code chunk number 14: ptpa_1
###################################################
cf <- plot_tree_plot_area(angle_counts = angle_counts,
                          boundaries = boundaries,
                          tnr =  tnr, enr = enr, bnr = bnr,
                          frame_factor = 1)


###################################################
### code chunk number 15: ptpa_4
###################################################
cf <- plot_tree_plot_area(angle_counts = angle_counts,
                          boundaries = boundaries,
                          tnr =  tnr, enr = enr, bnr = bnr,
                          frame_factor = 4)


