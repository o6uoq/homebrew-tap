# 🍺 Homebrew Taps via (`o6uoq/tap`)

Tap for formulas not available in `homebrew/core` or an official upstream tap.

## 📦 Formulas

- [fuzmit](https://github.com/o6uoq/fuzmit) - conventional commits, but fuzzy
- [openspec](https://github.com/Fission-AI/OpenSpec) - spec-driven development CLI
- [slidev](https://github.com/slidevjs/slidev) - presentation slides for developers
- [tmux-ide](https://github.com/wavyrai/tmux-ide) - tmux-powered terminal IDE from `ide.yml`
- [toad](https://github.com/batrachianai/toad) - unified AI interface in your terminal
- [try](https://github.com/tobi/try) - ephemeral workspace manager

## 🚀 Install

```bash
brew install o6uoq/tap/<formula>
# examples:
brew install o6uoq/tap/fuzmit
brew install o6uoq/tap/openspec
brew install o6uoq/tap/slidev
brew install o6uoq/tap/tmux-ide
brew install o6uoq/tap/toad
```

## ➕ Add a Formula

```bash
# 1) Create Formula/<name>.rb
brew create --tap o6uoq/tap --set-name <name> <tarball-url>
# 2) Validate locally
brew audit --new --strict o6uoq/tap/<name>
brew install --build-from-source o6uoq/tap/<name>
brew test o6uoq/tap/<name>

# 3) Required before commit
pre-commit run -a
```

## 🔄 Update a Formula

```bash
# Edit Formula/<name>.rb (version + sha256)
brew reinstall o6uoq/tap/<name>
brew test o6uoq/tap/<name>
pre-commit run -a
```

## 🔑 SHA256 Helper

```bash
curl -fsSL <tarball-url> | shasum -a 256
```
