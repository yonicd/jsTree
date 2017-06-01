#'@export
makeList <- function(x) {
  idx <- is.na(x[,2])
  if (ncol(x) > 2 && sum(idx) != nrow(x)){
    listSplit <- split(x[-1], x[1], drop=T)
    lapply(names(listSplit), function(y){
      l2<-listSplit[[y]]
      if(all(is.na(l2))){
        list(text = y,icon='glyphicon glyphicon-leaf',state=list())
      }else{
        list(text = y, children = makeList(l2))  
      }
    })
  } else {
    if(!all(is.na(x[,1]))){nms <- x[,1]
    lapply(seq_along(nms), function(y){
      list(text = nms[y],icon='glyphicon glyphicon-leaf',state=list())
    })
    }
  }
}

#'@export
#'@importFrom plyr rbind.fill
nest<-function(l){
  df=data.frame(V0='root',
             plyr::rbind.fill(lapply(strsplit(l,'/'),
                                     function(x) as.data.frame(t(x),stringsAsFactors = FALSE)),
                              fill = TRUE),
             stringsAsFactors = FALSE)
  df$value=NA
  makeList(df)
}