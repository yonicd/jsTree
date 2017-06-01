# jsTree

##Example

Preview a github repo without cloning it

```r
devtools::install_github('yonicd/ciderhouse')
devtools::install_github('yonicd/jsTree')

#get repo master branch directory structure
  x<-ciderhouse::show_repo('tidyverse/purrr',showTree = FALSE)

#visuzlize repo
  jsTree(x)
```

![](https://github.com/yonicd/jsTree/blob/master/Miscellaneous/show_git_buttons.gif?raw=true)