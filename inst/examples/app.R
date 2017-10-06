library(jsTree)

ui <- shiny::fluidPage(
  
  shiny::column(width=4,jsTree::jsTreeOutput('tree')),
  
  shiny::column(width=8,shiny::uiOutput('chosen'))
  
)

server <- function(input, output,session) {
  
  network <- shiny::reactiveValues()
  
  shiny::observeEvent(input$tree_update,{
    
    current_selection <- input$tree_update$.current_tree
    if(!is.null(current_selection)) 
      network$tree <- jsonlite::fromJSON(current_selection)
    
  })
  
  shiny::observeEvent(network$tree,{
    
    output$results <- shiny::renderPrint({
      
      str.out <- ''
      
      if(length(network$tree)>0)
        str.out=network$tree
      
      return(str.out)
    })    
  })
  
  output$chosen <- shiny::renderUI({
    
    list(shiny::h3('Selected Items'),
         
    shiny::verbatimTextOutput(outputId = "results"))
    
  })
  
  output$tree <- jsTree::renderJsTree({
    
    nested_string <- apply(states,1,paste,collapse='/')
    
    jsTree(nested_string)
    
  })
  
}

shinyApp(ui, server)
