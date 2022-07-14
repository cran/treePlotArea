[![pipeline status](https://gitlab.com/fvafrcu/treePlotArea/badges/master/pipeline.svg)](https://gitlab.com/fvafrcu/treePlotArea/-/commits/master)    
[![coverage report](https://gitlab.com/fvafrcu/treePlotArea/badges/master/coverage.svg)](https://gitlab.com/fvafrcu/treePlotArea/-/commits/master)
<!-- 
    [![Build Status](https://travis-ci.org/fvafrcu/treePlotArea?branch=master)](https://travis-ci.org/fvafrcu/treePlotArea)
    [![Coverage Status](https://codecov.io/github/fvafrcu/treePlotArea/coverage.svg?branch=master)](https://codecov.io/github/fvafrcu/treePlotArea?branch=master)
-->
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/treePlotArea)](https://cran.r-project.org/package=treePlotArea)
[![RStudio_downloads_monthly](https://cranlogs.r-pkg.org/badges/treePlotArea)](https://cran.r-project.org/package=treePlotArea)
[![RStudio_downloads_total](https://cranlogs.r-pkg.org/badges/grand-total/treePlotArea)](https://cran.r-project.org/package=treePlotArea)

<!-- README.md is generated from README.Rmd. Please edit that file -->



# treePlotArea
## Introduction
Please read the vignette.
<!-- 
[vignette](https://fvafrcu.gitlab.io/treePlotArea/doc/An_Introduction_to_treePlotArea.html).
[vignette](https://CRAN.R-project.org/package=treePlotArea/vignettes/An_Introduction_to_treePlotArea.html).
-->

Or, after installation, the help page:

```r
help("treePlotArea-package", package = "treePlotArea")
```

```
#> Correction Factors for Tree Plot Areas Intersected by Stand Boundaries
#> 
#> Description:
#> 
#>      The German national forest inventory uses angle count sampling, a
#>      sampling method first published by Bitterlich (1947) and extended
#>      by Grosenbaugh (1958) as probability proportional to size
#>      sampling. When plots are located near stand boundaries, their
#>      sizes and hence their probabilities need to be corrected.
#> 
#> Details:
#> 
#>      You will find the details in
#>      'vignette("An_Introduction_to_treePlotArea", package =
#>      "treePlotArea")'.
#> 
#> References:
#> 
#>      Bitterlich, W. (1947): Die Winkelzählmessung. Allgemeine Forst-
#>      und Holzwirtschaftliche Zeitung, 58.
#> 
#>      Grosenbaugh, L. R. (1952): Plotless Timber Estimates - New, Fast,
#>      Easy. Journal of Forestry.
#>      https://academic.oup.com/jof/article-abstract/50/1/32/4684174.
```

## Installation

You can install treePlotArea from gitlab via:


```r
if (! require("remotes")) install.packages("remotes")
remotes::install_gitlab("fvafrcu/treePlotArea")
```


