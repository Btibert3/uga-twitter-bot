###############################################################################
## Use R to connect to Twitter's Firehouse and follow accounts and hashtags
## related to Undergraduate admissions and enrollment management
##dev
###############################################################################

## options
options(stringsAsFactors = F)

## load the packages
library(streamR)
library(twitteR)
library(ROAuth)

## source the credentials
source("R/credentials.R")

# authenticate
# requestURL <- "https://api.twitter.com/oauth/request_token"
# accessURL <- "https://api.twitter.com/oauth/access_token"
# authURL <- "https://api.twitter.com/oauth/authorize"
# my_oauth <- OAuthFactory$new(consumerKey = consumer_key, consumerSecret = consumer_secret, 
#                              requestURL = requestURL, accessURL = accessURL, authURL = authURL)
# my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
# saveRDS(my_oauth, file = "data/my_oauth.rds")

## bring in the data
BASE_DIR = "tweets"
BASE_NAME = "uga_"
SUFFIX = ".json"
oauth_key = readRDS("data/my_oauth.rds")
tags = readRDS("data/tags.rds")
ids = readRDS("data/ids.rds")
TIMEOUT= 60*5  


## repeat the loop
while (TRUE) {
  ## connect to the twitter API with twitteR package
  setup_twitter_oauth(consumer_key = consumer_key, 
                      consumer_secret = consumer_secret, 
                      access_token = access_token, 
                      access_secret = access_token_secret)
  
  ## print a message to jonsmith_3
  twt_message = paste0("Reconnecting at ", Sys.time())
  updateStatus(twt_message)
  
  ## filter the stream and only write a file each time we reconnect
  FNAME = paste0(BASE_DIR, "/", BASE_NAME, format(Sys.time(), "%m-%d-%Y-%H-%M"), SUFFIX)
  filterStream(file.name = FNAME,
               track = tags,
               follow = ids,
               timeout = TIMEOUT,
               oauth = oauth_key)
}


