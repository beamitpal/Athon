# Athōn Examples Index

Complete catalog of all example programs with descriptions and learning objectives.

## Basic Examples

### hello.at
**Description:** Classic "Hello, World!" program  
**Concepts:** Basic syntax, print function, main function  
**Difficulty:** Beginner

```athon
fn main() {
    print("Hello from Athon Bootstrap!");
}
```

---

### variables.at
**Description:** Variable declaration and arithmetic  
**Concepts:** Variables, let statements, arithmetic operators  
**Difficulty:** Beginner

**Key Concepts:**
- Variable declaration with `let`
- Basic arithmetic operations
- Variable reassignment

---

### arithmetic.at
**Description:** Arithmetic operations demonstration  
**Concepts:** Addition, subtraction, multiplication, division  
**Difficulty:** Beginner

**Key Concepts:**
- All four basic arithmetic operators
- Order of operations
- Printing results

---

### comments.at
**Description:** Comment syntax examples  
**Concepts:** Single-line and multi-line comments  
**Difficulty:** Beginner

**Key Concepts:**
- `//` for single-line comments
- `/* */` for multi-line comments
- Documenting code

---

## Control Flow Examples

### control_flow.at
**Description:** If/else statements  
**Concepts:** Conditional execution, comparison operators  
**Difficulty:** Beginner

**Key Concepts:**
- `if` statements
- `else` clauses
- Comparison operators

---

### booleans.at
**Description:** Boolean logic and operators  
**Concepts:** Boolean values, logical operators (&&, ||, !)  
**Difficulty:** Beginner

**Key Concepts:**
- `true` and `false` literals
- Logical AND (`&&`)
- Logical OR (`||`)
- Logical NOT (`!`)

---

### loops.at
**Description:** While loop basics  
**Concepts:** While loops, loop counters  
**Difficulty:** Beginner

**Key Concepts:**
- `while` loop syntax
- Loop conditions
- Loop counters

---

### for_loops.at
**Description:** For loop with ranges  
**Concepts:** For loops, ranges, nested loops  
**Difficulty:** Beginner

**Key Concepts:**
- `for` loop syntax
- Range notation (`0..5`)
- Nested loops

---

## Function Examples

### functions.at
**Description:** Function definition and calling  
**Concepts:** Functions, parameters, return values  
**Difficulty:** Beginner

**Key Concepts:**
- Function definition with `fn`
- Parameters and types
- Return values

---

### factorial.at
**Description:** Recursive factorial function  
**Concepts:** Recursion, function calls  
**Difficulty:** Intermediate

**Key Concepts:**
- Recursive function calls
- Base case and recursive case
- Mathematical computation

---

## Data Structure Examples

### arrays.at
**Description:** Array basics  
**Concepts:** Array literals, indexing  
**Difficulty:** Beginner

**Key Concepts:**
- Array literal syntax `[1, 2, 3]`
- Array indexing `arr[0]`
- Accessing elements

---

### array_test.at
**Description:** Array operations  
**Concepts:** Array length, iteration  
**Difficulty:** Beginner

**Key Concepts:**
- `array_length()` function
- Iterating over arrays
- Array bounds

---

### structs.at
**Description:** Struct definition and usage  
**Concepts:** Structs, member access  
**Difficulty:** Intermediate

**Key Concepts:**
- Struct definition
- Struct literals
- Member access with `.`

---

### enums.at
**Description:** Enum definition and usage  
**Concepts:** Enums, enum variants  
**Difficulty:** Intermediate

**Key Concepts:**
- Enum definition
- Enum variants with `::`
- Comparing enum values

---

## Pattern Matching Examples

### match_test.at
**Description:** Basic pattern matching  
**Concepts:** Match statements, patterns  
**Difficulty:** Intermediate

**Key Concepts:**
- `match` statement syntax
- Literal patterns
- Wildcard pattern `_`

---

### match_simple.at
**Description:** Enum pattern matching  
**Concepts:** Matching enum variants  
**Difficulty:** Intermediate

**Key Concepts:**
- Enum variant patterns
- Exhaustive matching
- Pattern arms

---

### match_comprehensive.at
**Description:** Advanced pattern matching  
**Concepts:** Complex patterns, blocks, assignments  
**Difficulty:** Advanced

**Key Concepts:**
- Match with blocks
- Assignments in match arms
- Multiple patterns
- Return values from match

---

### match_integration.at
**Description:** Pattern matching with other features  
**Concepts:** Integration with structs, enums, functions  
**Difficulty:** Advanced

**Key Concepts:**
- Combining pattern matching with structs
- Using match in functions
- Calculator example

---

## String Examples

### string_types.at
**Description:** String variable basics  
**Concepts:** String literals, string variables  
**Difficulty:** Beginner

**Key Concepts:**
- String literals
- String variables
- String type

---

### string_ops.at
**Description:** String operations  
**Concepts:** String length  
**Difficulty:** Beginner

**Key Concepts:**
- `length()` function
- String manipulation

---

### string_funcs.at
**Description:** String functions  
**Concepts:** String comparison  
**Difficulty:** Intermediate

**Key Concepts:**
- `compare()` function
- String comparison

---

### formatting.at
**Description:** Printf-style formatting  
**Concepts:** Format strings, placeholders  
**Difficulty:** Beginner

