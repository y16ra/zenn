---
title: "Go Docコメントのドキュメントを読んでみる"
emoji: "📝"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [golang]
published: true
---

<!-- https://zenn.dev/zenn/articles/markdown-guide -->

Go1.19のリリースでGo Docの機能にアップデートがあったのでこの機会に読んでみようと思いました。
Go Docに関する変更点に関しては以下のような記載がありました。

> Go 1.19 adds support for links, lists, and clearer headings in doc comments. As part of this change, gofmt now reformats doc comments to make their rendered meaning clearer. See “Go Doc Comments” for syntax details and descriptions of common mistakes now highlighted by gofmt. As another part of this change, the new package go/doc/comment provides parsing and reformatting of doc comments as well as support for rendering them to HTML, Markdown, and text.

https://tip.golang.org/doc/go1.19

それではドキュメントをみていきたいと思います。

# Go Doc Comments

https://tip.golang.org/doc/comment


> “Doc comments” are comments that appear immediately before top-level package, const, func, type, and var declarations with no intervening newlines. Every exported (capitalized) name should have a doc comment.

*"Doc comment" はトップレベルのpackage, const, func, type, varの宣言の直前に改行を入れずに書かれたものです。全ての公開された(大文字の)名前にはdocコメントがあるべきです。*

> The go/doc and go/doc/comment packages provide the ability to extract documentation from Go source code, and a variety of tools make use of this functionality. The go doc command looks up and prints the doc comment for a given package or symbol. (A symbol is a top-level const, func, type, or var.) 

*`go/doc`と`go/doc/comment`パッケージはGoのソースコードからドキュメントを抽出する機能を提供していて、様々なツールがこの機能を利用しています。`go doc`コマンドは指定されたパッケージやシンボルのdocコメントを見つけて表示します。*

> The web server pkg.go.dev shows the documentation for public Go packages (when their licenses permit that use). 

*`pkg.go.dev`サーバーは公開されているGoパッケージのドキュメントを表示します。(使用が許可されている場合)*

> The program serving that site is golang.org/x/pkgsite/cmd/pkgsite, which can also be run locally to view documentation for private modules or without an internet connection. 

*そのサイトを提供しているプログラムは`golang.org/x/pkgsite/cmd/pkgsite`で、プライベートなモジュールのドキュメントを見るためや、インターネット接続無しで見るためにローカルで起動することもできます。*

> The language server gopls[^1] provides documentation when editing Go source files in IDEs.

*goplsはIDEでGoのソースファイルを編集している時にドキュメントを提供します。*

> The rest of this page documents how to write Go doc comments.

*ここからはGo Docコメントの書き方をみていきます。*

[^1]: gopls (pronounced "Go please") ということでゴープリーズって読むんですね。

## Packages

> Every package should have a package comment introducing the package. It provides information relevant to the package as a whole and generally sets expectations for the package. Especially in large packages, it can be helpful for the package comment to give a brief overview of the most important parts of the API, linking to other doc comments as needed.

*すべてのパッケージには、そのパッケージを紹介するパッケージコメントが必要です。パッケージ全体に関連する情報を提供し、全体的にそのパッケージに対して期待できることを示します。*

このページの説明では複数行のコメントアウトをする `/* ~~~ */` ではなく１行コメントのスタイルで例が書かれていました。

```
// Package path implements utility routines for manipulating slash-separated
// paths.
//
// The path package should only be used for paths separated by forward
// slashes, such as the paths in URLs. This package does not deal with
// Windows paths with drive letters or backslashes; to manipulate
// operating system paths, use the [path/filepath] package.
package path
```

> The square brackets in [path/filepath] create a documentation link.

*角括弧(square brackets)でリンクを作成できます。*

この特定のワードにリンクを付ける記述は1.19からサポートされたやつかな？

> As can be seen in this example, Go doc comments use complete sentences. For a package comment, that means the first sentence begins with “Package ”.

*パッケージのコメントでは、最初の文が "Package "で始まっています。*

> For multi-file packages, the package comment should only be in one source file. If multiple files have package comments, they are concatenated to form one large comment for the entire package.

*複数ファイルあるパッケージでは、１つのファイルにパッケージコメントが記載されるべきです。もし複数のファイルにパッケージコメントがあったら、それらは連結されてパッケージ全体に対するコメントになります。*

これをみて実際にパッケージコメントってパッケージ内に複数のファイルがある場合はどのファイルに書くとかどう決めて実装されているのか？疑問に思って標準パッケージなどが実際にどうやっているのか調べてみたところ`doc.go`というファイルを作ってパッケージ名とパッケージコメントだけが書かれているのを見つけました。もう一つのパターンは、パッケージ名と同名のファイルに記載されているものもありました。

