
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/jsTree)](https://cran.r-project.org/package=jsTree)
[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/0.1.0/active.svg)](http://www.repostatus.org/#active)
![downloads](http://cranlogs.r-pkg.org/badges/jsTree)[![Travis-CI Build
Status](https://travis-ci.org/metrumresearchgroup/jsTree.svg?branch=master)](https://travis-ci.org/metrumresearchgroup/jsTree)[![Coverage
Status](https://img.shields.io/codecov/c/github/metrumresearchgroup/jsTree/master.svg)](https://codecov.io/github/metrumresearchgroup/jsTree?branch=master)

# jsTree

`R` htmlwidget for inspecting heirachal structures with the ‘jQuery’
‘jsTree’ Plugin.

## Installation

``` r
#install.packages('jsTree')
remotes::install_github('metrumresearchgroup/jsTree')
```

## Conventional Use

``` r
library(jsTree)
data(states)
data(state_bird)
```

Initialize a new tree

``` r
x <- jsTree::jsTree$new()
```

Add data

Data can be a data.frame or a string that is collapse columns to text
(with seperator). When the data is a data.frame the seperator is
controlled by `x$sep`.

``` r
x$data  <- states
```

Initialize a new tree with data

``` r
x <- jsTree::jsTree$new(states)
```

Invoke the widget

``` r
x$show()
```

![](tools/readme/README-unnamed-chunk-7-1.png)<!-- -->

Add tooltips to state names with the state bird

``` r

x$tooltips <- state_bird

x$show()
```

![](tools/readme/README-unnamed-chunk-8-1.png)<!-- -->

initialize tree with checked boxes for certain fields

``` r
x$nodestate(variable=='Area')
x$show()
```

![](tools/readme/README-unnamed-chunk-9-1.png)<!-- -->

``` r
x$nodestate(variable=='Area'&grepl('^M',state.name))
x$show()
```

![](tools/readme/README-unnamed-chunk-10-1.png)<!-- -->

Remove node states

``` r
x$nodestate(NULL)
```

change the order of the hierarchy

``` r
#using character object as data
x$data <- apply(states[,c(4,1,2,3,5)],1,paste,collapse='/')
x$show()
```

![](tools/readme/README-unnamed-chunk-12-1.png)<!-- -->

Use other delimiters to define the heirarchy

``` r
x$data <- states
x$sep <- '|-|'
x$show()
```

![](tools/readme/README-unnamed-chunk-13-1.png)<!-- -->

## Interacting with remote repositories

### Preview a github repo without cloning it

``` r
remotes::install_github('metrumresearchgroup/vcs')

#get repo master branch directory structure
  vcs::navigate_remote('tidyverse/ggplot2')
```

![](https://github.com/yonicd/jsTree/blob/master/Miscellaneous/preview_gh_example.gif?raw=true)

### Search text in files of a repo without cloning it

![](https://github.com/yonicd/jsTree/blob/master/Miscellaneous/jstree_vcs_grepr.gif?raw=true)
