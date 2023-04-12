# dwm - dynamic window manager

dwm is an extremely fast, small, and dynamic window manager for X.

- [dwm - dynamic window manager](#dwm---dynamic-window-manager)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Running dwm](#running-dwm)
  - [Configuration](#configuration)
  - [建议的安装步骤](#建议的安装步骤)
    - [0. 下载源代码](#0-下载源代码)
    - [1. 安装基础依赖](#1-安装基础依赖)
    - [2. 为X11安装一个compositor](#2-为x11安装一个compositor)
    - [3. 安装桌面背景图片设置工具](#3-安装桌面背景图片设置工具)
    - [4. 安装电源监控工具](#4-安装电源监控工具)
    - [5. 安装背光灯调整工具](#5-安装背光灯调整工具)
    - [6. 安装字体](#6-安装字体)
    - [7. 安装dmenu](#7-安装dmenu)
    - [8. 编译和安装dwm st](#8-编译和安装dwm-st)
    - [9. 设置DWM启动方式](#9-设置dwm启动方式)
  - [重要快捷键](#重要快捷键)


## Requirements

In order to build dwm you need the Xlib header files.


## Installation

Edit config.mk to match your local setup (dwm is installed into
the /usr/local namespace by default).

Afterwards enter the following command to build and install dwm (if
necessary as root):

```
make clean install
```

## Running dwm

Add the following line to your .xinitrc to start dwm using startx:

```
exec dwm
```

In order to connect dwm to a specific display, make sure that
the DISPLAY environment variable is set correctly, e.g.:

```
DISPLAY=foo.bar:1 exec dwm
```

(This will start dwm on display :1 of the host foo.bar.)

In order to display status info in the bar, you can do something
like this in your .xinitrc:

```
while xsetroot -name "`date` `uptime | sed 's/.*,//'`"
do
	sleep 1
done &
exec dwm
```

## Configuration

The configuration of dwm is done by creating a custom config.h
and (re)compiling the source code.



## 建议的安装步骤

### 0. 下载源代码

将st dwm dwm-scripts放置到~/Program目录下。(若目录不同请注意修改脚本和源代码中的路径)

### 1. 安装基础依赖

```bash
$ sudo apt-get install suckless-tools libx11-dev libxft-dev libxinerama-dev gcc make
```

### 2. 为X11安装一个compositor

```bash
$ sudo apt install compton
```

### 3. 安装桌面背景图片设置工具

```bash
$ sudo apt install feh
```

### 4. 安装电源监控工具

```bash
$ sudo apt install acpi acpitool
```

### 5. 安装背光灯调整工具

```bash
$ sudo apt install light
```

> 注意：  
> 在执行light指令时可能需要root权限，这导致`scripts/light_up.sh`和`scripts/light_down.sh`无法正常执行。
>
> 解决方法：  
> `$ sudo chmod +s /usr/bin/light`  
> [参考链接](https://bbs.archlinux.org/viewtopic.php?id=254203)

### 6. 安装字体

https://github.com/eosrei/twemoji-color-font 安装以修复st的emoji显示问题

https://github.com/ryanoasis/nerd-fonts Install FiraCode and Hack series font.

`sudo apt-get install fonts-symbola` Install Symbola font. Unicode support for st.

`sudo apt-get install fonts-noto-cjk` Install Google Noto CJK font. Chinese support for st. **Attention**: This font should have been installed when config chinese input method for debian.

(Optional) Install IPAGothic font, Japanese support for st.

https://www.nerdfonts.com/cheat-sheet 可以找到一些字体icon

### 7. 安装dmenu

```bash
$ sudo apt install dmenu
```

### 8. 编译和安装dwm st

### 9. 设置DWM启动方式

方式一：使用display manager启动

以ubuntu 20.04为例,ubuntu 20.04使用gdm3做为display manager，配置完成之后可以在登录界面选择dwm作为桌面启动

具体配置方式，进入`/usr/share/xsessions/`目录，新建文件`dwm.desktop`,输入内容：

```
[Desktop Entry]
Encoding=UTF-8
Name=DWM
Comment=Dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession
```

方式二：使用startx命令从文字界面启动

此方式开机更加快速，使用更加灵活，系统资源占用更少。

首先将系统改为默认进入文字界面

修改grub配置,打开文件`/etc/default/grub`,将`GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`的改为`GRUB_CMDLINE_LINUX_DEFAULT="text"`然后执行命令

```
$ sudo update-grub
```

将启动等级改为多用户等级，执行如下命令：


```
$ systemctl set-default multi-user.target 
// 如果想改回启动图形界面执行下面
$ systemctl set-default graphical.target
```

最后修改`~/.xsession`文件（如果没有就新建），在最后一行加入

```
exec dwm
```

重启电脑，执行`startx`命令，直接进入dwm，同时也可以执行`sudo systemctl start gdm.service`命令，打开gdm3的用户登录界面。


> 注意事项：
>
> 1. DWM的MODKEY为Super键
> 2. 启动google-chrome时如果无法加载密码，请使用`google-chrome --password-store=gnome &`命令进行启动

## 重要快捷键

> 当前配置文件的`Modkey`设置为`Windows`键。

|快捷键|作用|
|:---:|:---:|
| `Windows + 鼠标左键` | 移动窗口 |
| `Windows + 鼠标右键` | 放缩窗口 |
| `Windows + Shift + Enter` | 创建新终端 |
| `Windows + Shift + c` | 关闭当前窗口 |
| `Windows + Shift + q` | 关闭dwm |
| `Windows + p` | 打开`dmenu` |
| `` Windows + ` `` | 打开一个`scratch terminal` |
| `Windows + number` | 切换到第number个标签页 |
| `Windows + Shift + number` | 将当前窗口移动到第number个标签页 |
| `Windows + i` | increase the amount of windows in the master area |
| `Windows + d` | decrease the amount of windows in the master area |
| `Windows + Enter` | toggle a window between the master and stack area |
| `Windows + t` | change layout to tiled layout mode |
| `Windows + f` | change layout to floating layout mode |
| `Windows + m` | change layout to monocle layout mode |
| `Windows + F1` | vol toggle |
| `Windows + F2` | vol down |
| `Windows + F3` | vol up |
| `Windows + F11` | light down |
| `Windows + F12` | light up |