## Commands

> A package comment for a command is similar, but it describes the behavior of the program rather than the Go symbols in the package. The first sentence conventionally begins with the name of the program itself, capitalized because it is at the start of a sentence. For example, here is an abridged version of the package comment for gofmt:

*コマンドのパッケージコメントも同様ですが、パッケージ内のGoシンボルではなく、プログラムの動作について記述します。最初の文は慣習的にプログラムそのものの名前で始まり、文頭にあるため大文字で始まります。*

この後、`gofmt`の例が記載されています。
コマンドの場合はパッケージコメントにコマンドの使い方を書くと良いのですね。

また、コマンドの使い方を記述するにあたっては以下が大事ですね。

> The indented lines are treated as preformatted text: they are not rewrapped and are printed in code font in HTML and Markdown presentations. (The Syntax section below gives the details.)

*インデントされた行は整形済みテキストとして扱われます*

## Types

> A type’s doc comment should explain what each instance of that type represents or provides. If the API is simple, the doc comment can be quite short. For example:

*型のdocコメントは、その型の各インスタンスが何を表し、何を提供するかを説明する必要があります。もしAPIが単純であれば、docコメントは非常に短くすることができます。*

> By default, programmers should expect that a type is safe for use only by a single goroutine at a time. If a type provides stronger guarantees, the doc comment should state them. 

*デフォルトでは、プログラマはその型が一度に一つのゴルーチンによってのみ使用されても安全であることを期待すべきです。もし型がより強力な保証を提供するのであれば、docのコメントにそれを明記すべきです。*

> Go types should also aim to make the zero value have a useful meaning. If it isn’t obvious, that meaning should be documented. 

*また、Goタイプは、ゼロ値が有用な意味を持つようにすることを目指すべきです。もしそれが明白でないなら、その意味は文書化されるべきです。*

ゼロ値での動作保証について書いておくべきであると。

> For a struct with exported fields, either the doc comment or per-field comments should explain the meaning of each exported field. 

*公開フィールドを持つ構造体の場合、docコメントまたはフィールドごとのコメントで、公開された各フィールドの意味を説明する必要があります。*

公開されたフィールドの説明は書きましょう。

## Funcs

> A func’s doc comment should explain what the function returns or, for functions called for side effects, what it does. Named arguments or results can be referred to directly in the comment, without any special syntax like backquotes. (A consequence of this convention is that names like a, which might be mistaken for ordinary words, are typically avoided.) 

*関数のdocコメントは、関数が何を返すか、副作用のために呼び出された関数の場合は、それが何をするかを説明する必要があります。名前付きの引数や結果は、バッククォートなどの特別な構文なしで、コメント内で直接参照することができます。(この慣習の結果として、aのような普通の単語と間違われるような名前は一般的に避けられます)。*

関数の戻り値や作用を書きましょうということで変わったことはなさそうです。

> Doc comments should not explain internal details such as the algorithm used in the current implementation. Those are best left to comments inside the function body. It may be appropriate to give asymptotic time or space bounds when that detail is particularly important to callers. 

*Docコメントは、現在の実装で使用されているアルゴリズムなど、内部の詳細を説明してはいけません。それらは関数本体内のコメントに任せるのがベストです。その詳細が呼び出し側にとって特に重要である場合、漸近的な時間または空間の上界を与えることが適切であるかもしれません。*

Docコメントでメソッド内で使われているアルゴリズムの詳細は書かず、書くなら関数内のコメントにしましょうと。
Docコメントはあくまでも利用する人に対してのAPIドキュメントだというのを忘れずに。
また、将来的に利用しているアルゴリズムを変更してもインターフェースが変わらなければ利用側から見れば関係ないのでそれがベストですよねというお話。

## Consts

> Go’s declaration syntax allows grouping of declarations, in which case a single doc comment can introduce a group of related constants, with individual constants only documented by short end-of-line comments.

*Goの宣言構文では、宣言をグループ化することができます。この場合、1つのdocコメントで関連する定数のグループを紹介し、個々の定数は短い行末コメントによってのみドキュメント化されます。*

> Sometimes the group needs no doc comment at all. 

*グループには、Docコメントが全く必要ない場合もあります。*

> On the other hand, ungrouped constants typically warrant a full doc comment starting with a complete sentence. 

*一方、グループ化されていない定数は、通常、完全な文章で始まるdocのコメントが必要です。*


