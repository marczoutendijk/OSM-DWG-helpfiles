#!/bin/zsh

# script to download all changesets of one user since
# a given date (to get ALL, set date to before their signup)
# In this script only the changesetID-URL and the changesetCOMMENT are preserved

# API currently limited to listing max. 100 changesets, 
# therefore loop required

Ucode=70413
SINCE=2022-12-25T01:53:26

# no user servicable parts below. 
# When you run this script you'll end up with file resultlist
# In that file you have for each changeset 2 lines:
# Line 1 with the comment for a given changeset
# Line 2 with the link to that changeset

T=`date -u +%Y-%m-%dT%H:%M:%S`
export T

# get list of all changesets from a given user-id starting at date $SINCE

wget -Olist "https://api.openstreetmap.org/api/0.6/changesets?user=$Ucode&time=$SINCE,$T" 

# Only get the CS id's and put in csid
grep "<changeset" list | cut -d\" -f2 > csid
#prefix with correct url and put in csidlist
nl -s "https://www.openstreetmap.org/changeset/" csid | cut -c7- > csidlist 
# now get the comment and put in cscommentlist
grep "tag k=\"comment\"" list | cut -d\" -f4 > cscommentlist
# combine in resultlist
paste -d '\n' cscommentlist csidlist > resultlist

# cleanup
rm -f list
rm -f csid
rm -f csidlist
rm -f cscommentlist

