curlREST
========

##Introduction

This repo contains a bash shell script example (Mac OSX tested) for using curl and the REST API to access salesforce.com data. I use this shell as a template for automating repetitive administrative tasks that are too inefficient in a user interface. 

##Setup

1. Download the .sh to your local machine. You can save it anywhere but I recommend saving it in your bash directory (e.g. /bin/bash) so you can simplify running the script.
2. Change the permissions on the shell file (e.g. chmod +x curlREST.sh)
3. Open your terminal app and navigate to the folder where you saved the shell script (e.g. cd ~/Desktop)
4. To run the script, type './curlREST.sh' if the script is anywhere other than your bash directory (e.g. /bin/bash) and if it is in your bash directory, just type 'curlREST.sh'
5. Enter your username
6. Enter your password 
7. Enter your server instance (e.g. na1)
8. If successful, you should get the results from a query of your accounts

![screenshot](https://raw.githubusercontent.com/atorman/curlREST/master/terminalExample.png)

##Important Parts

The script is commented, but the key aspects are described below.

Get the oauth2 response and store it (create your own [connected app](http://help.salesforce.com/apex/HTViewHelpDoc?id=connected_app_create.htm&language=en_US "Creating a Connected App help topic") to get a new client id and secret)

    response=`curl https://${instance}.salesforce.com/services/oauth2/token -d "grant_type=password" -d "client_id=3MVG99OxTyEMCQ3hSjz15qIUWtIhsQynMvhMgcxDgAxS0DRiDsDP2ZLTv_ywkjvbAdeanmHWInQ==" -d "client_secret=7383101323593261180" -d "username=${username}" -d "password=${password}"`

Use some BASH_REMATCH magic to pull the access token substring out and store it. [For more examples on BASH_REMATCH and testing RegEx in bash](http://robots.thoughtbot.com/the-unix-shells-humble-if "Unix Shells Humble If")
    
    if [[ "$response" =~ (\"access_token\"):\"(.+)\" ]]; then
		access_token="${BASH_REMATCH[2]}"

Substitute your own REST API calls for this simple Account query

    curl https://${instance}.salesforce.com/services/data/v29.0/query?q=Select+Id+From+Account+LIMIT+5 -H "Authorization: Bearer ${access_token}" -H "X-PrettyPrint:1" 

