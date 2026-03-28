---
name: zenn-new-article
description: このリポジトリで Zenn の新規記事を書き始めるときの手順。ユーザーが「新しい記事」「記事を書き始める」「Zenn 記事を作る」「new article」などと言ったとき、またはシリーズの続編を始めるときに読む。記事ファイルの作り方・フロントマター・既存記事との体裁合わせ・textlint までを一貫して案内する。
version: 1.0.0
---

# Zenn 新規記事を書き始める

## 記事ファイルを作る

- リポジトリ直下で実行する: `npx zenn new:article`
- 代替: `make new-article`（Makefile 経由でも可）
- **ファイル名**: 生成された `articles/<ハッシュ>.md` をそのまま使う。他記事（例: `f34b4fd13c30a8.md`）と揃える。カスタム `--slug` は、意図的に URL を固定したい場合のみ。

## フロントマター

`CLAUDE.md` の Article Format に合わせる。

- `title`: 記事タイトル（引用符で囲む）
- `emoji`: 1 文字の絵文字
- `type`: `tech`（技術）または `idea`（随想・学習メモなど）
- `topics`: 英小文字のタグ配列（例: `aws`, `資格`, `aifc01`）
- `published`: 下書きなら `false`。公開時に `true` と `published_at`（JST・任意）を設定

## 本文の始め方

- 本文の見出しは `##` から（`#` は使わない）
- **シリーズの続き**なら「はじめに」で親記事へリンクする（例: `[タイトル](/articles/<slug>)`）。slug はファイル名から `.md` を除いたもの
- 記法・メッセージブロック・mermaid などは、同リポジトリの `zenn-markdown` スキル（`.claude/skills/zenn-markdown/SKILL.md`）を参照する

## 執筆中のルール

- 日本語は **です／ます** か **である／だ** のどちらかに統一（textlint の `no-mix-dearu-desumasu`）
- 用語が textlint に引っかかるときは `.textlintrc` の allowlist を検討。インライン無効化コメントは最小限
- `:::message` 閉じの `:::` が文末ルールに触れる場合は、該当ブロックだけ `<!-- textlint-disable ja-technical-writing/ja-no-mixed-period -->` で囲むなど、必要最小限で対処

## 保存前の確認

- 編集後は必ず: `npx textlint articles/<ファイル名>.md`
- または: `make textlint-articles`（全体チェック）

## 参照

- リポジトリ運用・CI・コマンド一覧: ルートの `CLAUDE.md`
- Zenn 記法の詳細: `.claude/skills/zenn-markdown/SKILL.md`
