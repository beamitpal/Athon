# Athōn Language Guide

Welcome to the Athōn programming language! This guide will teach you everything you need to know to write Athōn programs.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Basic Syntax](#basic-syntax)
3. [Variables and Types](#variables-and-types)
4. [Operators](#operators)
5. [Control Flow](#control-flow)
6. [Functions](#functions)
7. [Data Structures](#data-structures)
8. [Pattern Matching](#pattern-matching)
9. [Standard Library](#standard-library)
10. [File I/O](#file-io)
11. [Best Practices](#best-practices)

---

## Getting Started

### Hello, World!

```athon
fn main() {
    print("Hello, World!");
}
```

Every Athōn program starts with a `main` function. The `print` function outputs text to the console.

### Compiling and Running

```bash
# Compile Athōn to C
./athon-boot hello.at > hello.c

# Compile C to executable
gcc hello.c -o hello

# Run the program
./hello
```

---

## Basic Syntax

### Comments

```athon
// Single-line comment

/*
   Multi-line comment
   Can span multiple lines
*/
```

### Statements

Most statements end with a semicolon (`;`):

```athon
let x = 10;
print("Hello");
x = x + 1;
```

---

## Variables and Types

### Variable Declaration

Use `let` to declare variables:

```athon
let x = 42;           // Integer
let flag = true;      // Boolean
let message = "Hi";   // String
```

### Types

Athōn has three basic types:

- **int**: Integer numbers (e.g., `42`, `-10`, `0`)
- **bool**: Boolean values (`true` or `false`)
- **string**: Text strings (e.g., `"Hello"`)

### Assignment

```athon
let x = 10;
x = 20;        // Reassign x
x = x + 5;     // Use x in expression
```

---

## Operators

### Arithmetic Operators

```athon
let a = 10 + 5;    // Addition: 15
let b = 10 - 5;    // Subtraction: 5
let c = 10 * 5;    // Multiplication: 50
let d = 10 / 5;    // Division: 2
```

### Comparison Operators

```athon
x == y    // Equal to
x != y    // Not equal to
x < y     // Less than
x > y     // Greater than
x <= y    // Less than or equal
x >= y    // Greater than or equal
```

### Logical Operators

```athon
x && y    // Logical AND
x || y    // Logical OR
!x        // Logical NOT
```

### Unary Operators

```athon
let x = -5;     // Negation
let y = !flag;  // Logical NOT
```

---

## Control Flow

### If Statements

```athon
if x > 10 {
    print("x is greater than 10");
}

if x == 5 {
    print("x is 5");
} else {
    print("x is not 5");
}
```

### While Loops

```athon
let i = 0;
while i < 5 {
    print("i = {}", i);
    i = i + 1;
}
```

### For Loops

```athon
for i in 0..5 {
    print("i = {}", i);
}

// Nested loops
for x in 0..3 {
    for y in 0..3 {
        print("({}, {})", x, y);
    }
}
```

---

## Functions

### Function Definition

```athon
fn add(a: int, b: int) -> int {
    return a + b;
}

fn greet(name: string) {
    print("Hello, {}!", name);
}
```

### Calling Functions

```athon
fn main() {
    let sum = add(5, 3);
    print("Sum: {}", sum);
    
    greet("Alice");
}
```

### Recursive Functions

```athon
fn factorial(n: int) -> int {
    if n <= 1 {
        return 1;
    }
    return n * factorial(n - 1);
}
```

---

## Data Structures

### Arrays

```athon
// Array literal
let numbers = [1, 2, 3, 4, 5];

// Array indexing
let first = numbers[0];
let second = numbers[1];

// Array length
let len = array_length(numbers);
```

### Structs

```athon
// Define a struct
struct Point {
    x: int,
    y: int,
}

// Create struct instance
let p = Point { x: 10, y: 20 };

// Access members
let x_val = p.x;
let y_val = p.y;

// Structs as function parameters
fn distance(p1: Point, p2: Point) -> int {
    let dx = abs(p2.x - p1.x);
    let dy = abs(p2.y - p1.y);
    return sqrt(dx * dx + dy * dy);
}
```

### Enums

```athon
// Define an enum
enum Color {
    Red,
    Green,
    Blue,
}

// Use enum variants
let c = Color::Red;

// Compare enum values
if c == Color::Red {
    print("It's red!");
}
```

---

## Pattern Matching

Pattern matching provides a powerful way to handle different cases:

### Basic Match

```athon
let x = 5;

match x {
    0 => print("Zero"),
    1 => print("One"),
    5 => print("Five"),
    _ => print("Other"),
}
```

### Enum Matching

```athon
enum Status {
    Ok,
    Error,
    Pending,
}

fn handle_status(s: int) {
    match s {
        Status::Ok => print("Success!"),
        Status::Error => print("Error occurred"),
        Status::Pending => print("Still pending..."),
    }
}
```

### Match with Blocks

```athon
match value {
    0 => {
        print("Zero");
        print("Nothing to do");
    },
    1 => {
        print("One");
        print("Processing...");
    },
    _ => print("Other value"),
}
```

### Match with Assignments

```athon
let result = 0;
match x {
    0 => result = 10,
    1 => result = 20,
    _ => result = 30,
}
```

---

## Standard Library

### Math Functions

```athon
// Absolute value
let x = abs(-5);        // 5

// Minimum and maximum
let min_val = min(10, 20);  // 10
let max_val = max(10, 20);  // 20

// Power
let power = pow(2, 8);      // 256

// Square root (integer)
let root = sqrt(100);       // 10

// Modulo
let remainder = mod(17, 5); // 2
```

### String Functions

```athon
let s = "Hello";
let len = length(s);           // 5

let s1 = "Hello";
let s2 = "World";
let cmp = compare(s1, s2);     // Non-zero if different
```

### Printf-style Formatting

```athon
let x = 10;
let y = 20;

print("x = {}, y = {}", x, y);
print("Sum: {}", x + y);
```

---

## File I/O

### Writing Files

```athon
// Write to a file (overwrites if exists)
let result = file_write("output.txt", "Hello, World!");

if result == 1 {
    print("File written successfully");
} else {
    print("Failed to write file");
}
```

### Reading Files

```athon
// Read entire file content
let content = file_read("input.txt");
// Note: content is a string, but printing string variables
// requires special handling in the current version
```

### Appending to Files

```athon
// Append to existing file
file_append("log.txt", "New log entry\n");
```

### Checking File Existence

```athon
if file_exists("config.txt") == 1 {
    print("Config file found");
} else {
    print("Config file not found");
}
```

### Example: Logging System

```athon
enum LogLevel {
    Info,
    Warning,
    Error,
}

fn log(level: int, message: string) {
    match level {
        LogLevel::Info => file_append("app.log", "[INFO] "),
        LogLevel::Warning => file_append("app.log", "[WARN] "),
        LogLevel::Error => file_append("app.log", "[ERROR] "),
    }
    file_append("app.log", message);
    file_append("app.log", "\n");
}

fn main() {
    file_write("app.log", "=== Application Log ===\n");
    log(LogLevel::Info, "Application started");
    log(LogLevel::Warning, "Low memory");
    log(LogLevel::Error, "Connection failed");
}
```

---

## Best Practices

### 1. Use Descriptive Names

```athon
// Good
let player_health = 100;
let max_score = 1000;

// Avoid
let x = 100;
let y = 1000;
```

### 2. Keep Functions Small

```athon
// Good: Small, focused function
fn calculate_area(width: int, height: int) -> int {
    return width * height;
}

// Better: Break complex logic into smaller functions
fn process_data(value: int) -> int {
    let validated = validate(value);
    let processed = transform(validated);
    return finalize(processed);
}
```

### 3. Use Pattern Matching for Clarity

```athon
// Instead of multiple if-else
match status {
    Status::Ok => handle_success(),
    Status::Error => handle_error(),
    Status::Pending => handle_pending(),
}
```

### 4. Check File Operation Results

```athon
// Always check return values
let result = file_write("data.txt", "content");
if result == 0 {
    print("Error: Failed to write file");
    return;
}
```

### 5. Use Structs for Related Data

```athon
// Good: Group related data
struct Player {
    health: int,
    score: int,
    level: int,
}

// Instead of separate variables
let player = Player { health: 100, score: 0, level: 1 };
```

### 6. Comment Complex Logic

```athon
// Calculate distance using Pythagorean theorem
fn distance(x1: int, y1: int, x2: int, y2: int) -> int {
    let dx = abs(x2 - x1);
    let dy = abs(y2 - y1);
    // Integer square root of sum of squares
    return sqrt(dx * dx + dy * dy);
}
```

---

## Complete Example

Here's a complete program that demonstrates many Athōn features:

```athon
// Game character system

struct Character {
    health: int,
    level: int,
}

enum Action {
    Attack,
    Defend,
    Heal,
}

fn create_character() -> int {
    return 100;  // Starting health
}

fn apply_action(health: int, action: int) -> int {
    let new_health = health;
    
    match action {
        Action::Attack => new_health = health - 10,
        Action::Defend => new_health = health,
        Action::Heal => new_health = min(100, health + 20),
    }
    
    return new_health;
}

fn log_action(action: int, health: int) {
    match action {
        Action::Attack => {
            file_append("game.log", "Player attacked! ");
        },
        Action::Defend => {
            file_append("game.log", "Player defended! ");
        },
        Action::Heal => {
            file_append("game.log", "Player healed! ");
        },
    }
    file_append("game.log", "\n");
}

fn main() {
    print("=== Character System Demo ===");
    
    // Initialize log
    file_write("game.log", "=== Game Log ===\n");
    
    // Create character
    let health = create_character();
    print("Character created with {} health", health);
    
    // Simulate actions
    health = apply_action(health, Action::Attack);
    log_action(Action::Attack, health);
    print("After attack: {} health", health);
    
    health = apply_action(health, Action::Heal);
    log_action(Action::Heal, health);
    print("After heal: {} health", health);
    
    print("");
    print("Check game.log for details");
}
```

---

## Next Steps

- Explore the `examples/` directory for more code samples
- Read the specification in `athon-spec/` for language details
- Check `std/` for standard library documentation
- Try building your own programs!

---

## Getting Help

- **Examples**: See `examples/` directory for working code
- **Specification**: Read `athon-spec/syntax.md` for detailed syntax
- **Standard Library**: Check `std/math/README.md` and `std/io/README.md`

Happy coding with Athōn! 🚀
