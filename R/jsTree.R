#' @title Htmlwidget for the jsTree Javascript library
#' @description Htmlwidget for the jsTree Javascript library
#' @param obj character, vector of directory tree
#' @examples 
#' jsTree(list.dirs())
#' jsTree(ciderhouse::show_repo('tidyverse/purrr',showTree = FALSE))
#' @import htmlwidgets
#' @importFrom jsonlite toJSON
#' @export
jsTree <- function(obj, gh_repo=NULL,gh_branch='master',width = NULL, height = NULL, elementId = NULL) {

  obj.in<-nest(obj)
  
  # forward options using x
  x = list(data=jsonlite::toJSON(obj.in,auto_unbox = TRUE))
  if(!is.null(gh_repo)) {
    uri_git=sprintf('https://raw.githubusercontent.com/%s/%s/R/bin.R?raw=true',gh_repo,gh_branch)  
    if(!httr::http_error(uri_git)) x$uri=uri_git
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
