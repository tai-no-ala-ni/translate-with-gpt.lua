# [translate-with-gpt-denops](https://github.com/tai-no-ala-ni/translate-with-gpt-denops)に移行

<details><summary>以前の説明</summary>

# translate-with-gpt.lua

- Neovim 内でテキストを選択して`:Translate`

- ※ OpenAI の API キーが必要です

- ※ OpenAI の API キーを使うと別途料金がかかります．

## install

- dein

```vimscript
call dein#add("tai-no-ala-ni/translate-with-gpt.lua")
command! -range Translate lua require("translate-with-gpt").translate()<CR>
```

## requirements

- Neovim v0.10.0

- curl >= 8.1.2

- jq >= 1.6

- OS: MacOS or Linux

## todo

- [ ] 使い方の映像を追加

- [ ] 他の言語への翻訳対応

- [ ] doc の追加

- [ ] vim 対応

- [ ] Windows 対応

- [ ] モデルの変更ができるようにする

</details>
