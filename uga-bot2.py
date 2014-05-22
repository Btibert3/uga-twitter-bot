## help from http://www.pythoncentral.io/introduction-to-tweepy-twitter-for-python/
import tweepy
from pymongo import MongoClient
import gspread

## Twitter API settings
consumer_key        = "y1332BV0buDBL0INYmxhFg"
consumer_secret     = "mm71csN2vNwiJ6y4vBzLQP4VAqVwNztK8IicqCxg"
access_token        = "434366755-pPYeUVVtp9hrd5Iluu8OlXTmG6h1AsneTe9RXsok"
access_token_secret = "AFVsZezhTNcjN0ZdydWDp5PKTHJtLAbLFyaKkfQSxE0"

## OAuth process, using the keys and tokens
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
 
## Creation of the actual interface, using authentication
# api = tweepy.API(auth)
api = tweepy.API(auth_handler=auth, parser=RawJsonParser())

# Google spreadsheet settings
gmail_email         = "btibert3@gmail.com"
gmail_pass          = "google278133"
SHEETNAME           = "UGA Twitter Bot Accounts"

## connect to the local mongodb instance
mongo = MongoClient()
db = mongo.ugabot


## the class
class StdOutListener(tweepy.StreamListener):
    ''' Handles data received from the stream. '''
 
    def on_status(self, status):
    	# db.tweets.insert(status)
        tmp = status.parse()
        print type(tmp)
        return True
 
    def on_error(self, status_code):
        print('Got an error with status code: ' + str(status_code))
        return True # To continue listening
 
    def on_timeout(self):
        print('Timeout...')
        return True # To continue listening




if __name__ == '__main__':
    ## get the accounts
    ## log into gmail to get my spreadhseet using gspread
    gc = gspread.login(gmail_email, gmail_pass)
    sheet = gc.open(SHEETNAME).sheet1
    tmp = sheet.col_values(3)[1:]
    to_follow = [tmp for tmp in tmp if tmp is not None]

    ## get the tags
    sh = gc.open(SHEETNAME)
    worksheet = sh.get_worksheet(1) ## 0 index, get the second workbook
    to_track = worksheet.col_values(1)[1:]

    ## convert the to_follow to Twitter ids
    to_follow_ids = []
    for acct in to_follow:
        tmp = api.get_user(acct)
        to_follow_ids.append(tmp.id)

    ## initalize the listener
    listener=StdOutListener()
    auth=tweepy.OAuthHandler(consumer_key,consumer_secret)
    auth.set_access_token(access_token,access_token_secret)
    
    ## get the stream
    stream=tweepy.Stream(auth,listener)
    #stream.filter(follow=to_follow, track=to_track)
    stream.filter(follow = to_follow_ids, track = to_track)
