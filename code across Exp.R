###--------------------------------------------------------------------------
# G-BLUP with additive and dominance effect
###--------------------------------------------------------------------------
rm(list=ls(all=TRUE))
library(BGLR)
setwd(choose.dir())
# Integrated SNP data

Data<-read.table("Integrated data SNP of the hybrid trials.txt",header=TRUE)

## Integrated phenotypic data(BLUEs)

BluesInt<-read.table("Integrated data BLUEs of the hybrid trials.txt",header=TRUE)

# Only use Exp. II and Exp. III

GroupA<-which(BluesInt[,"Exp.II"]>0)
Train<-GroupA
GroupB<-which(BluesInt[,"Exp.III"]>0)
Test<-setdiff(GroupB,GroupA)
Data_used<-Data[c(Train,Test),]
Phdata<-BluesInt[c(Train,Test),]
identical(Phdata$Geno,Data_used$Geno)

# Now markers code as -1,0,1, with a few -0.5,0.5

GNdata <-as.matrix(Data_used[,-c(1:3)]-1) 
rownames(GNdata)<-Data_used$Geno
dim(GNdata)

# Remove SNPs with zero minor allele frequency
 
alfreq2 <- apply(GNdata,2,mean)+1
Palle<-(alfreq2)/2
mean(Palle)
which(Palle==0)
del<-c(which(Palle==0),which(Palle==1))
if(length(del)>0){
X <- as.matrix(GNdata[,-del])  
}else{
X <- as.matrix(GNdata)  
}
n <- nrow(X)
p <- ncol(X)

nmarker<-dim(X)[2]# number of markers

## Generate the relationship matrices

## The additive relationship matrix 
alfreq2 <- apply(X,2,mean)
Palle<-(alfreq2+1)/2

P <- matrix(rep(alfreq2,n),nrow=n,byrow=TRUE)
X1 <- X-P
G <- X1%*%t(X1)
G1 <- G/sum(2*Palle*(1-Palle)) 

# The dominance relationship matrix
U<-X
nGen<-dim(X)[1]
for(i in 1:nmarker){
P11<-(length(which(X[,i]==-1))+0.5*length(which(X[,i]==-0.5)))/nGen 
P12<-(length(which(X[,i]==0))+0.5*length(which(X[,i]==-0.5))+0.5*length(which(X[,i]==0.5)))/nGen
P22<-(length(which(X[,i]==1))+0.5*length(which(X[,i]==0.5)))/nGen 
Theta<-P11+P22-(P11-P22)^2
if(Theta==0){
print("SNP data is wrong")
break
}
d11<- -2*P12*P22/Theta
d12<- 4*P11*P22/Theta
d22<- -2*P11*P12/Theta
U[which(X[,i]==-1),i]<- d11
U[which(X[,i]==0),i]<-  d12
U[which(X[,i]==1),i]<-  d22
U[which(X[,i]==-0.5),i]<- (d11+d12)/2
U[which(X[,i]==0.5),i]<- (d12+d22)/2
}
range(U)
GU <- U%*%t(U)
G2 <- GU/sum((2*Palle*(1-Palle))^2)


dim(Phdata)

## Check whether the phenotypic data and the relationship matrix are consistent
identical(as.character(Phdata$Geno),rownames(G1))

Y<-as.matrix(Phdata[,"Blues"])
TrainSet<- c(1:length(Train)) ## The training set,lines and hybrids from Exp II.
TestSet<-  setdiff(1:length(Y),TrainSet)## Rest of the data as the test set.

   
Yna <- Y
Yna[TestSet] <- NA
ETA <- list(list(X=as.numeric(Phdata$Hybrid),model='FIXED'),
                list(K1=G1,model="RKHS"),
                list(K2=G2,model="RKHS")
                )
system.time( 
    fm <- BGLR(y=Yna,
               ETA=ETA,
               nIter=3000,#set for example code, the actual calculation requires more
               burnIn=300,#set for example code, the actual calculation requires more
               saveAt=paste("Exp II predict Exp III BGLR_G1_G2",sep=""),
               verbose=FALSE)   
    )
Y_predict <- fm$yHat
    
## cor of lines in test Exp
LnTest<-intersect(which(Phdata$Hybrid==0),TestSet)    
cor(Y_predict[LnTest],Y[LnTest])

## cor of Hybrids in test Exp
HyTest<-intersect(which(Phdata$Hybrid==1),TestSet)  
cor(Y_predict[HyTest],Y[HyTest])








