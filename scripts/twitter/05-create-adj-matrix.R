"
Purpose: Create Adj Matrix
Gaurav Sood and Philip Habel

Where?: In the Clouds
"

# set basedir
setwd(basedir)

# Load libs 
library(readr)
library(Matrix)


# Load politician file
pol        <- read.table("pnet.csv", sep="\t", header=FALSE, stringsAsFactors = FALSE)
names(pol) <- c("name", "followers")

# Load media file
jour        <- read.table("FollowerNetworkAug2016.csv", sep="\t", header=FALSE, stringsAsFactors = FALSE)
names(jour) <- c("name", "followers")

poljour <- rbind(pol, jour)

# List of users meeting the criterion
userlist <- read_csv("followers.csv")
n <- nrow(userlist)

# Iterating
m <- nrow(poljour)
rows <- list()
columns <- list()

for (j in 1:m) {
	followers <- unlist(strsplit(poljour[j,2], ","))
	to_add    <- which(userlist$User_ID %in% followers)
	rows[[j]] <- to_add
    columns[[j]] <- rep(j, length(to_add))
}

rows    <- unlist(rows)
columns <- unlist(columns)

# preparing sparse Matrix
y <- sparseMatrix(i=rows, j=columns)
rownames(y) <- userlist$User_ID
colnames(y) <- poljour$name

save(y, file="sparse_mat_all_aug.Rdata")
