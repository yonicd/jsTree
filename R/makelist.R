makeList <- function(x,tooltips){
  
  idx <- is.na(x[,2])
  
  if( ncol(x) > 2 && sum(idx) != nrow(x) ){
    
    list_split <- split(x[-1], x[1], drop=TRUE)
    
    lapply(names(list_split), function(y){
      
      l2 <- list_split[[y]]
      
      if( all(is.na(l2[!names(l2)%in%c('nodestate')])) ){
        
        lout <- list(text = y,icon='glyphicon glyphicon-file text-info',state=list(selected=l2$nodestate))
        
        if( any(y%in%names(tooltips)) ) 
          lout$a_attr <- list(title=tooltips[grep(y,names(tooltips),value=TRUE)])
        
        lout
        
      }else{
        
        lout <- list(text = y,children = makeList(l2,tooltips))
        
        if( any(y%in%names(tooltips)) ) 
          lout$a_attr <- list(title=tooltips[grep(y,names(tooltips),value=TRUE)])
        
        lout
        
      }
    })
  }else{
    
    if( !all(is.na(x[,1])) ){
      
      nms <- x[,1]
      
      lapply(seq_along(nms), function(y){
        
      lout <- list(text = nms[y],icon='glyphicon glyphicon-file text-info',state=list(selected=x$nodestate[y]))
      
      nm <- nms[y]
      
      if( any(nm%in%names(tooltips)) ) 
        lout$a_attr <- list(title=tooltips[grep(nm,names(tooltips),value=TRUE)])
      
      lout
    })
    }
  }
}

#' @importFrom data.table rbindlist
nest <- function(l, root='root', nodestate=NULL, tooltips=NA, sep='/',sep_fixed = TRUE){
  
  df <- data.frame(V0=root,
                   data.table::rbindlist(lapply(strsplit(l,sep,fixed=sep_fixed),
                                     function(x) as.data.frame(t(x),stringsAsFactors = FALSE)),
                                    fill=TRUE),
             stringsAsFactors = FALSE)
  
  df$value <- NA
  
  if( is.null(nodestate) ){
    
    df$nodestate <- FALSE  
    
  }else{
    
    df$nodestate <- nodestate
    
  }
  
  if(all(df[,1]==df[,2])) df[,2] <- NULL
  
  ret <- makeList(df,tooltips)
  
  if(ret[[1]]$text=='.')
    ret <- ret[[1]]$children
  
  ret
} 