boundaries2coords <- function(x) {
    op <- get_options("boundaries")
    res <- x
    res[["phia"]] <- geodatic2math(gon2degree(res[[op[["azimuth_start"]]]]))
    res[["phie"]] <- geodatic2math(gon2degree(res[[op[["azimuth_end"]]]]))
    res[["phik"]] <- geodatic2math(gon2degree(res[[op[["azimuth_flexing"]]]]))
    res <- as.data.frame(cbind(polar2cartesian(res[["phia"]],
                                               res[[op[["distance_start"]]]]),
                               polar2cartesian(res[["phik"]],
                                               res[[op[["distance_flexing"]]]]),
                               polar2cartesian(res[["phie"]],
                                               res[[op[["distance_end"]]]])
                               ))
    names(res) <- c("x1", "y1", "x0", "y0", "x2", "y2")
    return(res)
}
