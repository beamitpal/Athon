# Athōn API Reference

Complete reference for all built-in functions and language features.

## Table of Contents

- [Built-in Functions](#built-in-functions)
  - [I/O Functions](#io-functions)
  - [Math Functions](#math-functions)
  - [String Functions](#string-functions)
  - [Array Functions](#array-functions)
- [Keywords](#keywords)
- [Operators](#operators)
- [Types](#types)

---

## Built-in Functions

### I/O Functions

#### `print(format: string, ...args)`

Prints formatted output to stdout.

**Parameters:**
- `format`: Format string with `{}` placeholders
- `...args`: Values to substitute into placeholders

**Examples:**
```athon
print("Hello, World!");
print("x = {}", 42);
print("x = {}, y = {}", 10, 20);
```

**Notes:**
- Uses printf-style formatting internally
- `{}` placeholders are replaced with `%d` for integers
- Newlines are not automatically added

---

#### `file_read(filename: string) -> string`

Reads the entire contents of a file.

**Parameters:**
- `filename`: Path to the file to read

**Returns:**
- String containing file contents
- Empty string if file cannot be read

**Example:**
```athon
let content = file_read("data.txt");
```

**Notes:**
- Returns empty string on error (file not found, permission denied, etc.)
- Reads entire file into memory
- File paths are relative to program's working directory

---

#### `file_write(filename: string, content: string) -> int`

Writes content to a file, overwriting if it exists.

**Parameters:**
- `filename`: Path to the file to write
- `content`: String content to write

**Returns:**
- `1` on success
- `0` on failure

**Example:**
```athon
let result = file_write("output.txt", "Hello!");
if result == 1 {
    print("Success");
}
```

**Notes:**
- Creates file if it doesn't exist
- Overwrites existing file content
- Always check return value for errors

---

#### `file_append(filename: string, content: string) -> int`

Appends content to the end of a file.

**Parameters:**
- `filename`: Path to the file
- `content`: String content to append

**Returns:**
- `1` on success
- `0` on failure

**Example:**
```athon
file_append("log.txt", "New entry\n");
```

**Notes:**
- Creates file if it doesn't exist
- Preserves existing content
- Useful for logging

---

#### `file_exists(filename: string) -> int`

Checks if a file exists.

**Parameters:**
- `filename`: Path to check

**Returns:**
- `1` if file exists
- `0` if file does not exist

**Example:**
```athon
if file_exists("config.txt") == 1 {
    print("Config found");
}
```

---

### Math Functions

#### `abs(x: int) -> int`

Returns the absolute value of a number.

**Parameters:**
- `x`: Integer value

**Returns:**
- Absolute value of `x`

**Example:**
```athon
let a = abs(-5);   // 5
let b = abs(10);   // 10
```

---

#### `min(a: int, b: int) -> int`

Returns the smaller of two values.

**Parameters:**
- `a`: First value
- `b`: Second value

**Returns:**
- The smaller value

**Example:**
```athon
let m = min(10, 20);  // 10
```

---

#### `max(a: int, b: int) -> int`

Returns the larger of two values.

**Parameters:**
- `a`: First value
- `b`: Second value

**Returns:**
- The larger value

**Example:**
```athon
let m = max(10, 20);  // 20
```

---

#### `pow(base: int, exp: int) -> int`

Raises a number to a power.

**Parameters:**
- `base`: Base number
- `exp`: Exponent (must be non-negative)

**Returns:**
- `base` raised to the power of `exp`
- Returns `0` if `exp` is negative

**Example:**
```athon
let p = pow(2, 8);   // 256
let q = pow(10, 3);  // 1000
```

**Notes:**
- Only supports non-negative integer exponents
- Result may overflow for large values

---

#### `sqrt(x: int) -> int`

Calculates the integer square root (floor).

**Parameters:**
- `x`: Non-negative integer

**Returns:**
- Integer square root of `x`
- Returns `0` if `x` is negative

**Example:**
```athon
let s = sqrt(100);  // 10
let t = sqrt(50);   // 7 (floor of 7.07...)
```

**Notes:**
- Uses Newton's method for calculation
- Returns floor of the actual square root
- Returns `0` for negative inputs

---

#### `mod(a: int, b: int) -> int`

Calculates the remainder of division.

**Parameters:**
- `a`: Dividend
- `b`: Divisor

**Returns:**
- Remainder of `a / b`

**Example:**
```athon
let r = mod(17, 5);  // 2
let s = mod(20, 4);  // 0
```

**Notes:**
- Equivalent to `a % b` in C
- Behavior with negative numbers follows C semantics

---

### String Functions

#### `length(s: string) -> int`

Returns the length of a string.

**Parameters:**
- `s`: String to measure

**Returns:**
- Number of characters in the string

**Example:**
```athon
let len = length("Hello");  // 5
```

**Notes:**
- Uses C `strlen` internally
- Does not count null terminator

---

#### `concat(s1: string, s2: string) -> string`

Concatenates two strings.

**Parameters:**
- `s1`: First string
- `s2`: Second string

**Returns:**
- Concatenated string

**Example:**
```athon
let result = concat("Hello", " World");
```

**Notes:**
- Uses C `strcat` internally
- Requires proper buffer management in production code

---

#### `compare(s1: string, s2: string) -> int`

Compares two strings lexicographically.

**Parameters:**
- `s1`: First string
- `s2`: Second string

**Returns:**
- `0` if strings are equal
- Negative if `s1 < s2`
- Positive if `s1 > s2`

**Example:**
```athon
let cmp = compare("abc", "abc");  // 0
```

**Notes:**
- Uses C `strcmp` internally
- Case-sensitive comparison

---

### Array Functions

#### `array_length(arr: array) -> int`

Returns the length of an array.

**Parameters:**
- `arr`: Array to measure

**Returns:**
- Number of elements in the array

**Example:**
```athon
let numbers = [1, 2, 3, 4, 5];
let len = array_length(numbers);  // 5
```

**Notes:**
- Compile-time calculation using `sizeof`
- Only works with array literals

---

## Keywords

### Control Flow

- `if` - Conditional execution
- `else` - Alternative branch
- `while` - Loop while condition is true
- `for` - Loop over a range
- `in` - Used in for loops
- `match` - Pattern matching
- `return` - Return from function

### Declarations

- `fn` - Function definition
- `let` - Variable declaration
- `struct` - Structure definition
- `enum` - Enumeration definition

### Literals

- `true` - Boolean true value
- `false` - Boolean false value

### Reserved (Future Use)

- `loop` - Infinite loop
- `break` - Break from loop
- `continue` - Continue to next iteration
- `cap` - Capability token
- `region` - Memory region
- `pub` - Public visibility

---

## Operators

### Arithmetic

| Operator | Description | Example |
|----------|-------------|---------|
| `+` | Addition | `a + b` |
| `-` | Subtraction | `a - b` |
| `*` | Multiplication | `a * b` |
| `/` | Division | `a / b` |
| `-` (unary) | Negation | `-x` |

### Comparison

| Operator | Description | Example |
|----------|-------------|---------|
| `==` | Equal to | `a == b` |
| `!=` | Not equal to | `a != b` |
| `<` | Less than | `a < b` |
| `>` | Greater than | `a > b` |
| `<=` | Less than or equal | `a <= b` |
| `>=` | Greater than or equal | `a >= b` |

### Logical

| Operator | Description | Example |
|----------|-------------|---------|
| `&&` | Logical AND | `a && b` |
| `\|\|` | Logical OR | `a \|\| b` |
| `!` | Logical NOT | `!a` |

### Other

| Operator | Description | Example |
|----------|-------------|---------|
| `=` | Assignment | `x = 5` |
| `.` | Member access | `point.x` |
| `::` | Enum variant | `Color::Red` |
| `[]` | Array indexing | `arr[0]` |
| `..` | Range (in for loops) | `0..10` |
| `=>` | Match arm | `pattern => expr` |

---

## Types

### Basic Types

#### `int`

Signed integer type.

**Range:** Platform-dependent (typically 32-bit)

**Literals:**
```athon
let x = 42;
let y = -10;
let z = 0;
```

---

#### `bool`

Boolean type with two values: `true` and `false`.

**Literals:**
```athon
let flag = true;
let done = false;
```

**Notes:**
- Internally represented as `int` (0 for false, 1 for true)
- Used in conditions and logical operations

---

#### `string`

String type for text data.

**Literals:**
```athon
let s = "Hello, World!";
let empty = "";
```

**Notes:**
- Internally represented as `const char*`
- Immutable in current implementation
- Null-terminated C strings

---

### Composite Types

#### Arrays

Fixed-size sequences of values.

**Syntax:**
```athon
let arr = [1, 2, 3, 4, 5];
let first = arr[0];
```

**Notes:**
- All elements must be the same type
- Size is fixed at compile time
- Zero-indexed

---

#### Structs

User-defined composite types.

**Syntax:**
```athon
struct Point {
    x: int,
    y: int,
}

let p = Point { x: 10, y: 20 };
let x_val = p.x;
```

**Notes:**
- Can contain multiple fields of different types
- Passed by value to functions
- Can be used as function parameters and return types

---

#### Enums

User-defined enumeration types.

**Syntax:**
```athon
enum Color {
    Red,
    Green,
    Blue,
}

let c = Color::Red;
```

**Notes:**
- Variants are simple tags (no associated data in current version)
- Internally represented as integers
- Can be used in pattern matching

---

## Pattern Matching

### Patterns

#### Literal Pattern

Matches specific values.

```athon
match x {
    0 => print("Zero"),
    1 => print("One"),
    42 => print("Forty-two"),
}
```

---

#### Enum Pattern

Matches enum variants.

```athon
match color {
    Color::Red => print("Red"),
    Color::Green => print("Green"),
    Color::Blue => print("Blue"),
}
```

---

#### Wildcard Pattern

Matches anything (catch-all).

```athon
match x {
    0 => print("Zero"),
    _ => print("Other"),
}
```

**Notes:**
- Must be the last pattern
- Ensures exhaustive matching

---

## Error Handling

Currently, Athōn uses return codes for error handling:

```athon
let result = file_write("data.txt", "content");
if result == 0 {
    print("Error: Failed to write file");
    return;
}
```

**Best Practices:**
- Always check return values from file operations
- Use enums to represent different error states
- Log errors for debugging

---

## Compilation Model

Athōn compiles to C code:

1. **Parse** - Athōn source → AST
2. **Generate** - AST → C code
3. **Compile** - C code → Executable

**Generated Code:**
- Helper functions for math and I/O
- Struct definitions
- Enum definitions (as C enums)
- Function definitions
- Main function

---

## Limitations (Current Version)

1. **No generics** - Types must be concrete
2. **No closures** - Functions cannot capture variables
3. **No heap allocation** - All data is stack-allocated
4. **Limited string operations** - Basic operations only
5. **No module system** - Single-file programs
6. **Integer-only math** - No floating-point support
7. **No error types** - Return codes only

---

## Future Features

Planned features for future versions:

- Module system
- Generic types
- Option and Result types
- Capability-based security
- Memory regions
- Trait system
- More standard library functions

---

For more information, see:
- [Language Guide](language-guide.md)
- [Syntax Specification](../athon-spec/syntax.md)
- [Standard Library Documentation](../std/)
