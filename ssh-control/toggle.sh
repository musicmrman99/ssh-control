#!/bin/bash

ssh_control_dir="$BASH_LIB_ROOT"/ssh-control
ssh_control_data_dir="$ssh_control_dir"/data
xfce4_launcher_symlink="$(find "$HOME"/.config/xfce4/panel/* -name 'toggle.desktop')"
xfce4_launcher_dir="$(dirname "$xfce4_launcher_symlink")"

if [ "$(printf '%s' "$xfce4_launcher_dir" | wc -l)" -gt 1 ]; then
	notify-send "\`systemctl status ssh\` returned error: $status_ret"
	exit 1
fi

function update-icon {
	local new_icon="$1"
	sed -i -e 's/^\(Icon=.*\/\).*$/\1'"$new_icon"'/' "$ssh_control_data_dir"/toggle.desktop

	rm "$xfce4_launcher_dir"/toggle.desktop
	ln -s "$ssh_control_data_dir"/toggle.desktop "$xfce4_launcher_dir"/toggle.desktop
}

systemctl status ssh > /dev/null
status_ret=$?

if [ $status_ret = 0 ]; then
	gksudo systemctl stop ssh
	stop_ret=$?

	if [ $stop_ret != 0 ]; then
		notify-send "\`systemctl stop ssh\` returned error: $stop_ret"
		exit 1
	else
		new_icon='inactive.png'
		update-icon "$new_icon"
		notify-send --icon "$ssh_control_data_dir"/"$new_icon" 'SSH Service - Disabled'
	fi
elif [ $status_ret = 3 ]; then
	gksudo systemctl start ssh
	start_ret=$?

	if [ $start_ret != 0 ]; then
		notify-send "\`systemctl start ssh\` returned error: $start_ret"
		exit 1
	else
		new_icon='active.png'
		update-icon "$new_icon"
		notify-send --icon "$ssh_control_data_dir"/"$new_icon" 'SSH Service - Enabled'
	fi
else
	notify-send "\`systemctl status ssh\` returned error: $status_ret"
	exit 1
fi
