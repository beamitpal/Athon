# Athōn Code Formatting

Complete guide to formatting Athōn code with consistent style.

## 🎨 Formatting Tools

Athōn provides multiple formatting options:

1. **athon-fmt** - Standalone CLI formatter
2. **VS Code Extension** - Integrated formatting
3. **Prettier Plugin** - For Prettier users
4. **Python Script** - Direct formatter access

---

## 🚀 Quick Start

### Option 1: CLI Formatter (Recommended)

```bash
# Format a file (print to stdout)
./athon-fmt examples/hello.at

# Format and write back to file
./athon-fmt -w examples/hello.at

# Check if file needs formatting
./athon-fmt --check examples/hello.at

# Format all .at files in current directory
./athon-fmt --all
```

### Option 2: VS Code (Automatic)

1. Install Athōn extension
2. Open any `.at` file
3. Press `Shift+Alt+F` (or `Cmd+Shift+F` on Mac)
4. Or enable format on save in settings

### Option 3: Python Script

```bash
# Format a file
python3 editor-support/athon-format.py examples/hello.at

# Format and write
python3 editor-support/athon-format.py -w examples/hello.at

# Format from stdin
cat examples/hello.at | python3 editor-support/athon-format.py --stdin
```

---

## 📋 Formatting Rules

### Indentation
- **4 spaces** per indentation level
- No tabs
- Consistent throughout file

**Before:**
```athon
fn main() {
let x=42;
if x>0{
print("positive");
}
}
```

**After:**
```athon
fn main() {
    let x = 42;
    if x > 0 {
        print("positive");
    }
}
```

### Operators
- Space around binary operators: `=`, `+`, `-`, `*`, `/`, `==`, `!=`, `<`, `>`, `<=`, `>=`
- Space around logical operators: `&&`, `||`

**Before:**
```athon
let result=a+b*c;
if x==42&&y!=0{
```

**After:**
```athon
let result = a + b * c;
if x == 42 && y != 0 {
```

### Keywords
- Space after keywords: `fn`, `let`, `if`, `else`, `while`, `for`, `return`, etc.

**Before:**
```athon
fn add(a:int,b:int)->int{
    return a+b;
}
```

**After:**
```athon
fn add(a: int, b: int) -> int {
    return a + b;
}
```

### Commas and Colons
- Space after commas: `, `
- Space after colons (except `::`): `: `

**Before:**
```athon
fn test(a:int,b:int,c:int){
    let point=Point{x:10,y:20};
}
```

**After:**
```athon
fn test(a: int, b: int, c: int) {
    let point = Point { x: 10, y: 20 };
}
```

### Braces
- Opening brace on same line
- Closing brace on new line, aligned with statement

**Before:**
```athon
fn main()
{
    if true
    {
        print("hello");
    }
}
```

**After:**
```athon
fn main() {
    if true {
        print("hello");
    }
}
```

---

## ⚙️ Configuration

### VS Code Settings

Add to your `settings.json`:

```json
{
    "athon.formatOnSave": true,
    "athon.indentSize": 4,
    "[athon]": {
        "editor.defaultFormatter": "athon-lang.athon-language",
        "editor.formatOnSave": true,
        "editor.tabSize": 4,
        "editor.insertSpaces": true
    }
}
```

### Prettier Configuration

Create `.prettierrc`:

```json
{
    "plugins": ["./editor-support/prettier-plugin-athon"],
    "printWidth": 100,
    "tabWidth": 4,
    "useTabs": false,
    "overrides": [
        {
            "files": "*.at",
            "options": {
                "parser": "athon"
            }
        }
    ]
}
```

---

## 🔧 Installation

### Install CLI Formatter

```bash
# Copy to system path
sudo cp editor-support/athon-format.py /usr/local/bin/
sudo cp athon-fmt /usr/local/bin/

# Or add to PATH
export PATH="$PATH:$(pwd)"
```

### Install VS Code Extension

```bash
cd editor-support
./install-editor-support.sh
```

### Install Prettier Plugin

```bash
cd editor-support/prettier-plugin-athon
npm install
npm link

# In your project
npm link prettier-plugin-athon
```

---

## 📝 Examples

### Before Formatting

```athon
type UserId=int;
fn create_user(id:UserId,name:string)->UserId{
let user=User{id:id,name:name};
if id>0{
print("Created user: {}",name);
return id;
}
return 0;
}
struct User{id:int,name:string,}
```

### After Formatting

```athon
type UserId = int;

fn create_user(id: UserId, name: string) -> UserId {
    let user = User { id: id, name: name };
    if id > 0 {
        print("Created user: {}", name);
        return id;
    }
    return 0;
}

struct User {
    id: int,
    name: string,
}
```

---

## 🎯 Format on Save

### VS Code

Automatically enabled with Athōn extension.

### Vim

Add to `.vimrc`:

```vim
autocmd BufWritePre *.at !athon-fmt -w %
```

### Sublime Text

Install "SublimeOnSaveBuild" package and configure:

```json
{
    "filename_filter": "\\.at$",
    "command": "athon-fmt -w ${file}"
}
```

---

## 🧪 Testing

Test the formatter:

```bash
# Create test file
cat > test.at << 'EOF'
fn main(){let x=42;print("x={}",x);}
EOF

# Format it
./athon-fmt -w test.at

# Check result
cat test.at
```

Expected output:
```athon
fn main() {
    let x = 42;
    print("x = {}", x);
}
```

---

## 🔍 Troubleshooting

### Formatter not found

```bash
# Check if formatter exists
ls -la editor-support/athon-format.py

# Make it executable
chmod +x editor-support/athon-format.py

# Test it
python3 editor-support/athon-format.py --help
```

### VS Code not formatting

1. Check extension is installed: Extensions → "Athōn"
2. Check file is recognized: Bottom right should show "Athōn"
3. Check settings: `athon.formatOnSave` should be `true`
4. Try manual format: `Shift+Alt+F`

### Python not found

```bash
# Install Python 3
sudo apt install python3  # Ubuntu/Debian
brew install python3      # macOS

# Verify
python3 --version
```

---

## 📚 Advanced Usage

### Format Multiple Files

```bash
# Format all examples
for file in examples/*.at; do
    ./athon-fmt -w "$file"
done

# Or use --all
cd examples && ../athon-fmt --all
```

### Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
# Format all staged .at files

for file in $(git diff --cached --name-only --diff-filter=ACM | grep '\.at$'); do
    ./athon-fmt -w "$file"
    git add "$file"
done
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

### CI/CD Integration

```bash
# Check formatting in CI
./athon-fmt --check examples/*.at

# Exit code 0 = formatted, 1 = needs formatting
```

---

## 🎨 Style Guide

### Recommended Practices

1. **Always format before committing**
2. **Use 4 spaces for indentation**
3. **Keep lines under 100 characters**
4. **Add blank lines between functions**
5. **Group related code together**

### Example Style

```athon
// Type aliases at top
type UserId = int;
type Score = int;

// Structs next
struct User {
    id: UserId,
    name: string,
    score: Score,
}

// Functions last
fn create_user(id: UserId, name: string) -> User {
    return User {
        id: id,
        name: name,
        score: 0,
    };
}

fn main() {
    let user = create_user(1, "Alice");
    print("Created: {}", user.name);
}
```

---

## 🚀 Future Enhancements

Planned features:

- [ ] Configurable line width
- [ ] Custom indentation styles
- [ ] Comment formatting
- [ ] Import sorting
- [ ] Blank line management
- [ ] Alignment options

---

*Last Updated: November 21, 2025*  
*Version: 0.4.0*
