#!/bin/bash

# 启动Clash for Windows
exec /bin/bash ./start_cfw.sh &

# 启动输入法
exec fcitx5 &

# 启动dwm状态显示脚本
exec /bin/bash ./dwm_status.sh &

# 启动picom
exec picom --config ~/.config/picom.conf &

# set wallpaper
exec /bin/bash ./set_wallpaper.sh &

# 启动flameshot
exec flameshot &

