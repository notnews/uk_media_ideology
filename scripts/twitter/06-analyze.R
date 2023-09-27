"
Purpose: Correspondence Analysis
Gaurav Sood and Philip Habel

Where?: In the Clouds
"

# set basedir
setwd(basedir)
setwd("media/uk_media_ideology/")

# Load libs 
library(Matrix)
library(ca)

## load sparse matrix
load("out/twitter/sparse_mat_media.Rdata") ## [1] 4,140,572    2,712

## keeping only popular political accounts (5K followers)
## and media outlets / journalists (10K followers)
cs   <- colSums(y)
pols <- which(cs[1:634]>5000) ## 323 politicians
jour <- (635:1481)[which(cs[635:1481]>10000)] ## 580 media outlets
supcol <- (1:dim(y)[[2]])[(1:dim(y)[[2]]) %in% c(pols, jour) == FALSE]

## keeping only users who follow 5+ politicians and 5+ media outlets
rs.pol <- rowSums(y[,pols])
rs.jou <- rowSums(y[,jour])
rs <- rowSums(y[,c(pols, jour)])
sbs <- which(rs.pol>9 & rs.jou>9 & rs<200)

y <- y[sbs,]

y <- as.matrix(y)
res <- ca(y, nd=3, supcol=supcol)

save(res, file="first-stage-all-results_aug.rdata")

# Pols only
# ~~~~~~~~~~~~~~~~~~
## load sparse matrix
load("out/sparse_mat_pol.Rdata") ## [1] 4,140,572    2,712

## keeping only popular political accounts (5K followers)
## and media outlets / journalists (10K followers)
cs   <- colSums(y)
pols <- which(cs[1:634]>5000) ## 323 politicians
supcol <- (1:dim(y)[[2]])[(1:dim(y)[[2]]) %in% pols == FALSE]

## keeping only users who follow 5+ politicians and 5+ media outlets
rs.pol <- rowSums(y[,pols])
rs <- rowSums(y[,c(pols)])
sbs <- which(rs.pol>9 & rs<200)

y <- y[sbs,]

y <- as.matrix(y)
res <- ca(y, nd=3, supcol=supcol)

save(res, file="first-stage-pol-results.rdata")

# Media Only
# ~~~~~~~~~~~~~~~~~~~
## load sparse matrix
load("out/sparse_mat_media.Rdata") ## [1] 4,140,572    2,712
## keeping only popular political accounts (5K followers)
## and media outlets / journalists (10K followers)
cs    <- colSums(y)
jours <- which(cs>5000) ## 323 politicians
supcol <- (1:dim(y)[[2]])[(1:dim(y)[[2]]) %in% c(jours) == FALSE]

## keeping only users who follow 5+ media outlets
rs.jou <- rowSums(y[,jours])
rs <- rowSums(y[,jours])
sbs <- which(rs.jou>5 & rs<200)
y <- y[sbs,]

y <- as.matrix(y)
res <- ca(y, nd=3, supcol=supcol)
save(res, file="tabs/first-stage-media-results.rdata")
