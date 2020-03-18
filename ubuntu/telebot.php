.创建Bot
 在Telegram里面,
  @BotFather 
  发送/newbot, 
  choose a name for your bot: 输入mybotname
  choose a username for you bot: mybotname_bot
  
.GetMyUID:
 在安装有telegram的电脑端的浏览器里打开
 https://telegram.me/userinfobot
 
 结果:
   Id: 5900084
   First: Tom
   Last: Tom
   Lang: zh-CN
 
.创建用户
 useradd -s /bin/bash -d /home/user user 

 mkdir /data/telebot
 chown -R user:user /data/telebot

.install php
  apt install php7.0 php7.0-common php7.0-fpm php7.0-intl php7.0-mysql php7.0-sqlite3 \
      php7.0-bcmath php7.0-curl php7.0-gd php7.0-json php7.0-readline php7.0-zip \
      php7.0-bz2 php7.0-opcache php7.0-cgi php7.0-mbstring php7.0-xml php7.0-cli php7.0-mcrypt  
 
.install composer

 curl -sS https://getcomposer.org/installer | php

.init telebot api
 su - user
 cd /data/telebot
 php composer.phar require irazasyed/telegram-bot-sdk ^2.0
 
 
.创建TeleBot.php
<?php
require __DIR__ . '/vendor/autoload.php';
use Telegram\Bot\Api;

/**
 * @api: https://telegram-bot-sdk.readme.io/reference#getme
 */
class TeleBot {
    private static $token='5183...S6vNY';

    /**
     * @param $cid
     * @param $msg
     */
    public static function Msg($cid,$msg) {
        $telegram = new Api(self::$token);
        $response = $telegram->sendMessage([ 'chat_id'=>$cid, 'text'=>$msg]);
        $messageId = $response->getMessageId();
    }

    /**
      (
           [id] => 59..84
           [first_name] => Tom
           [last_name] => Tom
           [type] => private
      )
      
      (
           [id] => -27..95
           [title] => MyGroup
           [type] => group 
      )
    */
    public static function Info(){
        $telegram = new Api(self::$token);

        $response = $telegram->getUpdates();
        print_r($response);
    }
}

$Users=[
  'MyGroup'=>'-27..',
  'tom'=>'5..4',
  'teem'=>'4..95',
];

TeleBot::Info();
TeleBot::Msg($Users['YunWei'],"hello bot");
TeleBot::Msg($Users['tom'],"hello bot");

.测试
php TeleBot.php