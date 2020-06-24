rm(list=ls(all=TRUE))
library(BGLR)
Phdata<-read.table("Yield within Exp I.txt",header=TRUE) # Phenotypic data for grain yield.
G1<-read.table("Additive relationship matrix for Exp I.txt")
G2<-read.table("Dominance relationship matrix for Exp I.txt")
G1<-as.matrix(G1)
G2<-as.matrix(G2)

CVsave100<-read.table("CVsave100 T012 for Exp I.txt",header=TRUE)

ncv<-100 # Number of cross-validation.
corSave <- matrix(0,ncv,3) # Recorder the prediction ability in each round of cross-validation.
colnames(corSave)<-c("T2","T1","T0")

set.seed(1234)
Multi<-"FALSE" # When using multiple experiment series, set this parameter as "TRUE".

Y <- Phdata$Yield ## get the trait
system.time(
  for (k in 1:ncv)
  {
    TrainSet<- setdiff(as.numeric(CVsave100[k,1:1000]),0) ## The training set, including 90 parent lines and 600 hybrids.
    TestSet<-  setdiff(1:length(Y),TrainSet)## Rest of the data as the test set.
	
    Yna <- Y
    Yna[TestSet] <- NA
  if(Multi=="FALSE"){
    ETA <- list(
                list(K1=G1,model="RKHS"),
                list(K2=G2,model="RKHS")
                )
    }else{
    ETA <- list(list(X=as.numeric(Phdata$Type),model='FIXED'),
                list(K1=G1,model="RKHS"),
                list(K2=G2,model="RKHS")
                )
    }
	# Prediction model.
    system.time( 
    fm <- BGLR(y=Yna,
               ETA=ETA,
               nIter=30000,
               burnIn=3000,
               saveAt="Exp I BGLR_G1_G2.txt",
               verbose=FALSE)   
    )
    Y_predict <- fm$yHat
    
    ## cor T2 test
    testT2<-setdiff(as.numeric(CVsave100[k,1001:1500]),0)  
    corSave[k,1]<- cor(Y_predict[testT2],Y[testT2])
    ## cor T1 test
    testT1<-setdiff(as.numeric(CVsave100[k,1501:2500]),0)  
    corSave[k,2]<- cor(Y_predict[testT1],Y[testT1])
    ## cor T0 test
    testT0<-setdiff(as.numeric(CVsave100[k,2501:2995]),0)  
    corSave[k,3]<- cor(Y_predict[testT0],Y[testT0])

    plot(Y_predict[TestSet],Y[TestSet])
   ## write.table(corSave,"Prediction ability within ExpI by A_D_GBLUP.txt",quote=FALSE)
    cat("cv",k,"is completed\n") 
    if(k>1)print(colMeans(corSave[1:k,]))
  }# end
)  
colMeans(corSave)#/sqrt(hert)
