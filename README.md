[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/jsTree)](https://cran.r-project.org/package=jsTree)
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/0.1.0/active.svg)](http://www.repostatus.org/#active) 
![downloads](http://cranlogs.r-pkg.org/badges/jsTree)[![Travis-CI Build Status](https://travis-ci.org/metrumresearchgroup/jsTree.svg?branch=master)](https://travis-ci.org/metrumresearchgroup/jsTree)[![Coverage Status](https://img.shields.io/codecov/c/github/metrumresearchgroup/jsTree/master.svg)](https://codecov.io/github/metrumresearchgroup/jsTree?branch=master)

# jsTree

## Examples

### Preview a github repo without cloning it

```r
remotes::install_github('metrumresearchgroup/jsTree')
remotes::install_github('metrumresearchgroup/vcs')

#get repo master branch directory structure
  vcs::navigate_remote('tidyverse/ggplot2')
```

![](https://github.com/yonicd/jsTree/blob/master/Miscellaneous/preview_gh_example.gif?raw=true)

### Search text in files of a repo without cloning it

![](https://github.com/yonicd/jsTree/blob/master/Miscellaneous/jstree_vcs_grepr.gif?raw=true)