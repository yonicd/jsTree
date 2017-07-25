makeList <- function(x,tooltips) {
  idx <- is.na(x[,2])
  if (ncol(x) > 2 && sum(idx) != nrow(x)){
    listSplit <- split(x[-1], x[1], drop=T)
    lapply(names(listSplit), function(y){
      l2<-listSplit[[y]]
      if(all(is.na(l2[!names(l2)%in%c('nodestate')]))){
        lout=list(text = y,icon='glyphicon glyphicon-file text-info',state=list(selected=l2$nodestate))
        if(any(y%in%names(tooltips))) lout$a_attr=list(title=tooltips[grep(y,names(tooltips),value=TRUE)])
        lout
      }else{
        lout=list(text = y,children = makeList(l2,tooltips))
        if(any(y%in%names(tooltips))) lout$a_attr=list(title=tooltips[grep(y,names(tooltips),value=TRUE)])
        lout
      }
    })
  } else {
    if(!all(is.na(x[,1]))){nms <- x[,1]
    lapply(seq_along(nms), function(y){
      lout=list(text = nms[y],icon='glyphicon glyphicon-file text-info',state=list(selected=x$nodestate[y]))
      nm=nms[y]
      if(any(nm%in%names(tooltips))) lout$a_attr=list(title=tooltips[grep(nm,names(tooltips),value=TRUE)])
      lout
    })
    }
  }
}

#'@importFrom plyr rbind.fill
nest<-function(l,root='root',nodestate=NULL,tooltips=NA){
  df=data.frame(V0=root,
             plyr::rbind.fill(lapply(strsplit(l,'/'),
                                     function(x) as.data.frame(t(x),stringsAsFactors = FALSE)),
                              fill = TRUE),
             stringsAsFactors = FALSE)
  df$value=NA
  
  if(is.null(nodestate)){
    df$nodestate=FALSE  
  }else{
    df$nodestate=nodestate 
  }
  
  makeList(df,tooltips)
}