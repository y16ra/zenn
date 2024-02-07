---
title: "Firebase HostingでデプロイしたサイトにBasic認証をかける"
emoji: "🔥"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ['firebase', 'firebase-hosting', 'basic-auth', 'nodejs']
published: true
---

# はじめに

この記事では以下のクラスメソッドさんのブログ記事を参考して作業を進めていたら非推奨になっていた部分があったのでその部分を修正した内容を記載します。

https://dev.classmethod.jp/articles/openapi-firebase-hosting/

# Basic認証をかける

Cloud Functions for FirebaseでBasic認証をかけるのですがパスワードを平文で記載している記事が多くある中でクラスメソッドさんの記事は `functions:config` から取得するようになっていたので「これいいじゃん」と思ったのですが、 `functions:config` に秘匿情報を登録するのは非推奨になっているという記事を見つけてしまいました。

https://zenn.dev/singularity/articles/firebase-functions-environment-variables

そこで、 `functions:config` に登録するのではなく、 `functions.config()` で取得するようにします。

## Basic認証のパスワードをfunctions:secretsで管理する

まずは `functions:secrets` にパスワードを登録します。ここではパスワードを `BASIC_AUTH_PASSWORD` という名前で登録します。

```
$ firebase functions:secrets:set BASIC_AUTH_PASSWORD
```

このコマンドを実行すると値を入力するように求められるのでパスワードを入力します。

## Basic認証のパスワードを取得する

次に上記で登録したパスワードを使ってBasic認証をかけるようにします。

```
const functions = require('firebase-functions')
const express = require('express')
const basicAuth = require('basic-auth-connect')

const app = express()

app.all('/*', basicAuth(function(user, password) {
  return user === 'hoge-user' && password === process.env.BASIC_AUTH_PASSWORD;
}));

app.use(express.static(__dirname + '/static/'))

exports.app = functions.runWith({
  secrets: ['BASIC_AUTH_PASSWORD'],
}).https.onRequest(app)
```

runWithで先ほど登録した `BASIC_AUTH_PASSWORD` を指定すると環境変数として利用できるようになります。

# おわりに

これだけのことですがこの書き方でBasic認証のやり方を解説している記事が出てこなかったので書いてみました。
