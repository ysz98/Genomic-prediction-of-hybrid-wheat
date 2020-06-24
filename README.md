# Genomic-prediction-of-hybrid-wheat
#Example code and data for predict hybrid performance in Exp I. 
#The GBLUP model uses BGLR package (Pérez and de los Campos, 2014) in R (R Core Team, 2019). The R version used in this work is <= 3.6.0.
#The codes used in other experiments are the same, only the phenotype recorder and relationship matrix need to be changed.
#The input data includes 4 files. 
#The file "Yield within Exp I.txt" is phenotypic data with 5 columns, while the first 4 columns are the genotype name, parental information 
#and genotype type, and the last column is the grain yield (Mg ha -1) 
#The files "Additive relationship matrix for Exp I.zip" and "Dominance relationship matrix for Exp I.zip" are genomic relationship matrices 
#calculated from SNP data of all genotypes used in Experiment I. 
#The file "CVsave100 T012 for Exp I.txt" records 100 cross-validation training and test sets.