## Vars

> The conventions for variables are the same as those for constants. 

*変数の規約は定数の規約と同じです。*

## Syntax

> Go doc comments are written in a simple syntax that supports paragraphs, headings, links, lists, and preformatted code blocks. To keep comments lightweight and readable in source files, there is no support for complex features like font changes or raw HTML. Markdown aficionados can view the syntax as a simplified subset of Markdown.

*Go doc のコメントは、段落、見出し、リンク、リスト、書式設定済みのコードブロックをサポートするシンプルな構文で書かれています。コメントを軽量で読みやすいものに保つため、フォントの変更や生の HTML のような複雑な機能はサポートされていません。Markdownの愛好家は、この構文をMarkdownの簡略化されたサブセットと見なすことができます。*

> Gofmt removes leading and trailing blank lines in doc comments.

*Gofmtは、docコメント中の先頭および末尾の空白行を削除します。*

### Paragraphs

> A paragraph is a span of unindented non-blank lines. We’ve already seen many examples of paragraphs.

*段落とは、インデントされていない非空白行のスパンです。段落の例はすでにたくさん見てきました。*

> Gofmt preserves line breaks in paragraph text: it does not rewrap the text. This allows the use of semantic linefeeds, as seen earlier. Gofmt replaces duplicated blank lines between paragraphs with a single blank line. Gofmt also reformats consecutive backticks or single quotes to their Unicode interpretations.

*Gofmt は段落のテキストで改行を維持します: テキストを再ラップしません。これにより、先に見たように、意味的な改行ができるようになります。Gofmt は段落間の重複した空白行を 1 つの空白行に置き換えます。Gofmt は、連続したバックティックや単一引用符を Unicode の解釈に従って再フォーマットします。*

改行が維持されるのは書きやすいですね。ときどきMarkdownで文章を書いていると意図せず１行に表示されてみにくくなってしまったりするので。

### Headings

> A heading is a line beginning with a number sign (U+0023) and then a space and the heading text. To be recognized as a heading, the line must be unindented and set off from adjacent paragraph text by blank lines.

*見出しは、数字記号（U+0023）で始まり、スペースと見出しテキストで構成される行です。見出しとして認識されるためには、その行はインデントされておらず、隣接する段落のテキストとは空白行で分けられていなければなりません。*

`number sign (U+0023) ` は `#` のことですね。Markdownの見出しの記法と同じ。
あと前後に空白行を入れないと見出しと認識されないのは注意。
以下の悪い例が参考になります。

```
// #This is not a heading, because there is no space.
//
// # This is not a heading,
// # because it is multiple lines.
//
// # This is not a heading,
// because it is also multiple lines.
//
// The next paragraph is not a heading, because there is no additional text:
//
// #
//
// In the middle of a span of non-blank lines,
// # this is not a heading either.
//
//     # This is not a heading, because it is indented.
```

> The # syntax was added in Go 1.19. Before Go 1.19, headings were identified implicitly by single-line paragraphs satisfying certain conditions, most notably the lack of any terminating punctuation.

*`#`構文は、Go 1.19で追加されました。Go 1.19 以前では、見出しは、特定の条件、特に終端句がないことを満たす単一行の段落によって暗黙のうちに識別されていました。*

この見出しの書き方は`Go 1.19`で追加された構文なんですね。

### Links

> A span of unindented non-blank lines defines link targets when every line is of the form “[Text]: URL”. In other text in the same doc comment, “[Text]” represents a link to URL using the given text—in HTML, <a href=“URL”>Text</a>. 

*空白行のないインデントされていないスパンは、各行が"[Text]: URL"の形式である場合にリンクターゲットを定義します。同じdocコメント内の他のテキストでは、"[Text]"は与えられたテキストを使ったURLへのリンク、HTMLでは`<a href="URL">Text</a>`を表します。*

例

```
// Package json implements encoding and decoding of JSON as defined in
// [RFC 7159]. The mapping between JSON and Go values is described
// in the documentation for the Marshal and Unmarshal functions.
//
// For an introduction to this package, see the article
// “[JSON and Go].”
//
// [RFC 7159]: https://tools.ietf.org/html/rfc7159
// [JSON and Go]: https://golang.org/doc/articles/json_and_go.htmlpackage json
package json
```

Markdownの記法と似ていますがちょっと異なっていて、注釈的な形になるのでこれはこれで読みやすくなりそうです。
もし `[Text]` を記載して対応するURLの定義をしなかった場合はハイパーリンクにならずそのままの文字列が維持されるようです。

> Plain text that is recognized as a URL is automatically linked in HTML renderings.

