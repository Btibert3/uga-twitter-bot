import json
import pymongo
import tweepy
import datetime
import gspread

## help from 
## http://goo.gl/xt8ng9

# http://www.pythoncentral.io/introduction-to-tweepy-twitter-for-python/
## http://pythonhosted.org/tweepy/html/index.html
# API settings for jonsmith
consumer_key        = ""
consumer_secret     = ""
access_token        = ""
access_token_secret = ""

# OAuth process, using the keys and tokens
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
 
# Creation of the actual interface, using authentication
api = tweepy.API(auth)

# Google spreadsheet settings
gmail_email         = ""
gmail_pass          = ""
SHEETNAME           = ""

## log into gmail to get my spreadhseet using gspread
gc = gspread.login(gmail_email, gmail_pass)

## get the accounts
sheet = gc.open(SHEETNAME).sheet1
tmp = sheet.col_values(3)[1:]
follow = [tmp for tmp in tmp if tmp is not None]

## get the tags
sh = gc.open(SHEETNAME)
worksheet = sh.get_worksheet(1) ## 0 index, get the second workbook
track = worksheet.col_values(1)[1:]


class CustomStreamListener(tweepy.StreamListener):
    def __init__(self, api):
        self.api = api
        super(tweepy.StreamListener, self).__init__()

        # connect to mongodb at the localhost
        self.db = pymongo.MongoClient().ugabot

        # print a reconnect message
        time_string = datetime.datetime.now().isoformat()
        twt_status = "Reconnected at " + time_string
        api.update_status(twt_status)

    def on_data(self, tweet):
        self.db.tweets.insert(json.loads(tweet))

    def on_error(self, status_code):
        return True # Don't kill the stream

    def on_timeout(self):
        return True # Don't kill the stream



## print the follows and trackings
print "following accounts : "
for f in follow:
    print f
    print "\n"

print "following hashtags : "
for t in track:
    print t
    print "\n"


## crawl the data
print "Starting crawler .......\n"
sapi = tweepy.streaming.Stream(auth, CustomStreamListener(api))
sapi.filter(follow=follow,  track=track)