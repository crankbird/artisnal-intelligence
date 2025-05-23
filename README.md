# Crankbird's Blog Development Repo

This repo is designed to create a clean Jeckyl blog that is responsive, minimal,
supports multiple themes (just dark and light for now) with easy switching and has reasonably pleasing aesthetics.

It wont win any awards for now, but it is as cruft free as I can make it. If you
like it then fork it, or dont, the main reason this repo is here is to build
trust in the blogs it creates to demonstrate that there is nothing sneaky going
on with tracking cookies, and if you want to be paranoid, then just pull down
the code, run it in your own environment and enjoy ... or not.

## 🛠 Recommended Editor Setup

This project is built and tested using **Visual Studio Code**.  
While you’re free to use any editor you like, the following VS Code
configuration will provide the best authoring experience — especially when
working with **Markdown**, **Jekyll**, and **Liquid templates**.

### ✨ Recommended Extensions

These are listed in `.vscode/extensions.json` and will be automatically suggested by VS Code:

- [`yzhang.markdown-all-in-one`](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
- [`davidanson.vscode-markdownlint`](https://marketplace.visualstudio.com/items?itemName=davidanson.vscode-markdownlint)
- [`sissel.shopify-liquid`](https://marketplace.visualstudio.com/items?itemName=sissel.shopify-liquid)
- [`redhat.vscode-yaml`](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)
- [`ecmel.vscode-html-css`](https://marketplace.visualstudio.com/items?itemName=ecmel.vscode-html-css)

### ⚙️ Format-on-Save and Linting

To avoid breaking Liquid syntax inside Markdown or YAML:

- **Global format-on-save is enabled**, but disabled for `.md` and `.yml` files in `.vscode/settings.json`
- Markdownlint rules are customized to allow:
  - Inline HTML (`MD033`)
  - Multiple H1s (`MD002`)
  - Liquid tag spacing and formatting

You can override this per-project using your own settings, but the defaults aim for **maximum compatibility with Jekyll**.

### 🧠 Not Using VS Code?

If you're editing this with **Sublime, Emacs, Vim, JetBrains, or other IDEs**:
- You’ll need to configure your own linter and formatter exclusions to avoid issues with `{% ... %}` and `{{ ... }}`
- If things go sideways, refer to `.vscode/settings.json` and `.markdownlint.json` for guidance

> 🕵️‍♂️ _If it breaks your Emacs mode, I salute your courage and await your pull request._