**Key Concepts:**
- Format strings with `{}`
- Multiple arguments
- Formatted output

---

## Math Library Examples

### math.at
**Description:** Complete math library demonstration  
**Concepts:** All math functions  
**Difficulty:** Intermediate

**Key Concepts:**
- `abs()` - Absolute value
- `min()` / `max()` - Min/max values
- `pow()` - Power function
- `sqrt()` - Square root
- `mod()` - Modulo operation

**Sections:**
- Absolute value tests
- Min/max tests
- Power calculations
- Square root calculations
- Modulo operations
- Practical examples

---

### geometry.at
**Description:** Geometry calculator using math library  
**Concepts:** Math + structs integration  
**Difficulty:** Advanced

**Key Concepts:**
- Distance calculation
- Rectangle area and perimeter
- Circle calculations (approximated)
- Triangle area
- Pythagorean triples
- Combining structs with math

---

## File I/O Examples

### file_io_simple.at
**Description:** Basic file operations  
**Concepts:** Reading, writing, checking files  
**Difficulty:** Intermediate

**Key Concepts:**
- `file_write()` - Write to file
- `file_exists()` - Check file existence
- `file_append()` - Append to file
- Error checking with return codes

---

### file_logger.at
**Description:** File-based logging system  
**Concepts:** Logging, file I/O, pattern matching  
**Difficulty:** Advanced

**Key Concepts:**
- Log levels with enums
- Pattern matching for log formatting
- Appending log entries
- Structured logging

---

### data_processor.at
**Description:** Data processing with file output  
**Concepts:** Processing data, writing results  
**Difficulty:** Advanced

**Key Concepts:**
- Processing pipeline
- Status tracking with enums
- File output generation
- Summary statistics

---

## Comprehensive Examples

### showcase.at
**Description:** Complete language feature showcase  
**Concepts:** All major features combined  
**Difficulty:** Advanced

**Features Demonstrated:**
- Structs (Player, Enemy)
- Enums (Status, Operation)
- Functions with parameters
- Pattern matching
- Math library
- Control flow
- Loops
- Printf formatting

**Sections:**
- Character creation
- Status handling
- Level up system
- Score calculation
- Math function tests
- Statistics generation
- Battle simulation

**Learning Value:**
- See how all features work together
- Real-world game simulation
- Best practices demonstration

---

## Learning Paths

### Path 1: Complete Beginner
1. hello.at
2. variables.at
3. arithmetic.at
4. comments.at
5. control_flow.at
6. loops.at
7. functions.at

### Path 2: Data Structures
1. arrays.at
2. array_test.at
3. structs.at
4. enums.at

### Path 3: Advanced Features
1. match_test.at
2. match_simple.at
3. match_comprehensive.at
4. match_integration.at

### Path 4: Standard Library
1. string_ops.at
2. formatting.at
3. math.at
4. geometry.at

### Path 5: File I/O
1. file_io_simple.at
2. file_logger.at
3. data_processor.at

### Path 6: Complete Projects
1. geometry.at
2. file_logger.at
3. data_processor.at
4. showcase.at

---

## By Difficulty

### Beginner (11 examples)
- hello.at
- variables.at
- arithmetic.at
- comments.at
- control_flow.at
- booleans.at
- loops.at
- for_loops.at
- functions.at
- arrays.at
- array_test.at
- string_types.at
- string_ops.at
- formatting.at

### Intermediate (8 examples)
- factorial.at
- structs.at
- enums.at
- match_test.at
- match_simple.at
- string_funcs.at
- math.at
- file_io_simple.at

### Advanced (7 examples)
- match_comprehensive.at
- match_integration.at
- geometry.at
- file_logger.at
- data_processor.at
- showcase.at

---

## By Feature

### Variables & Types
- variables.at
- arithmetic.at
- string_types.at

### Control Flow
- control_flow.at
- booleans.at
- loops.at
- for_loops.at

### Functions
- functions.at
- factorial.at

### Data Structures
- arrays.at
- array_test.at
- structs.at
- enums.at

### Pattern Matching
- match_test.at
- match_simple.at
- match_comprehensive.at
- match_integration.at

### Standard Library
- string_ops.at
- string_funcs.at
- formatting.at
- math.at
- geometry.at

### File I/O
- file_io_simple.at
- file_logger.at
- data_processor.at

### Comprehensive
- showcase.at

---

## Running Examples

To run any example:

```bash
# Compile Athōn to C
./athon-boot examples/example_name.at > output.c

# Compile C to executable
gcc output.c -o program

# Run the program
./program
```

Or use the one-liner:

```bash
./athon-boot examples/example_name.at > /tmp/test.c && gcc /tmp/test.c -o /tmp/test && /tmp/test
```

---

## Total Statistics

- **Total Examples:** 31
- **Beginner:** 14 examples
- **Intermediate:** 8 examples
- **Advanced:** 7 examples
- **Lines of Code:** ~2000+ lines across all examples
- **Features Covered:** All major language features

---

For more information:
- [Language Guide](language-guide.md) - Learn Athōn from scratch
- [API Reference](api-reference.md) - Complete function reference
- [Syntax Specification](../athon-spec/syntax.md) - Detailed syntax rules
