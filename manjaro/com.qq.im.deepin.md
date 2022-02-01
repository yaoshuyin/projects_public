```bash
＃安装QQ
$ yay -S com.qq.im.deepin

＃解决汉字输入法无法调用问题
$ sudo vim /opt/apps/com.qq.im.deepin/files/run.sh
export GTK_IM_MODULE=fcitx 
export QT_IM_MODULE=fcitx 
export XMODIFIERS="@im=fcitx"

#解决汉字显示方块问题
$ sudo cp /run/media/tom/sata/simsun.tt* /home/tom/.deepinwine/Deepin-QQ/drive_c/windows/Fonts/
```
