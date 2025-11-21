# Athōn Editor Support - Quick Start

## 🚀 Installation (30 seconds)

### Automatic Installation (Recommended)

```bash
cd editor-support
./install-editor-support.sh
```

That's it! The script will:
- Detect your installed editors
- Install Athōn support automatically
- Show you how to test it

### What Gets Installed

The script installs support for any of these editors it finds:
- ✅ **VS Code** - Full extension with snippets
- ✅ **Sublime Text** - Syntax highlighting
- ✅ **Vim** - Syntax highlighting
- ✅ **Neovim** - Syntax highlighting

---

## 🎨 Testing

After installation, restart your editor and open:

```bash
code editor-support/test-syntax.at    # VS Code
subl editor-support/test-syntax.at    # Sublime Text
vim editor-support/test-syntax.at     # Vim
nvim editor-support/test-syntax.at    # Neovim
```

You should see:
- ✅ Keywords highlighted (fn, let, if, match, etc.)
- ✅ Types highlighted (int, bool, string)
- ✅ Functions highlighted (print, abs, max, etc.)
- ✅ Comments and strings properly colored
- ✅ New keywords: `type`, `trait`, `impl`, `import`

---

## 📝 Quick Example

Create a test file:

```bash
cat > test.at << 'EOF'
// Type aliases
type UserId = int;

// Traits
trait Display {
    fn to_string(self: Point) -> int;
}

// Generics
fn max<T>(a: T, b: T) -> T {
    if a > b { return a; }
    return b;
}

// Union types
type Result = Ok(int) | Err(int);

fn main() {
    print("Hello, Athōn!");
}
EOF
```

Open it in your editor:

```bash
code test.at    # or vim test.at, subl test.at, etc.
```

---

## 🔧 Troubleshooting

### Editor not detected?

Make sure it's in your PATH:

```bash
which code    # VS Code
which subl    # Sublime Text
which vim     # Vim
which nvim    # Neovim
```

### Installation failed?

Try manual installation (see [INSTALLATION.md](INSTALLATION.md))

### Syntax highlighting not working?

1. **Restart your editor** (important!)
2. Check file extension is `.at`
3. For VS Code: Check Extensions panel for "Athōn"
4. For Vim: Run `:set filetype=athon`

---

## 🗑️ Uninstallation

```bash
cd editor-support
./uninstall-editor-support.sh
```

---

## 📚 More Information

- **Full Installation Guide**: [INSTALLATION.md](INSTALLATION.md)
- **Features & Status**: [STATUS.md](STATUS.md)
- **Main README**: [README.md](README.md)

---

## 🎯 VS Code Snippets

Type these prefixes and press Tab:

| Prefix | Description |
|--------|-------------|
| `fn` | Function definition |
| `main` | Main function |
| `struct` | Struct definition |
| `enum` | Enum definition |
| `match` | Pattern matching |
| `trait` | Trait definition |
| `impl` | Trait implementation |
| `type` | Type alias |

---

## ✨ Features Supported

### Language Features (v0.4.0)
- ✅ Type aliases (`type UserId = int;`)
- ✅ Type inference (`let x = 42;`)
- ✅ Generics (`fn max<T>(a: T, b: T) -> T`)
- ✅ Traits (`trait Display { ... }`)
- ✅ Union types (`type Result = Ok(int) | Err(int);`)
- ✅ All core language features

### Editor Features
- ✅ Syntax highlighting
- ✅ Code snippets (VS Code)
- ✅ Auto-closing brackets
- ✅ Comment toggling
- ✅ Code folding
- ✅ Smart indentation

---

## 🚀 Quick Commands

```bash
# Install
./install-editor-support.sh

# Uninstall
./uninstall-editor-support.sh

# Test
code test-syntax.at

# Verify
ls ~/.vscode/extensions/athon-language-*    # VS Code
ls ~/.vim/syntax/athon.vim                  # Vim
```

---

*Last Updated: November 21, 2025*  
*Version: 0.4.0*
