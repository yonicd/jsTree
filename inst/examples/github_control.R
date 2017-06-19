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
  
  observeEvent(input$f1,{
    output$results <- renderPrint({
      str.out=''
      return(str.out)
    })    
  })
  
  output$tree <- jsTree::renderJsTree({
    vcs_type='github'
    if(input$f1=='~/projects/reprex_sparse') vcs_type='git'
    obj=vcs::ls_remote(input$f1,vcs = vcs_type)
    opts=NULL
    if(dir.exists(input$f1)) opts=list(nodestate=vcs::diff_head(input$f1,vcs='git',show = FALSE))
    vcs::navigate_remote(input$f1,vcs=vcs_type,output.opts = opts)
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
 
   output$chosen=renderUI({
     verbatimTextOutput(outputId = "results")
   })

}

ui <- fluidPage(
         selectInput(inputId = 'f1',label = 'choose repo',choices = c('yonicd/ciderhouse','tidyverse/ggplot2','tidyverse/reprex','~/projects/reprex_sparse'),selected = '~/projects/reprex_sparse'),
         actionButton('createRepo','create sparse checkout'),
         textInput('dirOutput','',placeholder = 'path of checkout'),
         uiOutput('chosen'),
         jsTree::jsTreeOutput(outputId = 'tree')
)

shinyApp(ui = ui, server = server)

