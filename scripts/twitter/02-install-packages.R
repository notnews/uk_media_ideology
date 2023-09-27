"

02-install-packages.R
Purpose: install R packages and provide information about how to create
OAuth token to query Twitter's API

Gaurav Sood and Philip Habel

Source: pabs
"

doInstall <- TRUE  # Change to FALSE if you don't want packages installed.

toInstall <- c(
    "ggplot2", "scales", "gridExtra",  ## gplot2 and extensions
    "streamR", ## library to capture and parse Tweets
    "twitteR", ## library to query Twitter REST API
    "Matrix", ## efficient storage of sparse matrices
    "yaml", ## read yaml files
    "httr", ## http requests
    "reshape2", ## reshape data frames
    "devtools", ## necessary to install smappR package
    "R2WinBUGS" ## used in Metropolis sampler
    )

if(doInstall){
    install.packages(toInstall, repos = "http://cran.r-project.org")
    library(devtools)
    install_github("SMAPPNYU/smappR")
}


### INSTALLING STAN #### 

# For most up-to-date instructions, go to:
# https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started

Sys.setenv(MAKEFLAGS = "-j4") 

install.packages("rstan")

### REGISTERING OAUTH TOKEN ###

## Step 1: go to dev.twitter.com and sign in
## Step 2: click on your username (top-right of screen) and then on "My applications"
## Step 3: click on "Create New App"
## Step 4: fill name, description, and website (it can be anything, even google.com).
##         (Leave callback ULR empty)
## Step 5: Agree to user conditions and enter captcha.
## Step 6: copy consumer key and consumer secret and paste below

library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "MKWFjULQeNMnKpmoFgmEMqw5Z"
consumerSecret <- "F0661XPHf8LmVewHrCZQK9QpaBmFzbmuAraF0qoVBgpoTRYR8i"

my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                         consumerSecret=consumerSecret,
                         requestURL=requestURL,
                         accessURL=accessURL,
                         authURL=authURL)
download.file(url="https://curl.haxx.se/ca/cacert.pem",
          destfile="cacert.pem")
my_oauth$handshake(cainfo="cacert.pem")

## now you can save oauth token for use in future sessions with twitteR or streamR
save(my_oauth, file="uk_media_ideology/scripts/twitter/oauth/my_oauth")