#' @title R6 class for the jsTree Javascript library
#' @description Htmlwidget for the jsTree Javascript library
#' @examples 
#' if(interactive()){
#' 
#' data(states)
#' data(state_bird)
#' 
#' x <- jsTree::jsTree$new()
#' 
#' # add data (can be data.frame or character)
#'  # each row of the data.frame columns are 
#'  # collapsed with x$sep to create a character vector
#'  
#' x$data <- states
#' 
#' x$data
#' 
#' # show the widget
#'  x$show()
#' 
#' # add tooltips
#'  x$tooltips <- state_bird
#'  x$show()
#' 
#' # add plugins
#' # search and checkbox are added as defaults
#'  x$active_plugins
#' 
#'  x$active_plugins.append(c('contextmenu','dnd','unique'))
#' 
#'  x$active_plugins
#' 
#'  x$show()
#' 
#' # add callbacks or options to a plugin
#'  x$plugins[['dnd']] <- list(is_draggable = FALSE)
#'  # x$plugins[['contextmenu']] <- list(items = JS('script here'))
#' 
#' x$plugins
#' 
#' x$show()
#' 
#' # change core options
#'  x$core_params <- list(multiple=FALSE)
#'
#' # add inital nodestate with logical call that are applied to x$data
#'  x$nodestate(variable=='Area')
#' 
#' x$show()
#' 
#' 
#' }
#' 
#' @importFrom R6 R6Class
#' @import htmlwidgets
#' @importFrom jsonlite toJSON
#' @importFrom htmltools save_html browsable
#' @importFrom rlang quos quo quo_expr
#' @rdname jsTree
#' @export
jsTree <- R6::R6Class("tree",
                       public = list(
                         initialize = function(data = NULL){
                           
                           self$plugins <- private$base_plugins[!sapply(private$base_plugins,is.null)]
                           
                           if(!is.null(data))
                             self$data <- data
                           
                         },
                         nest_data = function(){
                           nest(l = private$convert_data(self$data,self$sep),
                                root = self$root,
                                nodestate = self$current_nodestate,
                                tooltips = self$tooltips,
                                sep = self$sep,
                                sep_fixed = self$sep_fixed
                                )
                         },
                         nodestate = function(...){
                           
                           self$current_nodestate <- private$filter(self$data,...)
                           
                           self$nested_data <- self$nest_data()
                         },
                         create_core = function(){
                           
                           core <- list(data=self$nest_data())
                             
                           if(length(self$core_params)>0)
                             core <- c(core,self$core_params)
                           
                           jsonlite::toJSON(core,auto_unbox = TRUE)
                           
                         },
                         add_vcs = function(remote_repo,
                                            vcs = 'github',
                                            remote_branch = 'master',
                                            raw_token = NULL){
                           
                           self$vcs <- vcs
                           self$remote_branch <- remote_branch
                           
                           if(!is.null(raw_token))
                            self$raw_token <- raw_token
                           
                           self$root = ifelse(vcs=='svn',
                                  remote_repo,
                                  paste(remote_repo,remote_branch,sep='/')
                           )
                           
                           self$uri <- switch(vcs,
                                         ghe    = sprintf('https://ghe.metrumrg.com/raw/%s/%s',
                                                          remote_repo,
                                                          remote_branch),
                                         github = sprintf('https://raw.githubusercontent.com/%s/%s',
                                                          remote_repo,
                                                          remote_branch),
                                         bitbucket = sprintf('https://bitbucket.org/%s/raw/%s',
                                                             remote_repo,
                                                             remote_branch)
                           )
                           
                           # if(self$vcs!='svn')
                           #    self$plugins[['contextmenu']] <- list(items = jsTree:::customMenu())

                         },
                         update_preview_search = function(x){
                           self$preview_search <- x
                         },
                         print_core = function(pretty = FALSE){
                           jsonlite::toJSON(jsonlite::fromJSON(self$create_core()),pretty = pretty)
                         },
                         print = function(){
                           print(self$data)
                         },
                         create_widget = function(){
                           
                           plugins = private$merge_plugins()
                           
                           x <- list(core = self$create_core(),
                                       vcs = self$vcs,
                                       sep = self$sep,
                                       forcekey = self$preview_search,
                                       uri = self$uri,
                                       raw_token = self$raw_token,
                                       active_plugins = self$active_plugins,
                                       plugins = plugins,
                                       jsplugins = private$jsplugins
                                       )
                           
                           x <- x[!sapply(x,is.null)]

                           self$w <- htmlwidgets::createWidget(
                             name      = 'jsTree',
                             x,
                             width     = self$width,
                             height    = self$height,
                             package   = 'jsTree',
                             elementId = self$elementId
                           )
                           
                         },
                         show = function(){
                           self$create_widget()
                           self$w
                         },
                         save = function(file = tempfile(pattern = 'jstree-',fileext = '.html')){
                           self$create_widget()
                           htmltools::save_html(htmltools::browsable(self$w), file)
                         },
                         plugins.reset = function(){
                           self$plugins <- private$base_plugins
                         },
                         active_plugins.append = function(x){
                           self$active_plugins <- union(self$active_plugins,x)
                         },
                         plugins = NULL,
                         active_plugins = c('search','checkbox'),
                         w = NULL,
                         current_nodestate = NULL,
                         tooltips = NULL,
                         data = NULL,
                         nested_data = NULL,
                         core = NULL,
                         core_params = list(check_callback = TRUE),
                         sep = '/',
                         sep_fixed = TRUE,
                         preview_search = NULL,
                         width     = NULL, 
                         height    = NULL, 
                         elementId = NULL,
                         browse    = TRUE,
                         vcs = 'github',
                         remote_branch = 'master',
                         uri = NULL,
                         raw_token = NULL,
                         root = '.'
                       ),
                     private = list(
                       convert_data = function(obj,sep){
                         
                         if(inherits(obj,c('data.frame','tbl_df')))
                           obj <- apply(obj,1,function(x){
                             paste(gsub('^\\s+|\\s+$','',x),collapse=sep)
                           })
                         obj
                       },
                       filter = function(data,...){
                         with(data,{
                          eval(rlang::quo_expr(rlang::quo(...)))
                         })
                       },
                       select = function(data,...){
                         data[as.character(sapply(rlang::quos(...),
                                                  rlang::quo_expr))]
                       },
                       merge_plugins = function(){
                         find_bad <- setdiff(names(self$plugins), names(private$base_plugins))
                         
                         if(length(find_bad)>0)
                           stop(sprintf('misspecified plugins: %s', paste(find_bad,collapse = ', ')))
                         
                         plugins <- private$base_plugins
                         for(nm in names(self$plugins)){
                           plugins[[nm]] <- self$plugins[[nm]]
                         }
                         
                         plugins <- plugins[self$active_plugins]
                         
                         for(i in names(plugins)){

                           if (j == 'conditionalselect') {print(j)}
                           for(j in seq_along(plugins[[i]])){
    
                             if(inherits(plugins[[i]][[j]],'JS_EVAL')){
                               private$jsplugins[[i]] <- plugins[[i]]
                               plugins[[i]] <- c()
                             }
                            }
                         }

                         jsonlite::toJSON(plugins,auto_unbox = TRUE)

                       },
                       jsplugins = list(),
                       base_plugins = list(
                         checkbox = c(),
                         contextmenu = c(),
                         dnd = c(),
                         massload = c(),
                         search = list(
                           case_sensitive = FALSE,
                           show_only_matches = FALSE),
                         sort = c(),
                         state = c(),
                         types = c(),
                         unique = c(),
                         wholerow = c(),
                         changed = c(),
                         conditionalselect = c()
                         )
                      )
                     
                    )
