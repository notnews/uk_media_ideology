"
Tweety Handles
Gaurav Sood and Philip Habel
"

setwd(googledrivedir)

hirst1 <- read.csv("uk_media_ideology/data/twitter/hirst1.csv")
hirst2 <- read.csv("uk_media_ideology/data/twitter/hirst2.csv")
hirst3 <- read.csv("uk_media_ideology/data/twitter/hirst3.csv")

# nrow(tweet_handles)
# [1] 3013

# length(unique(tweet_handles$twitter_id))
# [1] 1113

tweet_handles <- rbind(hirst1, hirst2, hirst3)
tweet_handles <- subset(tweet_handles, !duplicated(tweet_handles$twitter_id))

write.csv(tweet_handles, file="uk_media_ideology/data/tweet_handles/unique_twitter_handles.csv", row.names=F)

# Get MP handles
# Here: https://twitter.com/tweetminster/lists/ukmps
library(jsonline)
uk_mps <- stream_in(file("uk_media_ideology/data/twitter/uk_mps.json"))

uk_mps_dat <- uk_mps[[1]][[1]][1:7]

write.csv(uk_mps_dat, file="uk_media_ideology/data/twitter/uk_mps.csv", row.names=F)

