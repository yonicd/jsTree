#' @title Htmlwidget for the jsTree Javascript library
#' @description Htmlwidget for the jsTree Javascript library
#' @param obj character, vector of directory tree
#' @param sep character, separator for \code{'obj'} which defines the hierarchy, Default: \code{'/'}.
#' @param sep_fixed boolean, to treat the sep character(s) as fixed when seperating, Default: TRUE.
#' @param core list, additional parameters to pass to core of jsTree, default: NULL
#' @param tooltips character, named vector of tooltips for elements in the tree, Default: NULL
#' @param nodestate boolean, vector the length of obj that initializes tree open to true values, Default: NULL
#' @param ... parameters that are passed to the vcs package (see details)
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param elementId The input slot that will be used to access the element.
#' @param file character, html filename to save output to,
#' Default: tempfile(pattern = 'jstree-',fileext = '.html').
#' @param browse whether to open a browser to view the html, Default: TRUE
#' @details 
#' 
#' valid core objects can be found in the jsTree javascript library api
#'  \href{https://www.jstree.com/api/}{homepage}. 
#'  
#' All objects that are children of 'jstree.defaults.core' are valid inputs, 
#' except 'jstree.defaults.core.data' which is constructed internally by the R function call.
#' The R list object is translated internally into a valid javascript object.
#' 
#' parameters in ... that can be passed on to the vcs package are:
#' 
#' \strong{remote_repo} a character object that defines the remote user/repository
#' 
#' \strong{remote_branch} character object that defines the branch of remote_repo (ussually 'master')
#' 
#' \strong{vcs} character object that defines for vcs which version control system to attach
#'  (github, bitbucket, svn)
#'  
#' \strong{preview.search} character object that defines a search term to initialize to in the
#'  preview pane searchbox
#' 
#' if \strong{remote_repo} is given a preview pane of a selected file from the tree will appear to 
#' the right of the tree 
#' 
#' \strong{preview.search} is only relevant for vcs in (github,bitbucket) where file
#'  previewing is available
#' 
#' For more information on the vcs package go to \url{https://github.com/yonicd/vcs}
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
#' #pass additional parameters to core
#' jsTree(nested_string,core=list(multiple=FALSE))
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
#' @importFrom htmltools save_html browsable
#' @export
jsTree <- function(obj, 
                   sep = '/',
                   sep_fixed = TRUE, 
                   core=NULL,
                   tooltips=NULL, 
                   nodestate=NULL, 
                   ... , 
                   width = NULL, 
                   height = NULL, 
                   elementId = NULL,
                   file = tempfile(pattern = 'jstree-',fileext = '.html'),
                   browse = TRUE) {

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
                 tooltips  = tooltips,
                 sep = sep,
                 sep_fixed = sep_fixed
                 )
  
  # forward options using x
  x <- list(core = jsonlite::toJSON(c(list(data=obj.in),core),auto_unbox = TRUE),
            vcs  = vcs, 
            sep  = sep)
  
  if( 'preview.search'%in%names(match.call()) ) {
      x$forcekey <- preview.search
    }
  
  if( !is.null(remote_repo) ){
    
    x$uri <- switch(vcs,
                     github = sprintf('https://raw.githubusercontent.com/%s/%s',remote_repo,remote_branch),
                     bitbucket = sprintf('https://bitbucket.org/%s/raw/%s',remote_repo,remote_branch)
                   )
    
  }

  
  # create widget
  w <- htmlwidgets::createWidget(
    name      = 'jsTree',
    x,
    width     = width,
    height    = height,
    package   = 'jsTree',
    elementId = elementId
  )
  
  if (browse) {
    w
  }else{
    htmltools::save_html(htmltools::browsable(w), file)
    invisible(file)  
  }
  
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
