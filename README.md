# ghcloneorg
Clone All repos in a github organization

Add in .ghcloneorg.sh.rc 
1. Your organization (ORG)
2. Your Persnal Access Token from a github org administrator. The PAT should have repo.* and list repos rights.

Run `ghcloneorg.sh` 

It will create a dir with your org name in the current dir and clone or pull any existing repos.

Requires:
```
curl
jq
```
