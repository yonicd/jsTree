library(shiny)
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
    obj=vcs::ls_remote(input$f1,vcs = 'github')
    jsTree::jsTree(obj = obj,remote_repo = input$f1,remote_branch = 'master')
  })

   observeEvent(c(input$createRepo),{
     f2<-gsub(sprintf('%s/%s',input$f1,'master'),'',network$tree)
     if(length(f2)>0){
       if(dir.exists(sprintf('%s/.git',input$dirOutput))){
         vcs::sparse_checkout(repo_url = sprintf('https://github.com/%s.git',input$f1),
                                   dirs = f2,
                                   repo = input$dirOutput,
                                   create = FALSE,
                                   append = FALSE)
       }else{
         vcs::sparse_checkout(repo_url = sprintf('https://github.com/%s.git',input$f1),
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

