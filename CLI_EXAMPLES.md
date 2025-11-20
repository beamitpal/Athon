# Athōn CLI Examples

Real-world examples showing how the CLI simplifies Athōn development.

## Example 1: Hello World (The Simplest Way)

### Old Way ❌
```bash
./athon-boot examples/hello.at > hello.c
gcc hello.c -o hello
./hello
rm hello.c hello
```

### New Way ✅
```bash
athon run examples/hello.at
```

**Result:** Same output, 75% less typing, automatic cleanup!

---

## Example 2: Building a Calculator

### Step 1: Create Project

```bash
athon new calculator
cd calculator
```

**Generated structure:**
```
calculator/
├── src/
│   └── main.at
├── tests/
├── athon.toml
├── README.md
└── .gitignore
```

### Step 2: Write Code

**src/main.at:**
```athon
fn add(a: int, b: int) -> int {
    return a + b;
}

fn subtract(a: int, b: int) -> int {
    return a - b;
}

fn multiply(a: int, b: int) -> int {
    return a * b;
}

fn divide(a: int, b: int) -> int {
    if b == 0 {
        print("Error: Division by zero!");
        return 0;
    }
    return a / b;
}

fn main() {
    print("Calculator Demo");
    print("===============");
    
    let x = 10;
    let y = 5;
    
    print("{} + {} = {}", x, y, add(x, y));
    print("{} - {} = {}", x, y, subtract(x, y));
    print("{} * {} = {}", x, y, multiply(x, y));
    print("{} / {} = {}", x, y, divide(x, y));
}
```

### Step 3: Test During Development

```bash
athon run src/main.at
```

**Output:**
```
Calculator Demo
===============
10 + 5 = 15
10 - 5 = 5
10 * 5 = 50
10 / 5 = 2
```

### Step 4: Add Tests

**tests/test_calc.at:**
```athon
fn test_add() -> bool {
    return (5 + 3) == 8;
}

fn test_subtract() -> bool {
    return (10 - 4) == 6;
}

fn test_multiply() -> bool {
    return (6 * 7) == 42;
}

fn test_divide() -> bool {
    return (20 / 4) == 5;
}

fn main() {
    let passed = 0;
    let total = 4;
    
    if test_add() {
        print("✓ test_add");
        passed = passed + 1;
    } else {
        print("✗ test_add");
    }
    
    if test_subtract() {
        print("✓ test_subtract");
        passed = passed + 1;
    } else {
        print("✗ test_subtract");
    }
    
    if test_multiply() {
        print("✓ test_multiply");
        passed = passed + 1;
    } else {
        print("✗ test_multiply");
    }
    
    if test_divide() {
        print("✓ test_divide");
        passed = passed + 1;
    } else {
        print("✗ test_divide");
    }
    
    print("");
    print("Tests: {} / {} passed", passed, total);
    
    if passed != total {
        // Exit with error code
        let x = 1 / 0;  // Force error
    }
}
```

### Step 5: Run Tests

```bash
athon test
```

**Output:**
```
🧪 Running tests...
  Testing test_calc.at... ✅ PASSED

📊 Results: 1 passed, 0 failed
```

### Step 6: Build Release

```bash
athon build src/main.at -O -o calculator
```

**Result:** Optimized `calculator` executable ready to distribute!

---

## Example 3: File Processing Tool

### Create Project

```bash
athon new file-processor
cd file-processor
```

### Write Code

**src/main.at:**
```athon
fn count_lines(filename: string) -> int {
    if !file_exists(filename) {
        print("Error: File not found: {}", filename);
        return 0;
    }
    
    let content = file_read(filename);
    let count = 0;
    let i = 0;
    
    while i < length(content) {
        if char_at(content, i) == '\n' {
            count = count + 1;
        }
        i = i + 1;
    }
    
    return count + 1;  // Last line might not have \n
}

fn count_words(filename: string) -> int {
    if !file_exists(filename) {
        return 0;
    }
    
    let content = file_read(filename);
    let count = 0;
    let in_word = false;
    let i = 0;
    
    while i < length(content) {
        let c = char_at(content, i);
        
        if c == ' ' || c == '\n' || c == '\t' {
            in_word = false;
        } else {
            if !in_word {
                count = count + 1;
                in_word = true;
            }
        }
        
        i = i + 1;
    }
    
    return count;
}

fn main() {
    let filename = "README.md";
    
    print("File Statistics for: {}", filename);
    print("==================================");
    
    if file_exists(filename) {
        let lines = count_lines(filename);
        let words = count_words(filename);
        let content = file_read(filename);
        let chars = length(content);
        
        print("Lines: {}", lines);
        print("Words: {}", words);
        print("Characters: {}", chars);
    } else {
        print("File not found!");
    }
}
```

### Test It

```bash
# Create a test file
echo "Hello World\nThis is a test\nThree lines" > test.txt

# Run the processor
athon run src/main.at
```

### Build and Use

```bash
# Build optimized version
athon build src/main.at -O -o wc

# Use it
./wc
```

---

## Example 4: Web Server (Future)

### Project Setup

```bash
athon new web-server
cd web-server
```

### Code Structure

