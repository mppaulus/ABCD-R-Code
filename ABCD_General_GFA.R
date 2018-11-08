# General code to run multiple GFAs on the server
# 8/23/2018

library(GFA)
# library(data.table)

# load the Basic Data set:

# mydir <- paste0("/home/librad.laureateinstitute.org/mpaulus/ABCD_data/")
mydir <- paste0("/Users/mpaulus/Dropbox (Personal)/Private/RDataAnalysis/ABCD_Data/Media/")
# mydir <- paste0("/Users/mpaulus/Dropbox (Personal)/Private/RDataAnalysis/ABCD_Data/NegReinforcement/")

# File components:
myfile <- c("ABCD_nda17_")
GFAtext <- c("preGFA_")
dateext <- c("08.30.2018")

myall <- paste0(mydir,myfile,GFAtext,dateext,".RData")
load(myall)

mynames <- names(abcdnegreinf)

# Load different variable sets:

myall <- paste(mydir,"abcd_activars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_cbclvars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_cogvars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_friendvars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_medvars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_sulcvars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_thickvars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_volvars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_screenvars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_socialsummaryvars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_physvars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_covars_08.23.2018",".RData",sep="")
load(myall)

myall <- paste(mydir,"abcd_suicidvars_08.23.2018",".RData",sep="")
load(myall)

# Revise the variable sets
# male 0, female 1
# abcdcomb$Sex <- ifelse(abcdcomb$female=="no",0,1)
# parents married no = 1, yes = 1
# abcdcomb$ParMar <- ifelse(abcdcomb$married=="no",0,1)

socialvars <- socialsummaryvars[-grep("sds",socialsummaryvars)]
screenvars <- mynames[intersect(grep("screen",mynames),grep("y$",mynames))]
screenlabels <- c("Weekday TV/Movie","Weekday Videos","Weekday Games","Weekday Texting","Weekday Social Network","Weekday Chat","Weekend TV/Movie","Weekend Videos","Weekend Games","Weekend Texting","Weekend Social Network","Weekend Chat","ANY_mature","ANY_Rmovie")
coglabels <- c("Picture Vocabulary","Flanker Tes","List Sorting","Card Sorting","Pattern Comparison","Picture Sequence","Oral Reading Recog","Fluid Composite","Crystallized Composite","Cognition Total","RAVLT Short Delay","RAVLT Long Delay","WISC-V Matrix Reasoning")
soclabels <-c("Parental Monitoring","Family Environment: Conflict Y","Family Environment: Conflict P","CPBRI: Acceptance P","CPBRI: Acceptance CG","Prosocial Behavior P",
              "Prosocial Behavior Y")

# setnames(abcdnegreinf, old=c(screenvars), new=c(screenlabels))

# demovars <- covars[-grep("high",covars)]
# demovars <- demovars[-grep("race",demovars)]
# demovars <- demovars[-grep("female",demovars)]
# demovars <- demovars[-grep("married",demovars)]
# demovars <- c(demovars,"Sex","ParMar")


####
#
# Set up the GFA here:
#

# select the groups of variables

CBCL <- as.matrix(abcdnegreinf[,c(cbclvars)])
SCREEN <- as.matrix(abcdnegreinf[,c(screenvars)])
COG <- as.matrix(abcdnegreinf[,c(cogvars)])
SOC <- as.matrix(abcdnegreinf[,c(socialvars)])
# DEMO <- as.matrix(abcdcomb[,c(demovars)])

indepvars <- c(cbclvars,screenvars,cogvars,socialvars)

# form a list of variables from the data set
MY <- list(CBCL,SCREEN,COG,SOC)

mynorm <- normalizeData(MY, type="scaleFeatures")

# set up the GFA defaults

# Get the default options
opts <- getDefaultOpts()
opts$vrbose <- 0

# number of data for posterior vector:
opts$iter.saved = 100

startK = length(c(indepvars))

# File components:
myfile <- c("ABCD_GFA_")
GFAtext <- c("screen_CBCL_COG_ENV_")
dateext <- c("_08.31.2018")

# Run the GFA (multiple times)
set.seed(123);
res <- list()
for(i in 1:10){
print(i)
myall <- paste0(mydir,myfile,GFAtext,i,dateext,".RData",sep="")
print(myall)

res[[i]] <- gfa(mynorm$train, K=startK, opts=opts)

# Save as an interim variable
myres <- res[[i]]

# Save the GFA results
# Write the result to a file
myall <- paste0(mydir,myfile,GFAtext,i,dateext,".RData",sep="")
save(myres, file=myall)
}

# Save robust components
rob <- robustComponents(res)
myall <- paste0(mydir,myfile,GFAtext,"Robust",dateext,".RData",sep="")
save(rob, file=myall)

