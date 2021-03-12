#Genomic-prediction-of-hybrid-wheat
#The GBLUP model uses BGLR package (Pérez and de los Campos, 2014) in R (R Core Team, 2019). The R version used in this work is <= 3.6.0.
#The codes used in other experiments are the same, only the phenotype recorder and relationship matrix need to be changed.

#++++++++++++++++++++++
##The example code and data for predict hybrid performance across experiments.
#++++++++++++++++++++++
#The example code "code across Exp.R" used Exp. II as the training set and Exp. III as the test set. 
#The input data includes two files. The file "Integrated data BLUEs of the hybrid trials.txt" is the integrated phenotypic data with 11 columns, while the first four columns are the BLUEs for grain yield (Mg ha -1), parental information, genotype name, and the rest column are the design matrix for hybrid, lines, and experiments, respectively. The file "Integrated data SNP of the hybrid trials.zip" is the integrated SNP data of all lines and hybrids used for Experiment I-V.

#++++++++++++++++++++++
##The example code and data for predict hybrid performance in Exp I. 
#++++++++++++++++++++++
#The "code.R" is used to predict hybrid performance within Exp I
#The input data includes three files. 
#The file "Yield within Exp I.txt" is phenotypic data with five columns, while the first four columns are the genotype name, parental information, and genotype type, and the last column is the within experiment BLUEs for grain yield (Mg ha -1). 
#BLUEs used in "code.R" is within experiment BLUEs, which should not be confused with the BLUEs from the integrated analysis.
#The files "Additive relationship matrix for Exp I.zip" and "Dominance relationship matrix for Exp I.zip" are genomic relationship matrices calculated from SNP data of all genotypes used in Experiment I. 
The relationship matrices are pre-calculated to save calculation time for cross-validation.
#The file "CVsave100 T012 for Exp I.txt" records 100 cross-validation training and test sets.
