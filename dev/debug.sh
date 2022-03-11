# Setup git repo
git remote add origin git@github.com:laseryuan/new-app
git push --set-upstream origin master

# Test connection
curl -i ifconfig.me
curl -i http://localhost

# Mount docker volume
sudo vim /etc/fuse.conf # uncomment user_allow_other in /etc/fuse.conf

sshfs
sshfs -o allow_other ${DEV_SERVER}:${WORK_SPACE} ~/projects/sshfs

fusermount -u ~/projects/sshfs

# Access host from container
  --add-host "docker0:$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')" \

ping docker0

# Use this project with github action
```
cd .tmp
ssh -T git@github.com
mkdir -p .dotfiles/home/.kr
vi .dotfiles/home/.kr/pairing.json
killall ssh
```

