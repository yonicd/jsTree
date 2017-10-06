[![Travis-CI Build Status](https://travis-ci.org/metrumresearchgroup/jsTree.svg?branch=master)](https://travis-ci.org/metrumresearchgroup/jsTree)

# jsTree

## Examples

### Preview a github repo without cloning it

```r
devtools::install_github('metrumresearchgroup/jsTree')
devtools::install_github('metrumresearchgroup/vcs')

#get repo master branch directory structure
  vcs::navigate_remote('tidyverse/ggplot2')
```

![](https://github.com/yonicd/jsTree/blob/master/Miscellaneous/preview_gh_example.gif?raw=true)

### Search text in files of a repo without cloning it

![](https://github.com/yonicd/jsTree/blob/master/Miscellaneous/jstree_vcs_grepr.gif?raw=true)