#' @title Htmlwidget for the jsTree Javascript library
#' @description Htmlwidget for the jsTree Javascript library
#' @param obj character, vector of directory tree
#' @param tooltips character, named vector of tooltips for elements in the tree, Default: NULL
#' @param nodestate boolean, vector the length of obj that initializes tree open to true values, Default: NULL
#' @param ... parameters that are passed to the vcs package (see details)
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param elementId The input slot that will be used to access the element.
#' @details parameters in ... that can be passed on to the vcs package are: 
#' remote_repo a character object that defines the remote user/repository,
#' remote_branch character object that defines the branch of remote_repo (ussually 'master'),
#' vcs character object that defines for vcs which version control system to attach (github, bitbucket, svn)
#' preview.search character object that defines a search term to initialize to in the preview pane searchbox
#' 
#' if remote_repo is given a preview pane of a selected file from the tree will appear to the right of the tree.
#' preview.search is only relevant for vcs in (github,bitbucket) where file previewing is available
#' 
#' For more information on the vcs package go to \url{https://github.com/metrumresearchgroup/vcs}
#' 
#' @examples
#' if(interactive()){
#' 
#' data(states)
#' data(state_bird)
#' 
#' #collapse columns to text (with sep "/")
#' nested_string <- apply(states,1,paste,collapse='/')
#' jsTree(nested_string)
#' 
#' # Add tooltips to state names with the state bird 
#' jsTree(nested_string,tooltips = state_bird)
#' 
#' #initialize tree with checked boxes for certain fields
#' nodestate1 <- states$variable=='Area'
#' jsTree(nested_string,nodestate=nodestate1)
#' 
#' nodestate2 <- states$variable=='Area'&grepl('^M',states$state.name)
#' jsTree(nested_string,nodestate=nodestate2)
#' 
#' nodestate3 <- states$variable %in% c('Murder') & states$value >= 10
#' nodestate4 <- states$variable %in% c('HS.Grad') & states$value <= 55
#' jsTree(nested_string,nodestate=nodestate3|nodestate4)
#' 
#' #change the order of the hierarchy
#' nested_string2 <- apply(states[,c(4,1,2,3,5)],1,paste,collapse='/')
#' 
#' jsTree(nested_string2)
#' 
#' #use jsTree to visualize folder structure
#' 
#' jsTree(list.files(full.names = TRUE,recursive = FALSE))
#' 
#' \dontrun{
#' # This may be too long for example if running from ~.
#' jsTree(list.files(full.names = TRUE,recursive = TRUE))
#' }
#' }
#' 
#' @import htmlwidgets
#' @importFrom jsonlite toJSON
#' @export
jsTree <- function(obj, tooltips=NULL, nodestate=NULL, ... , width = NULL, height = NULL, elementId = NULL) {

  preview.search <- NULL
  
  list2env(list(...),envir = environment())
  
  if(!'remote_repo'%in%names(match.call())) remote_repo <- NULL
  if(!'vcs'%in%names(match.call())) vcs <- 'github'
  if(!'remote_branch'%in%names(match.call())) remote_branch <- 'master'
  
  obj.in <- nest(l       = obj,
               root      = ifelse(!is.null(remote_repo),
                                  ifelse(vcs=='svn',
                                         remote_repo,
                                         paste(remote_repo,remote_branch,sep='/')
                                         ),
                                  '.'),
               nodestate = nodestate,
               tooltips  = tooltips
               )
  
  # forward options using x
  x <- list(data = jsonlite::toJSON(obj.in,auto_unbox = TRUE), vcs = vcs)
  
  if( 'preview.search'%in%names(match.call()) ) x$forcekey <- preview.search
  
  if( !is.null(remote_repo) ){
    x$uri <- switch(vcs,
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