**src/main.at:**
```athon
struct Request {
    method: string,
    path: string,
    body: string,
}

struct Response {
    status: int,
    body: string,
}

fn handle_request(req: Request) -> Response {
    if req.path == "/" {
        return Response {
            status: 200,
            body: "Hello from Athōn!",
        };
    } else if req.path == "/about" {
        return Response {
            status: 200,
            body: "Athōn Web Server v1.0",
        };
    } else {
        return Response {
            status: 404,
            body: "Not Found",
        };
    }
}

fn main() {
    print("Starting server on port 8080...");
    
    // Future: server_listen(8080, handle_request);
    
    print("Server running!");
}
```

### Development Workflow

```bash
# Quick test
athon run src/main.at

# Run tests
athon test

# Build production
athon build src/main.at -O -o server

# Deploy
./server
```

---

## Example 5: Game Development

### Create Game Project

```bash
athon new snake-game
cd snake-game
```

### Game Logic

**src/main.at:**
```athon
struct Point {
    x: int,
    y: int,
}

struct Snake {
    head: Point,
    length: int,
    direction: int,  // 0=up, 1=right, 2=down, 3=left
}

fn init_snake() -> Snake {
    return Snake {
        head: Point { x: 10, y: 10 },
        length: 3,
        direction: 1,
    };
}

fn move_snake(snake: Snake) -> Snake {
    let new_head = snake.head;
    
    if snake.direction == 0 {
        new_head.y = new_head.y - 1;
    } else if snake.direction == 1 {
        new_head.x = new_head.x + 1;
    } else if snake.direction == 2 {
        new_head.y = new_head.y + 1;
    } else {
        new_head.x = new_head.x - 1;
    }
    
    return Snake {
        head: new_head,
        length: snake.length,
        direction: snake.direction,
    };
}

fn main() {
    print("Snake Game");
    print("==========");
    
    let snake = init_snake();
    
    print("Initial position: ({}, {})", snake.head.x, snake.head.y);
    
    snake = move_snake(snake);
    print("After move: ({}, {})", snake.head.x, snake.head.y);
    
    snake = move_snake(snake);
    print("After move: ({}, {})", snake.head.x, snake.head.y);
}
```

### Rapid Development

```bash
# Edit and test loop
vim src/main.at
athon run src/main.at

# Repeat until satisfied
```

---

## Example 6: Data Processing Pipeline

### Setup

```bash
athon new data-pipeline
cd data-pipeline
```

### Pipeline Code

**src/main.at:**
```athon
fn read_csv(filename: string) -> array<string> {
    let content = file_read(filename);
    // Parse CSV (simplified)
    return split(content, "\n");
}

fn filter_data(data: array<string>, min_value: int) -> array<string> {
    let result = [];
    let i = 0;
    
    while i < length(data) {
        let value = parse_int(data[i]);
        if value >= min_value {
            result = append(result, data[i]);
        }
        i = i + 1;
    }
    
    return result;
}

fn aggregate_sum(data: array<string>) -> int {
    let sum = 0;
    let i = 0;
    
    while i < length(data) {
        sum = sum + parse_int(data[i]);
        i = i + 1;
    }
    
    return sum;
}

fn main() {
    print("Data Pipeline");
    print("=============");
    
    // Simulate data
    let data = ["10", "25", "5", "30", "15"];
    
    print("Original data: {} items", length(data));
    
    let filtered = filter_data(data, 10);
    print("Filtered (>= 10): {} items", length(filtered));
    
    let total = aggregate_sum(filtered);
    print("Sum: {}", total);
}
```

### Run Pipeline

```bash
athon run src/main.at
```

**Output:**
```
Data Pipeline
=============
Original data: 5 items
Filtered (>= 10): 4 items
Sum: 80
```

---

## Workflow Comparison

### Traditional Workflow

```bash
# 1. Edit code
vim program.at

# 2. Compile to C
./athon-boot program.at > program.c

# 3. Check for errors
cat program.c

# 4. Compile C
gcc program.c -o program

# 5. Run
./program

# 6. Cleanup
rm program.c program

# Total: 6 commands
```

### CLI Workflow

```bash
# 1. Edit code
vim program.at

# 2. Run
athon run program.at

# Total: 2 commands (3x faster!)
```

---

## Pro Tips

### 1. Watch Mode

```bash
# Auto-run on file changes
ls src/*.at | entr -c athon run src/main.at
```

### 2. Quick Experiments

```bash
# Test code snippets without creating files
echo 'fn main() { print("test"); }' | athon run /dev/stdin
```

### 3. Debugging

```bash
# Build with debug symbols
athon build main.at -g -o debug-app

# Debug with GDB
gdb ./debug-app
```

### 4. Performance Testing

```bash
# Compare optimizations
athon build main.at -o normal
athon build main.at -O -o optimized

time ./normal
time ./optimized
```

### 5. CI/CD Integration

```bash
# In your CI script
athon test || exit 1
athon build src/main.at -O -o release
```

---

## Summary

The Athōn CLI transforms development from a multi-step manual process into a streamlined, automated workflow:

- **Faster**: One command instead of many
- **Cleaner**: Automatic file management
- **Easier**: Sensible defaults
- **Professional**: Project scaffolding and testing

**Start using the CLI today and focus on writing code, not managing build steps!** 🚀
