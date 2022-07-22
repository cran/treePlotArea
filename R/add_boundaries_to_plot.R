add_boundaries_to_plot <- function(coords, col = NA) {
    if (any(is.na(col))) {
        colour <- c("black", "black")
        type <- "l"
    } else {
        colour <- col
        type <- "b"
    }
    lw <- 2
    for (n_border in seq.int(nrow(coords))) {
        if (is.na(coords[n_border, "x0"])) {
            graphics::lines(
                            rbind(unlist(coords[n_border,
                                         grep("1$", names(coords))]),
                                  unlist(coords[n_border,
                                         grep("2$", names(coords))])),
                            col = colour[1], type = type, lwd = lw
                            )
        } else {
            graphics::lines(
                            rbind(unlist(coords[n_border,
                                         grep("1$", names(coords))]),
                                  unlist(coords[n_border,
                                         grep("0$", names(coords))]),
                                  unlist(coords[n_border,
                                         grep("2$", names(coords))])),
                            col = colour[2], type = type, lwd = lw
                            )
        }
    }
}
