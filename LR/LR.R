imputer<-function(newMat,xyz)
{
  xyz<-xyz[match(colnames(newMat),rownames(xyz)),]
  stationNames<-rownames(xyz)
  xyz<-round(as.matrix(dist(xyz))/1000,1)
  C<-cor(newMat,use='pairwise.complete.obs')
  metrics<-matrix(NA,1,6)
  trial<-1
  missingCounts<-c(prod(dim(newMat)),sum(is.na(newMat)))
  while(all(c(abs(missingCounts[trial+1]-missingCounts[trial])>0 ,
              missingCounts[trial+1] !=0)))
  {
    for(i in 1:ncol(newMat))
    {
      y<-newMat[,i]
      if(any(is.na(y)))
      {
        distances<-xyz[i,-i]
        correlations<-C[i,-i]
        dd<-data.frame(distances,correlations)
        if(any(is.na(dd[,2])))
        {
          dd<-dd[-which(is.na(dd[,2])),]
        }
        dd<-dd[with(dd, order(distances, correlations)),]
        j=0
        while(any(is.na(y)))
        {
          j<-j+1
          if (j>nrow(dd)) break
          x<-newMat[,match(rownames(dd)[j],colnames(newMat))]
          id<-which(apply(cbind(is.na(x),!is.na(y)),1,sum)==0)
          if(length(id)>0)
          {
            m<-lm(y~x-1)
            y[id]<-predict(m,data.frame(x=x[id]))
            reg<-rownames(dd)[j]
            res<-colnames(newMat)[i]
            COEF<-round(coef(m),2)
            names(COEF)<-NULL
            rmse<-round((sum(residuals(m)^2)/(length(residuals(m))-1))^0.5,2)
            cc<-round(dd[j,2],2)
            ddd<-round(dd[j,1],2)
            p<-c(reg,res,COEF,rmse,cc,ddd)
            names(p)<-c('regressor','response','model param','RMSE','correlation','distance')
            metrics<-rbind(metrics,p)
          }
        }
      }
      newMat[,i]<-y
    }
    trial<-trial+1
    missingCounts<-c(missingCounts,sum(is.na(newMat)))
  }
  metrics<-metrics[-1,]
  return(list(metrics=metrics,newMat=newMat))
}
