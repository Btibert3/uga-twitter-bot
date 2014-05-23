###############################################################################
## Quick script to read in google spreadsheet and convert screennames to ids
## using the twitter api and the twitteR package
###############################################################################

## options
options(stringsAsFactors=F)

## load the packages
library(twitteR)
library(mosaic)
library(stringr)

## twitter api info for jonsmith_3
consumer_key        = "y1332BV0buDBL0INYmxhFg"
consumer_secret     = "mm71csN2vNwiJ6y4vBzLQP4VAqVwNztK8IicqCxg"
access_token        = "434366755-pPYeUVVtp9hrd5Iluu8OlXTmG6h1AsneTe9RXsok"
access_token_secret = "AFVsZezhTNcjN0ZdydWDp5PKTHJtLAbLFyaKkfQSxE0"

## set the KEY for our Google Spreadsheet that acts like an easy dataset
KEY = "1dtNZ7B4LqxDKU3YzNymN3dYet8ahwMndwupzdezBSLw"

###############################################################################
## Get the google spreadsheet with the hashtags to follow
###############################################################################

## reads in the first sheet
URL = sprintf("https://docs.google.com/spreadsheets/d/%s/export?format=csv&id=%s&gid=1479530650", KEY, KEY)
## the key above is the &gid= value
gspread = fetchGoogle(URL)

## hashtags
tags = gspread[,1]


###############################################################################
## Get the google spreadsheet with the accounts to follow
###############################################################################



## reads in the first sheet
URL = sprintf("https://docs.google.com/spreadsheets/d/%s/export?format=csv&id=%s&gid=0", KEY, KEY)
## the key above is the &gid= value
gspread = fetchGoogle(URL)


###############################################################################
## for each twitter account, get the twitter id
## https://github.com/geoffjentry/twitteR
###############################################################################


## sign into twitter
setup_twitter_oauth(consumer_key = consumer_key, 
                    consumer_secret = consumer_secret, 
                    access_token = access_token, 
                    access_secret = access_token_secret)


## set the placeholder data frame
ROWS = nrow(gspread)
twitter_ids = data.frame(handle = rep(NA, ROWS),
                         id = rep(NA, ROWS))

for (i in 1:nrow(gspread)) {
  cat("starting row ", i, "\n")
  # load the row we want
  tmp = gspread[i,]
  ## if no twitter account, assign the value of null
  if (str_length(tmp$UGA.Twitter.Handle)==0) {
    twitter_ids$handle[i] = tmp$UGA.Twitter.Handle
    twitter_ids$id[i] = NA
    next
  } #endif
  ## if twitter account look it up using twitteR to acess the API
  user = getUser(tmp$UGA.Twitter.Handle)
  twitter_ids$handle[i] = user$screenName
  twitter_ids$id[i] = user$id
  cat("finished row ", i, "\n")
} #endfor
rm(tmp, user)
twitter_ids = subset(twitter_ids, !is.na(id))

## write out both the R data and csv file
save(twitter_ids, tags, file="data/uga-twitter-tracking.Rdata")
ids = twitter_ids$id
saveRDS(ids, file="data/ids.rds")
saveRDS(tags, file="data/tags.rds")
