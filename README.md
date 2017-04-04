# 奈良市版保育園マップについて

Code for Sapporo の開発したさっぽろ保育園マップを奈良市にも作ろう！ ということで開発しました。

奈良市版は、さっぽろ保育園マップをベースに作られたオープンガバメント推進協議会版からCode for Chiba が作成し機能拡張した千葉市版をベースにしています。

さっぽろ保育園マップについては、こちら。

- http://papamama.codeforsapporo.org/


ちば保育園マップはこちら

- http://papamama.code4chiba.org/


## 利用している地図について

地理院地図で提供している地理院タイルの地図情報を利用しています。

- http://portal.cyberjapan.jp/help/development/ichiran.html

OpenStreetMap JAPAN の地図タイルも利用しています。

- https://openstreetmap.jp/


## 保育園マップで使われるデータについて

奈良市が公開している保育所データ、および、国土数値情報ダウンロードサービスから入手できる学校、鉄道駅および福祉施設情報を元に作成し利用しています。

- http://nlftp.mlit.go.jp/ksj/index.html

これらは公開された時点の、現在の最新情報ではありません。


## データ更新環境

bash（スクリプト）、 iconv（データ変換）、Node.js 及び gulp を利用します。

### bash 及び iconv

Linux環境が前提です。yum / apt 等の管理ツールでインストールしてください。

### Node.js & gulp が使用できる場合

gulp が使用できる場合は、次のコマンドで環境構築が完了します。

    $ git clone https://github.com/codeforchiba/papamama.git
    $ cd papamama
    $ npm install
    $ gulp serve

### Node.js & gulp が使用出来ない場合

gulp が使用出来ない場合は、 Node.js 及び gulp をインストールします。Node.js のインストールについては、こちらをご覧ください。

- https://nodejs.org/ja/
- https://nodejs.org/ja/download/package-manager/

Node.js の実行環境をインストールした後、gulp をインストールします。

    $ npm install -g gulp-cli

権限がないというエラーがでた場合は、sudo 等で対応してください。

    $ sudo npm install -g gulp-cli

## アプリケーションに必要なデータの作成方法

国土数値情報ダウンロードサービスから、該当する市町村の以下のデータを取得してください。

- 小学校区
- 中学校区
- 学校
- 鉄道
- 福祉施設

ダウンロードしてきたら zip ファイルを展開して、data_org ディレクトリにshp ファイルと dbf ファイルを配置します。

次に奈良市のオープンデータカタログから保育所データ（csv）をダウンロードし、data_org/hoiku.csv として保存します。

## データ変換の実行

以下のコマンドを実行することで data ディレクトリに geojson データが生成されます。

    $ bash ./mk_newdata.sh

## ライセンスについて

このソフトウェアは、MITライセンスでのもとで公開されています。[こちら](LICENSE.txt) をご覧ください。

