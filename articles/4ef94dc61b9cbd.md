---
title: "[作業ログ] 複数バージョンのGoを管理する"
emoji: "🐥"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["go", "mac"]
published: true
---

# はじめに

Go 1.18 がリリースされました。

https://go.dev/blog/go1.18

ジェネリックスやワークスペースなど新しい機能を試してみたいですがバージョンアップして不具合があったりしたら以前のバージョンを利用するにはどうするのが良いのか？
またはデフォルトで利用しているGoのバージョンは変えずに新しいバージョンを利用する方法はあるのかを調べていました。

結論、公式にやり方が書いてあったのでそれを実際にやってみました。
`go install` で今デフォルトで動かしているGoのバージョン以外のGoをインストールして動かせるのですね。
`goenv` というPythonでいうpyenvのようなものもあるようですが更新が止まっているようですし、公式に提供されているものでやるのがよさそうです。

https://go.dev/doc/manage-install

# 他のバージョンのGoをインストール

## Go1.17をインストール

Go 1.17をインストールする場合には以下のようになります。

```
$ go install golang.org/dl/go1.17@latest
go: downloading golang.org/dl v0.0.0-20220315170520-faa7218da89a

$ go1.17 version
go1.17: not downloaded. Run 'go1.17 download' to install to /Users/{username}/sdk/go1.17

$ go1.17 download
Downloaded   0.0% (    16384 / 135938157 bytes) ...
Downloaded  12.7% ( 17268640 / 135938157 bytes) ...
Downloaded  57.4% ( 78020016 / 135938157 bytes) ...
Downloaded 100.0% (135938157 / 135938157 bytes)
Unpacking /Users/{username}/sdk/go1.17/go1.17.darwin-amd64.tar.gz ...
Success. You may now run 'go1.17'

$ go1.17 version
go version go1.17 darwin/amd64
```

インストール可能なバージョンはダウンロードページで確認できます。

https://go.dev/dl/

## Go1.18のインストール

```
$ go install golang.org/dl/go1.18@latest
go: downloading golang.org/dl v0.0.0-20220315170520-faa7218da89a
$ go1.18 version
go1.18: not downloaded. Run 'go1.18 download' to install to /Users/${HOME}/sdk/go1.18
$ go1.18 download
Downloaded   0.0% (    16384 / 137870667 bytes) ...
Downloaded  13.6% ( 18792320 / 137870667 bytes) ...
Downloaded  69.6% ( 95894832 / 137870667 bytes) ...
Downloaded 100.0% (137870667 / 137870667 bytes)
Unpacking /Users/${HOME}/sdk/go1.18/go1.18.darwin-arm64.tar.gz ...
Success. You may now run 'go1.18'
$ go1.18 version
go version go1.18 darwin/arm64
```

これで `$HOME/sdk` にインストールされます。
インストール先は以下のコマンドで確認できます。

```
go1.18 env GOROOT
```

以下のように `GOROOT/bin` にパスを通しておくとバージョン番号無しで `go` コマンドを実行できるようになります。  
必要に応じて設定しておきましょう。

```
# Go
export GOROOT=$(go1.18 env GOROOT)
export PATH=$PATH:$GOROOT/bin
```

これで心置きなくバージョンアップしたりお試しができそうです。
