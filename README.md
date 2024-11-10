```shell

if [ ! -d '/etc/environment.d' ]; then
  sudo mkdir -vp '/etc/environment.d'
  sudo chmod u=rwx,g=rx,o=rx '/etc/environment.d'
fi

if [ ! -f '/etc/environment.d/90-colors.conf' ] then
  sudo touch '/etc/environment.d/90-colors.conf'
  sudo chmod u=rw,g=r,o=r '/etc/environment.d/90-colors.conf'
fi

if [ ! -f '/etc/environment.d/90-xdg.conf' ] then
  sudo touch '/etc/environment.d/90-xdg.conf'
  sudo chmod u=rw,g=r,o=r '/etc/environment.d/90-xdg.conf'
fi

if [ ! -d '/etc/profile.d' ]; then
  sudo mkdir -vp '/etc/profile.d'
  sudo chmod u=rwx,g=rx,o=rx '/etc/profile.d'
fi

if [ ! -f '/etc/profile.d/90-aliases.sh' ] then
  sudo touch '/etc/profile.d/90-aliases.sh'
  sudo chmod u=rwx,g=rx,o=rx '/etc/profile.d/90-aliases.sh'
fi

if [ ! -f '/etc/profile.d/90-functions.sh' ] then
  sudo touch '/etc/profile.d/90-functions.sh'
  sudo chmod u=rwx,g=rx,o=rx '/etc/profile.d/90-functions.sh'
fi
```
