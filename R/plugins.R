#' @title jsTree plugin builder api
#' @description api to iteratively create jsTree plugins
#' @param name character, name of plugin
#' @param attr list, names of attributes relevant to the plugin
#' @return list
#' @details plugins and their characteristics can be found at \url{https://www.jstree.com/api/}
#' @examples 
#' p <- plugin(name = 'search',
#' attr = list(case_sensitive = FALSE,
#'             show_only_matches = FALSE))
#' 
#' p
#' 
#' p1 <- plugin(name = 'dnd',
#'              attr = list(copy = FALSE))
#' 
#' p1
#' 
#' 
#' p2 <- p + p1
#' 
#' p2
#' 
#' p2 + plugin(name = 'dnd',
#'              attr = list(copy = TRUE))
#' 
#' p2 - p + p1
#' @rdname plugin
#' @export 

plugin <- function(name,attr){
  ret <- setNames(list(attr),name)
  attr(ret,'class') <- c('list','plugin')
  return(ret)
}




#' @title Add/remove child plugins from plugin object
#' @description + will add/replace a plugin child to a plugin object, 
#' - will remove a child from a plugin object
#' @param e1 plugin object
#' @param e2 child to add/remove
#' @return plugin object
#' @details DETAILS
#' @examples 
#' @examples 
#' p <- plugin(name = 'search',
#' attr = list(case_sensitive = FALSE,
#'             show_only_matches = FALSE))
#' 
#' p
#' 
#' p1 <- plugin(name = 'dnd',
#'              attr = list(copy = FALSE))
#' 
#' p1
#' 
#' p2 <- p + p1
#' 
#' p2
#' 
#' p2 - p + p1
#' @rdname plugin-ops
#' @export 
`+.plugin` <- function(e1,e2){
  
  idx <- grep(names(e2),names(e1))
  
  if(length(idx)>0){
    e1 <- e1[-idx]
  }
  
  e1 <- append(e1,e2)
  
  attr(e1,'class') <- c('list','plugin')
  
  return(e1)
}

#' @export
#' @rdname plugin-ops
`-.plugin` <- function(e1,e2){
  
  idx <- grep(names(e2),names(e1))
  
  if(length(idx)>0)
    e1 <- e1[-idx]
  
  attr(e1,'class') <- c('list','plugin')
  return(e1)
}


#' @title Print method for plugin objects
#' @description Prints a plugin object in json form
#' @param x plugin object
#' @param \dots unused
#' @seealso 
#'  \code{\link[jsonlite]{toJSON, fromJSON}}
#' @rdname print-plugin
#' @export 
#' @importFrom jsonlite toJSON
print.plugin <- function(x,...){
  print(jsonlite::toJSON(x,pretty = TRUE,auto_unbox = TRUE))
}