*URLとして認識されたプレーンテキストは、HTMLレンダリングで自動的にリンクされます。*

### Doc links

> Doc links are links of the form “[Name1]” or “[Name1.Name2]” to refer to exported identifiers in the current package, or “[pkg]”, “[pkg.Name1]”, or “[pkg.Name1.Name2]” to refer to identifiers in other packages.

*Docリンクは、現在のパッケージでエクスポートされた識別子を参照する場合は "[Name1]"または "[Name1.Name2]"、他のパッケージの識別子を参照する場合は "[pkg]", "[pkg.Name1]","[pkg.Name1.Name2]" という形のリンクです。*

```
package bytes

// ReadFrom reads data from r until EOF and appends it to the buffer, growing
// the buffer as needed. The return value n is the number of bytes read. Any
// error except [io.EOF] encountered during the read is also returned. If the
// buffer becomes too large, ReadFrom will panic with [ErrTooLarge].
func (b *Buffer) ReadFrom(r io.Reader) (n int64, err error) {
    ...
}
```

他のパッケージのドキュメントにも簡単にリンクすることができるのは良いですね。

### Lists

> A list is a span of indented or blank lines (which would otherwise be a code block, as described in the next section) in which the first indented line begins with a bullet list marker or a numbered list marker.

*リストは、インデントされた行または空白行（次のセクションで説明するように、そうでなければコードブロックになる）からなるもので、最初のインデントされた行は、箇条書きリストマーカーまたは番号付きリストマーカーで始まっているものです。*

> A bullet list marker is a star, plus, dash, or Unicode bullet (*, +, -, •; U+002A, U+002B, U+002D, U+2022) followed by a space or tab and then text. In a bullet list, each line beginning with a bullet list marker starts a new list item.

*箇条書きマーカーは、星印、プラス、ダッシュ、または Unicode 箇条書き`（*、+、-、-; U+002A, U+002B, U+002D, U+2022）`の後にスペースまたはタブを入れ、その後にテキストを入れるものです。箇条書きリストでは、箇条書きリスト・マーカーで始まる各行が新しいリスト・アイテムを開始します。*

リストの作り方はMarkdownと同じ感じです。

> List items only contain paragraphs, not code blocks or nested lists. This avoids any space-counting subtlety as well as questions about how many spaces a tab counts for in inconsistent indentation.

*リストアイテムは段落のみを含み、コードブロックやネストされたリストは含みません。これにより、スペースカウントの微妙な問題や、インデントが一定でない場合にタブが何スペースにカウントされるかという問題を回避することができます。*

### Code blocks

> A code block is a span of indented or blank lines not starting with a bullet list marker or numbered list marker. It is rendered as preformatted text (a <pre> block in HTML).

*コードブロックは、箇条書きのリストマーカーや番号付きリストマーカーで始まらない、インデントまたは空白の行のスパンである。プリフォーマットされたテキストとして表示されます（HTMLの<pre>ブロック）。*

リストのマーカーがないところでインデントするとコードブロックとして認識されるようです。


## Common mistakes and pitfalls

*よくある間違いや落とし穴*

> The rule that any span of indented or blank lines in a doc comment is rendered as a code block dates to the earliest days of Go. Unfortunately, the lack of support for doc comments in gofmt has led to many existing comments that use indentation without meaning to create a code block.

*docコメントのインデントや空白行のスパンはコードブロックとしてレンダリングされるというルールは、Goの最も初期の時代にまでさかのぼります。しかし残念ながら、`gofmt`ではdocコメントがサポートされていないため、コードブロックを作る意図でなくインデントを使用したコメントが多く存在しています。*

この後、リストやコードブロックを期待しているところでインデントがないため意図したgodocの出力にならない例がいくつか挙げられていて勉強になりました。

> Another common mistake was an unindented Go function definition or block statement, similarly bracketed by “{” and “}”.The introduction of doc comment reformatting in Go 1.19’s gofmt makes mistakes like these more visible by adding blank lines around the code blocks.

*他によるある間違いは、Goの関数定義やブロック文をインデントせずに`{`や`}`で括ることです。Go 1.19 の`gofmt`で導入された`doc comment reformatting`は、コードブロックの周りに空白行を追加することで、このような間違いをより分かりやすくしています。*

Go Docを記述するときはインデントの使い方に注意が必要ですね。

これでGo Docの書き方とシンタックスについてドキュメントに一通り目を通したことになります。
このドキュメントの内容も踏まえて読みやすいソースコードを書けるように心がけていきたいと思います。
