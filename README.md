#  About


This repo will contain the code that I use to crawl `Twitter` for Undergrad Admissions  (`UGA`) and some admissions related hashtags.

The code borrows from some of my past work, but it heavily relies upon the first github repo below.  The scripts are great and handles error gracefully, unlike my first attempt. Even though the code is in `python`, my aim is to highlight that we can use `R` to do many similar things. 

The key pieces in my workflow are the [streamR](https://github.com/pablobarbera/streamR) and the [twitteR](https://github.com/geoffjentry/twitteR) packages. They provide great tools for interfacing with the API.

When hacking on a new idea, I tend to want to insert `MongoDB`  way too early into my codebase.  While I admit that I am an awful within python, I do believe that writing to disk has a tremendous number of benefits:

1.  You can always ingest the raw files into MongoDB or another storage engine of choice later on.
2.  It allows you to work with raw data from the API.  Raw data are the bees knees.  

In my code, I create a new log file every hour.

Lastly, because I don't want to hardcode the accounts and hashtags that I want to follow, I am keeping this data in a google spreadsheet.  I use the `parse-gspread.r` to grab my spreadsheet, and the `twitteR` package to lookup the account's twitter id necessary when filtering the stream.    


## TODO
- Improve the process for how I lookup and include the accounts/hashtags that are used in the hourly crawler


### References / Help

The repo below is a great example of how to do some really cool things with the Twitter API and network data.  
[This is an awesome repo](https://github.com/alexhanna/hse-twitter)

Use the `gspread` python library to play nice with Google Docs  
[gspread is teh Awesome](https://github.com/burnash/gspread)

[`streamR` package for connecting to the streaming API in R](https://github.com/pablobarbera/streamR)

[`twitteR` for other simple tasks like user lookup](https://github.com/geoffjentry/twitteR)





