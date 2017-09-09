# jsTree

## Examples

### Preview a github repo without cloning it

```r
devtools::install_github('yonicd/jsTree')

#get repo master branch directory structure
  x<-ciderhouse::show_repo('tidyverse/purrr',showTree = FALSE)

#visuzlize repo
  jsTree(x)
```

![](https://github.com/yonicd/jsTree/blob/master/Miscellaneous/show_git_buttons.gif?raw=true)

### Control github checkout with jsTree, ciderhouse and shiny

```r
library(shiny)
library(ciderhouse)
library(jsTree)
server <- function(input, output,session) {
  
  network <- reactiveValues()
  
  observeEvent(input$tree_update,{
    current_selection<-input$tree_update$.current_tree
    if(!is.null(current_selection)) network$tree <- jsonlite::fromJSON(current_selection)
  })
  
  observeEvent(network$tree,{
    output$results <- renderPrint({
      str.out=''
      if(length(network$tree)>0) str.out=network$tree
      return(str.out)
    })    
  })
  
  output$tree <- jsTree::renderJsTree({
    obj=ciderhouse::show_repo(input$f1,showTree = FALSE)
    jsTree::jsTree(obj = obj,gh_repo = input$f1,gh_branch = 'master')
  })

   observeEvent(c(input$createRepo),{
     f2<-gsub(sprintf('%s/%s',input$f1,'master'),'',network$tree)
     if(length(f2)>0){
       if(dir.exists(sprintf('%s/.git',input$dirOutput))){
         ciderhouse::sparse_github(repo_url = sprintf('https://github.com/%s.git',input$f1),
                                   dirs = f2,
                                   repo = input$dirOutput,
                                   create = FALSE,
                                   append = FALSE)
       }else{
         ciderhouse::sparse_github(repo_url = sprintf('https://github.com/%s.git',input$f1),
                                   dirs = f2,
                                   repo = input$dirOutput,
                                   create = TRUE)
       }
       }
   })
  
}

ui <- fluidPage(
         selectInput(inputId = 'f1',label = 'choose repo',choices = c('yonicd/ciderhouse','tidyverse/ggplot2','tidyverse/reprex'),selected = 'yonicd/ciderhouse'),
         actionButton('createRepo','create sparse checkout'),
         textInput('dirOutput','',placeholder = 'path of checkout'),
         verbatimTextOutput(outputId = "results"),
         jsTree::jsTreeOutput(outputId = 'tree')
)

shinyApp(ui = ui, server = server)
```
