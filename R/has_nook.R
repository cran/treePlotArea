has_nook <- function(boundary) {
    res <- unlist(!is.na(unlist(boundary["x0"])))
    return(res)
}
