#!/bin/bash

#you may need to change permissions on the shell file (e.g. chmod +x curlREST.sh) to run it (e.g. ./curlREST.sh)

#prompt the user to enter their username or uncomment #username line for testing purposes
read -p "Please enter username (and press ENTER): " username

#prompt the user to enter their password 
read -s -p "Please enter password (and press ENTER): " password

#prompt the user to enter their instance end-point 
echo
read -p "Please enter instance (e.g. na1) for the loginURL (and press ENTER): " instance

#get the oauth2 response and store it (create your own connected app to get a new client id and secret - https://na1.salesforce.com/help/pdfs/en/salesforce_identity_implementation_guide.pdf)
response=`curl https://${instance}.salesforce.com/services/oauth2/token -d "grant_type=password" -d "client_id=3MVG99OxTyEMCQ3hSjz15qIUWtIhsQynMvhMgcxDgAxS0DRiDsDP2ZLTv_ywkjvbAdeanmHWInQ==" -d "client_secret=7383101323593261180" -d "username=${username}" -d "password=${password}"`

#uncomment to check response json
echo "response: {$response}"

#test regular expression for an access token
pattern='"access_token":"([^"]*)"'
if [[ $response =~ $pattern ]]; then
	
	#use some BASH_REMATCH magic to pull the access token substring out and store it - see http://robots.thoughtbot.com/the-unix-shells-humble-if for examples
	access_token="${BASH_REMATCH[1]}"
	
	#uncomment to check token results
	echo "token: ${access_token}"

	#now run whatever REST API query, insert, delete, etc... you want
	curl https://${instance}.salesforce.com/services/data/v29.0/query?q=Select+Id+From+Account+LIMIT+5 -H "Authorization: Bearer ${access_token}" -H "X-PrettyPrint:1" 
else
	#whoops - what happened?
	echo "something went terribly wrong :("
fi
