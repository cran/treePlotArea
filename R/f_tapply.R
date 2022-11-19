fritools_tapply <- function(object, index, func = NULL, ..., default = NA,
                   simplify = TRUE) {
    func <- if (!is.null(func))
        match.fun(func)
    if (!is.list(index))
        index <- list(index)
    index <- lapply(index, as.factor)
    num_i <- length(index)
    if (!num_i)
        stop("'index' is of length zero")
    if (is.data.frame(object)) {
        if (!all(lengths(index) == nrow(object)))
            stop("arguments must have same length")
    } else {
        if (!all(lengths(index) == length(object)))
            stop("arguments must have same length")
    }
    namelist <- lapply(index, levels)
    extent <- lengths(namelist, use.names = FALSE)
    cumextent <- cumprod(extent)
    if (cumextent[num_i] > .Machine[["integer.max"]])
        stop("total number of levels >= 2^31")
    storage.mode(cumextent) <- "integer"
    ngroup <- cumextent[num_i]
    group <- as.integer(index[[1L]])
    if (num_i > 1L)
        for (i in 2L:num_i) group <- group + cumextent[i - 1L] *
            (as.integer(index[[i]]) - 1L)
    if (is.null(func))
        return(group)
    levels(group) <- as.character(seq_len(ngroup))
    class(group) <- "factor"
    ans <- split(object, group)
    names(ans) <- NULL
    idx <- as.logical(lengths(ans))
    ans <- lapply(X = ans[idx], FUN = func, ...)
    ansmat <- array(if (simplify && all(lengths(ans) == 1L)) {
                        ans <- unlist(ans, recursive = FALSE, use.names = FALSE)
                        if (!is.null(ans) && is.na(default) && is.atomic(ans))
                            vector(typeof(ans))
                        else
                            default
                   } else {
                       vector("list", prod(extent))
                   },
                   dim = extent, dimnames = namelist)
    if (length(ans)) {
        ansmat[idx] <- ans
    }
    ansmat
}
