.PHONY: help textlint textlint-articles textlint-books textlint-fix preview new-article new-book list check-links

help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

textlint: ## 全てのMarkdownファイルをtextlintでチェック
	npx textlint "articles/**/*.md" "books/**/*.md"

textlint-articles: ## articlesディレクトリのみをtextlintでチェック
	npx textlint "articles/**/*.md"

textlint-books: ## booksディレクトリのみをtextlintでチェック
	npx textlint "books/**/*.md"

textlint-fix: ## textlintで自動修正可能な問題を修正
	npx textlint --fix "articles/**/*.md" "books/**/*.md"

preview: ## Zennコンテンツをブラウザでプレビュー
	npx zenn preview

new-article: ## 新しい記事を作成
	npx zenn new:article

new-book: ## 新しい本を作成
	npx zenn new:book

list: ## 記事と本の一覧を表示
	@echo "📚 Articles:"
	@npx zenn list:articles
	@echo "\n📖 Books:"
	@npx zenn list:books

check-links: ## Markdownファイル内のリンクをチェック
	npx markdown-link-check articles/*.md
