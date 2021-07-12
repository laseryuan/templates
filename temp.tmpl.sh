Setup git repo
```
git remote add origin git@github.com:laseryuan/new-app
```
git push --set-upstream origin master
# mount local project directory to remote (optional)
Local
```
-R 12322:localhost:22
```

Remote
```
WORK_SPACE=\
projects/docker-apps/app

DEV_SERVER=\
"-p 12322 laser@localhost"

ssh ${DEV_SERVER} ls ~laser/${WORK_SPACE}

cd ~/projects/sshfs
ll
```

Mount docker volume
```
sudo vim /etc/fuse.conf # uncomment user_allow_other in /etc/fuse.conf
```

sshfs
```
sshfs -o allow_other ${DEV_SERVER}:${WORK_SPACE} ~/projects/sshfs

fusermount -u ~/projects/sshfs
```

# SSH Agent
```
  -v $SSH_AUTH_SOCK:/ssh-agent \
  -e SSH_AUTH_SOCK=/ssh-agent \

  -v $SSH_AUTH_SOCK:/home/ride/.gnupg/S.gpg-agent.ssh \
```

# Access host from container
```
  --add-host "docker0:$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')" \

ping docker0
```
