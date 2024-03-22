# Futur-Tech Docker RustDesk Server

Make sure the following port are open:
- TCP 21115-21117
- UDP 21116

## Deploy Commands

Everything is executed by only a few basic deploy scripts. 

```bash
cd /usr/local/src
git clone git@github.com:Futur-Tech/futur-tech-rustdesk-server.git
cd futur-tech-rustdesk-server

./deploy.sh 
# Main deploy script

./deploy-update.sh -b main
# This script will automatically pull the latest version of the branch ("main" in the example) and relaunch itself if a new version is found. Then it will run deploy.sh. Also note that any additional arguments given to this script will be passed to the deploy.sh script.
```

## Sources
https://rustdesk.com/docs/en/self-host/
https://github.com/rustdesk/rustdesk-server