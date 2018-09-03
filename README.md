# SSH Control
A basic on/off switch for the SSH server, when running under systemd.

# Installation
Use it under [`bashctl`](https://github.com/musicmrman99/bashctl "bashctl on GitHub"):
```sh
git clone https://github.com/musicmrman99/ssh-control "$BASH_LIB_COMPONENT_ROOT"/ssh-control
bashctl --update-symlinks
```

Create a launcher for it on one of your XFCE panels, either manually, or by running:
```
xfce4-panel --add=launcher
```
Click on the 'add new empty item' button, then 'cancel' and 'close'. That will create the needed directory. Finally, execute the following to set it up:
```sh
panel_config_dir="$HOME"/.config/xfce4/panel
launcher_dirname=$(ls -1v "$panel_config_dir" | grep "launcher-*" | tail -n 1)
ln -s "$BASH_LIB_ROOT"/ssh-control/data/toggle.desktop "$panel_config_dir/$launcher_dirname"/toggle.desktop
```

To make it take effect, either reboot, login/logout, or make it show immediately by restarting your xfce4-panel:
```
xfce4-panel --restart
```
