```bash
＃安装微信（不要安装deepin-wine-wechat，经常崩溃）
$ yay -S com.qq.weixin.deepin

＃解决汉字输入法无法调用问题
$ sudo vim /opt/apps/com.qq.weixin.deepin/files/run.sh
export GTK_IM_MODULE=fcitx 
export QT_IM_MODULE=fcitx 
export XMODIFIERS="@im=fcitx"

#解决汉字显示方块问题
$ sudo cp /run/media/tom/sata/simsun.tt*   ~/.deepinwine/Deepin-WeChat/drive_c/windows/Fonts/
```
