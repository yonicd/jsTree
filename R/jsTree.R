#' @title Htmlwidget for the jsTree Javascript library
#' @description Htmlwidget for the jsTree Javascript library
#' @param obj character, vector of directory tree
#' @param tooltips character, named vector of tooltips for elements in the tree, Default: NULL
#' @param nodestate boolean, vector the length of obj that initializes tree open to true values, Default: NULL
#' @param preview.search character, Search term to initialize to in the preview pane searchbox, Default: NULL
#' @param remote_repo character, remote user/repository, Default: NULL
#' @param remote_branch character, branch of remote_repo, Default: 'master'
#' @param vcs character, choose which version control system to attach (github, bitbucket, svn), Default: 'github'
#' @details if remote_repo is given a preview pane of a selected file from the tree will appear to the right of the tree.
#' preview.search is only relevant for vcs in (github,bitbucket) where file previewing is available
#' @examples 
#' jsTree(list.files(full.names = TRUE,recursive = TRUE))
#' jsTree(vcs::ls_remote('tidyverse/reprex'),remote_repo = 'tidyverse/reprex')
#' @import htmlwidgets
#' @importFrom jsonlite toJSON
#' @importFrom httr http_error
#' @export
jsTree <- function(obj, tooltips=NULL, nodestate=NULL,preview.search=NULL, remote_repo=NULL, remote_branch='master',vcs='github', width = NULL, height = NULL, elementId = NULL) {

  obj.in<-nest(l         = obj,
               root      = ifelse(!is.null(remote_repo),ifelse(vcs=='svn',remote_repo,paste(remote_repo,remote_branch,sep='/')),'.'),
               nodestate = nodestate,
               tooltips  = tooltips
               )
  
  # forward options using x
  x = list(data=jsonlite::toJSON(obj.in,auto_unbox = TRUE),vcs=vcs)
  
  if(!is.null(preview.search)) x$forcekey=preview.search
  
  if(!is.null(remote_repo)){
    x$uri=switch(vcs,
                 github=sprintf('https://raw.githubusercontent.com/%s/%s',remote_repo,remote_branch),
                 bitbucket=sprintf('https://bitbucket.org/%s/raw/%s',remote_repo,remote_branch)
                 )
  }


  # create widget
  htmlwidgets::createWidget(
    name = 'jsTree',
    x,
    width = width,
    height = height,
    package = 'jsTree',
    elementId = elementId
  )
}

#' Shiny bindings for jsTree
#'
#' Output and render functions for using jsTree within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a jsTree
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name jsTree-shiny
#'
#' @export
jsTreeOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'jsTree', width, height, package = 'jsTree')
}

#' @rdname jsTree-shiny
#' @export
renderJsTree <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, jsTreeOutput, env, quoted = TRUE)
}
