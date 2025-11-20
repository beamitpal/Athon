# Syntax Specification

Athōn's syntax is C-family inspired but stripped of ambiguities.

## Grammar Excerpt (EBNF)

```ebnf
program       ::= { item }
item          ::= function_def | struct_def | const_def
function_def  ::= "fn" identifier "(" [params] ")" ["->" type] block
params        ::= param { "," param }
param         ::= identifier ":" type
type          ::= "int" | "bool"
block         ::= "{" { statement } "}"
statement     ::= let_stmt | assign_stmt | if_stmt | while_stmt | return_stmt | expr_stmt
let_stmt      ::= "let" identifier [":" type] "=" expr ";"
assign_stmt   ::= identifier "=" expr ";"
if_stmt       ::= "if" expr block ["else" block]
while_stmt    ::= "while" expr block
return_stmt   ::= "return" [expr] ";"
expr_stmt     ::= expr ";"
expr          ::= logical_or
logical_or    ::= logical_and { "||" logical_and }
logical_and   ::= comparison { "&&" comparison }
comparison    ::= additive { comp_op additive }
comp_op       ::= "==" | "!=" | "<" | ">" | "<=" | ">="
additive      ::= multiplicative { ("+" | "-") multiplicative }
multiplicative::= unary { ("*" | "/") unary }
unary         ::= "!" unary | primary
primary       ::= identifier | literal | function_call | "(" expr ")"
literal       ::= integer | boolean | string
integer       ::= digit { digit }
boolean       ::= "true" | "false"
string        ::= '"' { char } '"'
function_call ::= identifier "(" [args] ")"
args          ::= expr { "," expr }
```

## Keywords

`fn`, `let`, `if`, `else`, `while`, `return`, `true`, `false`, `struct`, `enum`, `match`, `loop`, `break`, `continue`, `cap` (capability), `region`.

## Pattern Matching

Pattern matching allows exhaustive checking of values against patterns. Match statements provide a clean way to handle different cases based on the value of an expression.

### Match Statement Syntax

```athon
match value {
    pattern1 => expression,
    pattern2 => {
        statement1;
        statement2;
    },
    _ => default_expression,
}
```

### Patterns

- **Literal patterns**: `0`, `1`, `42`, `true`, `false`
- **Enum variant patterns**: `Color::Red`, `Status::Ok`
- **Wildcard pattern**: `_` (matches anything, used as catch-all)

### Match Arm Bodies

Match arms can have either:
- A single expression (no semicolon needed): `pattern => expression`
- A block with multiple statements: `pattern => { stmt1; stmt2; }`

### Examples

#### Basic Enum Matching

```athon
enum Color {
    Red,
    Green,
    Blue,
}

fn main() {
    let c = Color::Red;
    
    match c {
        Color::Red => print("Red!"),
        Color::Green => print("Green!"),
        Color::Blue => print("Blue!"),
    }
}
```

#### Number Matching with Wildcard

```athon
fn classify(n: int) {
    match n {
        0 => print("Zero"),
        1 => print("One"),
        2 => print("Two"),
        _ => print("Other number"),
    }
}
```

#### Match with Blocks

```athon
enum Status {
    Ok,
    Error,
}

fn handle_status(s: int) {
    match s {
        Status::Ok => {
            print("Success!");
            print("Everything is fine");
        },
        Status::Error => {
            print("Error occurred");
            print("Please try again");
        },
    }
}
```

#### Match with Assignments

```athon
fn get_value(n: int) -> int {
    let result = 0;
    match n {
        0 => result = 10,
        1 => result = 20,
        _ => result = 30,
    }
    return result;
}
```

## Types

- **int**: Integer numbers
- **bool**: Boolean values (true/false)

## Literals

- **Integers**: `0`, `42`, `1000`
- **Booleans**: `true`, `false`
- **Strings**: `"Hello"`, `"World"`

## Operators

- **Arithmetic**: `+` (addition), `-` (subtraction), `*` (multiplication), `/` (division)
- **Comparison**: `==` (equal), `!=` (not equal), `<` (less than), `>` (greater than), `<=` (less or equal), `>=` (greater or equal)
- **Logical**: `&&` (and), `||` (or), `!` (not)
- **Assignment**: `=` (assign value)

## Control Flow

### If Statement

```athon
if x > 10 {
    print("big");
}
```

### If-Else Statement

```athon
if x == 5 {
    print("five");
} else {
    print("not five");
}
```

### While Loop

```athon
let i = 0;
while i < 5 {
    print(i);
    i = i + 1;
}
```

## Boolean Logic

### Logical AND

```athon
if x > 0 && x < 100 {
    print("valid range");
}
```

### Logical OR

```athon
if x == 0 || x == 1 {
    print("binary");
}
```

### Logical NOT

```athon
if !flag {
    print("flag is false");
}
```

## Comments

- `//` for single line.
- `/* ... */` for block comments.

## Standard Library

### Math Functions

Athōn provides built-in mathematical functions:

- `abs(x: int) -> int` - Returns the absolute value of x
- `min(a: int, b: int) -> int` - Returns the minimum of two values
- `max(a: int, b: int) -> int` - Returns the maximum of two values
- `pow(base: int, exp: int) -> int` - Returns base raised to the power of exp
- `sqrt(x: int) -> int` - Returns the integer square root of x (floor)
- `mod(a: int, b: int) -> int` - Returns the remainder of a divided by b

#### Examples

```athon
fn main() {
    let x = abs(-5);        // x = 5
    let y = min(10, 20);    // y = 10
    let z = max(10, 20);    // z = 20
    let p = pow(2, 8);      // p = 256
    let s = sqrt(100);      // s = 10
    let m = mod(17, 5);     // m = 2
}
```

### String Functions

- `length(s: string) -> int` - Returns the length of a string
- `concat(s1: string, s2: string) -> string` - Concatenates two strings
- `compare(s1: string, s2: string) -> int` - Compares two strings (returns 0 if equal)

### File I/O Functions

- `file_read(filename: string) -> string` - Reads entire file content as a string
- `file_write(filename: string, content: string) -> int` - Writes content to file (returns 1 on success, 0 on failure)
- `file_append(filename: string, content: string) -> int` - Appends content to file (returns 1 on success, 0 on failure)
- `file_exists(filename: string) -> int` - Checks if file exists (returns 1 if exists, 0 otherwise)

#### File I/O Example

```athon
fn main() {
    // Write to a file
    let result = file_write("output.txt", "Hello, World!");
    if result == 1 {
        print("File written successfully");
    }
    
    // Check if file exists
    if file_exists("output.txt") == 1 {
        print("File exists!");
    }
    
    // Append to file
    file_append("output.txt", "\nNew line!");
}
```
