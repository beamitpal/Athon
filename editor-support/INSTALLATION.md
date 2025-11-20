# Athōn Editor Support - Installation Guide

This guide explains how to install syntax highlighting and editor support for Athōn in various editors and IDEs.

## Table of Contents

- [VS Code](#vs-code)
- [Sublime Text](#sublime-text)
- [Vim/Neovim](#vimneovim)
- [Emacs](#emacs)
- [IntelliJ IDEA / JetBrains IDEs](#intellij-idea--jetbrains-ides)
- [Atom](#atom)
- [GitHub](#github)

---

## VS Code

### Method 1: Manual Installation (Recommended)

1. **Copy the extension folder:**
   ```bash
   # Linux/macOS
   cp -r editor-support/vscode/athon ~/.vscode/extensions/athon-language-0.3.0
   
   # Windows (PowerShell)
   Copy-Item -Recurse editor-support\vscode\athon $env:USERPROFILE\.vscode\extensions\athon-language-0.3.0
   ```

2. **Restart VS Code**

3. **Open any `.at` file** - syntax highlighting will be applied automatically

### Method 2: From VSIX Package (Future)

```bash
# Build the package
cd editor-support/vscode/athon
npm install -g vsce
vsce package

# Install the package
code --install-extension athon-language-0.3.0.vsix
```

### Features in VS Code

- ✅ Syntax highlighting
- ✅ Code snippets (type `fn`, `main`, `if`, etc. and press Tab)
- ✅ Auto-closing brackets and quotes
- ✅ Comment toggling (Ctrl+/)
- ✅ Smart indentation
- ✅ Code folding

### Snippets Available

- `fn` - Function definition
- `main` - Main function
- `if` / `ifelse` - Conditionals
- `while` / `for` - Loops
- `match` - Pattern matching
- `struct` / `enum` - Data structures
- `let` - Variable declaration
- `print` / `printf` - Output

---

## Sublime Text

### Installation

1. **Find your Sublime Text packages directory:**
   - **Linux**: `~/.config/sublime-text/Packages/User/`
   - **macOS**: `~/Library/Application Support/Sublime Text/Packages/User/`
   - **Windows**: `%APPDATA%\Sublime Text\Packages\User\`

2. **Copy the syntax file:**
   ```bash
   # Linux/macOS
   cp editor-support/sublime-text/Athon.sublime-syntax \
      ~/.config/sublime-text/Packages/User/
   
   # Windows (PowerShell)
   Copy-Item editor-support\sublime-text\Athon.sublime-syntax \
      $env:APPDATA\Sublime Text\Packages\User\
   ```

3. **Restart Sublime Text**

4. **Open a `.at` file** and select **View → Syntax → Athōn**

### Make it Default for .at Files

1. Open any `.at` file
2. Go to **View → Syntax → Open all with current extension as... → Athōn**

---

## Vim/Neovim

### Installation

1. **Create syntax directory if it doesn't exist:**
   ```bash
   mkdir -p ~/.vim/syntax
   mkdir -p ~/.vim/ftdetect
   ```

2. **Copy the syntax files:**
   ```bash
   cp editor-support/vim/syntax/athon.vim ~/.vim/syntax/
   cp editor-support/vim/ftdetect/athon.vim ~/.vim/ftdetect/
   ```

3. **For Neovim:**
   ```bash
   mkdir -p ~/.config/nvim/syntax
   mkdir -p ~/.config/nvim/ftdetect
   cp editor-support/vim/syntax/athon.vim ~/.config/nvim/syntax/
   cp editor-support/vim/ftdetect/athon.vim ~/.config/nvim/ftdetect/
   ```

4. **Restart Vim/Neovim**

### Manual Activation

If auto-detection doesn't work, add to your `.vimrc` or `init.vim`:

```vim
au BufRead,BufNewFile *.at set filetype=athon
```

---

## Emacs

### Installation

Create a file `~/.emacs.d/athon-mode.el`:

```elisp
;;; athon-mode.el --- Major mode for Athōn programming language

(defvar athon-mode-hook nil)

(defvar athon-mode-map
  (let ((map (make-keymap)))
    (define-key map "\C-j" 'newline-and-indent)
    map)
  "Keymap for Athōn major mode")

(add-to-list 'auto-mode-alist '("\\.at\\'" . athon-mode))

(defconst athon-font-lock-keywords
  (list
   '("\\<\\(fn\\|let\\|if\\|else\\|while\\|for\\|in\\|match\\|return\\|struct\\|enum\\)\\>" . font-lock-keyword-face)
   '("\\<\\(int\\|bool\\|string\\)\\>" . font-lock-type-face)
   '("\\<\\(true\\|false\\)\\>" . font-lock-constant-face)
   '("\\<\\(print\\|abs\\|min\\|max\\|pow\\|sqrt\\|mod\\|file_read\\|file_write\\)\\>" . font-lock-builtin-face)
   '("//.*" . font-lock-comment-face)
   '("/\\*.*\\*/" . font-lock-comment-face))
  "Highlighting expressions for Athōn mode")

(defun athon-mode ()
  "Major mode for editing Athōn files"
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table athon-mode-syntax-table)
  (use-local-map athon-mode-map)
  (set (make-local-variable 'font-lock-defaults) '(athon-font-lock-keywords))
  (set (make-local-variable 'comment-start) "// ")
  (set (make-local-variable 'comment-end) "")
  (setq major-mode 'athon-mode)
  (setq mode-name "Athōn")
  (run-hooks 'athon-mode-hook))

(provide 'athon-mode)
```

Add to your `~/.emacs` or `~/.emacs.d/init.el`:

```elisp
(load "~/.emacs.d/athon-mode.el")
```

---

## IntelliJ IDEA / JetBrains IDEs

### Custom File Type

1. **Open Settings** (Ctrl+Alt+S / Cmd+,)
2. **Go to:** Editor → File Types
3. **Click** the `+` button to add a new file type
4. **Name:** Athōn
5. **Line comment:** `//`
6. **Block comment start:** `/*`
7. **Block comment end:** `*/`
8. **Add keywords:**
   - `fn`, `let`, `if`, `else`, `while`, `for`, `in`, `match`, `return`
   - `struct`, `enum`, `true`, `false`
9. **Add file pattern:** `*.at`
10. **Click OK**

### Enhanced Support (Future)

A full IntelliJ plugin can be created using the IntelliJ Platform SDK for:
- Advanced syntax highlighting
- Code completion
- Error detection
- Refactoring support

---

## Atom

### Installation

1. **Create package directory:**
   ```bash
   mkdir -p ~/.atom/packages/language-athon
   ```

2. **Create `package.json`:**
   ```json
   {
     "name": "language-athon",
     "version": "0.3.0",
     "description": "Athōn language support",
     "engines": {
       "atom": ">=1.0.0"
     }
   }
   ```

3. **Create `grammars/athon.cson`:**
   ```coffee
   'scopeName': 'source.athon'
   'name': 'Athōn'
   'fileTypes': ['at']
   'patterns': [
     {
       'match': '\\b(fn|let|if|else|while|for|match|return)\\b'
       'name': 'keyword.control.athon'
     }
     {
       'match': '\\b(int|bool|string)\\b'
       'name': 'storage.type.athon'
     }
     {
       'match': '//.*$'
       'name': 'comment.line.athon'
     }
   ]
   ```

4. **Reload Atom** (Ctrl+Shift+F5 / Cmd+Shift+F5)

---

## GitHub

### Syntax Highlighting on GitHub

Create `.gitattributes` in your repository root:

```gitattributes
*.at linguist-language=Rust
```

This tells GitHub to use Rust-like syntax highlighting for `.at` files until official Athōn support is added.

### Better Alternative

Create a `languages.yml` file for GitHub Linguist:

```yaml
Athōn:
  type: programming
  color: "#4A90E2"
  extensions:
    - ".at"
  tm_scope: source.athon
  ace_mode: rust
  language_id: 999999999
```

---

## Testing Your Installation

Create a test file `test.at`:

```athon
// Test file for syntax highlighting

fn main() {
    let x = 42;
    let message = "Hello, Athōn!";
    
    if x > 10 {
        print("x is {}", x);
    }
    
    for i in 0..5 {
        print("i = {}", i);
    }
    
    match x {
        42 => print("The answer!"),
        _ => print("Something else"),
    }
}

struct Point {
    x: int,
    y: int,
}

enum Color {
    Red,
    Green,
    Blue,
}
```

Open this file in your editor and verify:
- ✅ Keywords are highlighted (fn, let, if, etc.)
- ✅ Types are highlighted (int, bool, string)
- ✅ Strings are highlighted
- ✅ Comments are highlighted
- ✅ Numbers are highlighted
- ✅ Built-in functions are highlighted (print, etc.)

---

## Troubleshooting

### VS Code: Syntax highlighting not working

1. Check file extension is `.at`
2. Restart VS Code
3. Check extension is in `~/.vscode/extensions/`
4. Try: Ctrl+Shift+P → "Developer: Reload Window"

### Vim: Syntax not detected

1. Check files are in correct directories
2. Add to `.vimrc`: `au BufRead,BufNewFile *.at set filetype=athon`
3. Restart Vim or run `:source ~/.vimrc`

### Sublime Text: Syntax not available

1. Check file is in Packages/User/ directory
2. Restart Sublime Text
3. Manually select: View → Syntax → Athōn

---

## Advanced: Language Server Protocol (LSP)

For advanced IDE features like:
- Auto-completion
- Go to definition
- Find references
- Error checking
- Refactoring

You would need to implement an LSP server. This is a future enhancement.

### LSP Implementation (Future)

An LSP server would provide:
- Real-time error checking
- Intelligent code completion
- Symbol navigation
- Hover information
- Code formatting
- Refactoring support

See [docs/lsp-implementation.md](../docs/lsp-implementation.md) for details (future).

---

## Contributing

To improve editor support:

1. Test the syntax files in your editor
2. Report issues or missing features
3. Submit improvements via pull request
4. Add support for additional editors

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

---

## Summary

| Editor | Installation Difficulty | Features |
|--------|------------------------|----------|
| VS Code | ⭐ Easy | Full support |
| Sublime Text | ⭐⭐ Medium | Syntax only |
| Vim/Neovim | ⭐⭐ Medium | Syntax only |
| Emacs | ⭐⭐⭐ Advanced | Basic support |
| IntelliJ | ⭐⭐ Medium | Manual setup |
| Atom | ⭐⭐ Medium | Basic support |

**Recommended:** VS Code for the best out-of-box experience.

---

For questions or issues, see [CONTRIBUTING.md](../CONTRIBUTING.md) or open an issue.
