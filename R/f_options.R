.options <- function(name, value) {
    # programmatically set options
    eval(parse(text = paste("options(", name, "= value)")))
}

fritools_set_options <- function(..., package_name = .packages()[1],
                                 overwrite = TRUE) {
    option_list <- list(...)
    if (length(option_list) == 1L && is.list(option_list))
        option_list <- unlist(option_list, recursive = FALSE)
    options_set <- fritools_get_options(package_name = package_name,
                               flatten_list = FALSE)
    if (isTRUE(overwrite)) {
        if (is.null(options_set)) {
            .options(package_name, option_list)
        } else {
            if (length(options_set) == 1L)
                options_set <- as.list(options_set)
            .options(package_name, utils::modifyList(options_set, option_list))
        }
    } else {
        is_option_unset <- ! (names(option_list) %in% names(options_set))
        if (any(is_option_unset))
            .options(package_name,
                     append(options_set, option_list[is_option_unset]))
    }
    return(invisible(TRUE))
}

fritools_get_options <- function(..., package_name = .packages()[1],
                        remove_names = FALSE, flatten_list = TRUE) {
    if (missing(...)) {
        option_list <- getOption(package_name)
    } else {
        option_names <- as.vector(...)
        options_set <- getOption(package_name)
        option_list  <- options_set[names(options_set) %in% option_names]
    }
    if (flatten_list) option_list <- unlist(option_list)
    if (remove_names) names(option_list)  <- NULL
    if (!is.null(option_list)) {
        attr(option_list, "package") <- package_name
    }
    return(option_list)
}
