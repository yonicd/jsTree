
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/jsTree)](https://cran.r-project.org/package=jsTree)
[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/0.1.0/active.svg)](https://www.repostatus.org/#active)
![downloads](http://cranlogs.r-pkg.org/badges/jsTree)
[![R-CMD-check](https://github.com/yonicd/jsTree/workflows/R-CMD-check/badge.svg)](https://github.com/yonicd/jsTree/actions)
[![pkgdown](https://github.com/yonicd/jsTree/workflows/pkgdown/badge.svg)](https://github.com/yonicd/jsTree/actions)
[![Coverage
Status](https://img.shields.io/codecov/c/github/yonicd/jsTree/master.svg)](https://codecov.io/github/yonicd/jsTree?branch=master)
<!-- badges: end -->

# jsTree

`R` htmlwidget for inspecting heirachal structures with the ‘jQuery’
‘jsTree’ Plugin.

## Installation

``` r
#install.packages('jsTree')
remotes::install_github('yonicd/jsTree')
```

## Conventional Use

``` r
library(jsTree)
data(states)
data(state_bird)
```

collapse columns to text (with sep “/”)

``` r
nested_string <- apply(states,1,paste,collapse='/')
jsTree(nested_string)
```

Add tooltips to state names with the state bird

``` r
jsTree(nested_string,tooltips = state_bird)
```

initialize tree with checked boxes for certain fields

``` r
nodestate1 <- states$variable=='Area'
jsTree(nested_string,nodestate=nodestate1)
```

``` r
nodestate2 <- states$variable=='Area'&grepl('^M',states$state.name)
jsTree(nested_string,nodestate=nodestate2)
```

``` r
nodestate3 <- states$variable %in% c('Murder') & states$value >= 10
nodestate4 <- states$variable %in% c('HS.Grad') & states$value <= 55
jsTree(nested_string,nodestate=nodestate3|nodestate4)
```

change the order of the hierarchy

``` r
nested_string2 <- apply(states[,c(4,1,2,3,5)],1,paste,collapse='/')
jsTree(nested_string2)
```

Use other delimiters to define the heirarchy

``` r
nested_string <- apply(states,1,paste,collapse='|-|')
jsTree(nested_string,sep = '|-|')
```

## Interacting with remote repositories

### Preview a github repo without cloning it

``` r
remotes::install_github('yonicd/vcs')

#get repo master branch directory structure
  vcs::navigate_remote('tidyverse/ggplot2')
```

![](https://github.com/yonicd/jsTree/blob/master/Miscellaneous/preview_gh_example.gif?raw=true)

### Search text in files of a repo without cloning it

![](https://github.com/yonicd/jsTree/blob/master/Miscellaneous/jstree_vcs_grepr.gif?raw=true)
