"

02-get-twitter-data.R 
Purpose: download list of Twitter followers of politicians from Twitter API
Details: follower lists are stored in 'outfolder' as .Rdata files

Gaurav Sood and Philip Habel

Source: pabs
"

# setdir
setwd(googledrivedir)

# looad lib 
library(tweetscores)

# open list of political elites from paper
load("uk_media_ideology/data/twitter/elites-data.Rdata")

# to download lists of followers in other countries, run script changing
# name of country when subsetting the list, e.g.:
outfolder <- 'uk_media_ideology/data/twitter/followers-list/'
uk <- elites.data[['UK']]
uk <- uk[uk$followers_count>2000,]

# first check if there's any list of followers already downloaded to 'outfolder'
accounts.done <- gsub(".rdata", "", list.files(outfolder))
accounts.left <- uk$screen_name[tolower(uk$screen_name) %in% tolower(accounts.done) == FALSE]
accounts.left <- accounts.left[!is.na(accounts.left)]

# loop over the rest of accounts, downloading follower lists from API
while (length(accounts.left) > 0){

    # sample randomly one account to get followers
    new.user <- sample(accounts.left, 1)
    cat(new.user, " -- ", length(accounts.left), " accounts left!\n")   
    
    # download followers (with some exception handling...) 
    error <- tryCatch(followers <- getFollowers(screen_name=new.user,
        oauth_folder="uk_media_ideology/scripts/twitter/oauth"), error=function(e) e)
    

    if (inherits(error, 'error')) {
        cat("Error! On to the next one...")
        Sys.sleep(3000)
        next
    }
    
    # save to file and remove from lists of "accounts.left"
    file.name <- paste0(outfolder, new.user, ".rdata")
    save(followers, file=file.name)
    accounts.left <- accounts.left[-which(accounts.left %in% new.user)]

}


handles <- read.csv("uk_media_ideology/data/twitter/unique_twitter_handles.csv")
