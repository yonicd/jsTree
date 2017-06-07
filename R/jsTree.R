#' @title Htmlwidget for the jsTree Javascript library
#' @description Htmlwidget for the jsTree Javascript library
#' @param obj character, vector of directory tree
#' @param tooltips character, named vector of tooltips for elements in the tree, Default: NULL
#' @param gh_repo character, github user/repository, Default: NULL
#' @param gh_branch character, branch of gh_repo, Default: 'master'
#' @details if gh_repo is given a preview pane of a selected file from the tree will appear to the right of the tree.
#' @examples 
#' jsTree(list.files(full.names = TRUE,recursive = TRUE))
#' jsTree(ciderhouse::ls_github('tidyverse/reprex',recursive = TRUE),gh_repo = 'tidyverse/reprex')
#' @import htmlwidgets
#' @importFrom jsonlite toJSON
#' @importFrom httr http_error
#' @export
jsTree <- function(obj, tooltips=NULL, nodestate=NULL, gh_repo=NULL, gh_branch='master', width = NULL, height = NULL, elementId = NULL) {

  obj.in<-nest(l         = obj,
               root      = ifelse(!is.null(gh_repo),paste(gh_repo,gh_branch,sep='/'),'.'),
               nodestate = nodestate,
               tooltips  = tooltips
               )
  
  # forward options using x
  x = list(
    data=jsonlite::toJSON(obj.in,auto_unbox = TRUE)
    #tips=jsonlite::toJSON(as.list(setNames(tooltips,names(tooltips))))
    )
  
  if(!is.null(gh_repo)){
    x$uri='https://raw.githubusercontent.com/'
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
