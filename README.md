# Questions:
- Why didnt the pymongo instance fire on tweets?
- Is there a more transparent way to write data with both `follow` and `track` set?
- Key is catching errors

# New Workflow

1.  use tweepy error catching code
2.  insert code that brings in google spreadhseet data
3.  add code that on restart (or XX tweets), re-grabs data from google
4.  Throw data into mongodb
5.  Add to github, without credentials

#  About


This repo will contain the code that I use to crawl `Twitter` for Undergrad Admissions  (`UGA`) and some admissions related hashtags.

The code borrows from some of my past work, but it heavily relies upon the first github repo below.  The scripts are great and handles error gracefully, unlike my first attempt.  

When hacking on a new idea, I tend to want to insert `MongoDB`  way too early into my codebase.  While I admit that I am an awful within python, I do believe that writing to disk has a tremendous number of benefits:

1.  You can always ingest the raw files into MongoDB or another storage engine of choice.
2.  It allows you to work with raw data from the API.  Raw data are the bees knees.  

The original code is set to create a new file for every `20000`.  

In my code, I want it to reset every 100.  I might change this later, but I want to ensure that my code is running given that my tracking accounts are low frequency.


Instead of embedding important/secret variables in my code, I am using Environment Variables.  For more on them, [refer to this doc](https://help.ubuntu.com/community/EnvironmentVariables).



I am using a column from a Google Spreadsheet to act as a list of UG twitter accounts.  Everytime my file re-calibrates, I will re-read the list of accounts to follow.  This allows me to add to a publicly available dataset.  While the changes won't impact my script immideately, it's an easy way to "update" a script that is polling the web. 

___[REWORD]___








### References / Help / 

The repo below is a great example of how to do some really cool things with the Twitter API and network data.  
[This is an awesome repo](https://github.com/alexhanna/hse-twitter)

Use the `gspread` python library to play nice with Google Docs  
[gspread is teh Awesome](https://github.com/burnash/gspread)






