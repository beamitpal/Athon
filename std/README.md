# Standard Library (std)

The Athōn Standard Library is minimal, modular, and capability-gated.

## Current Status

### Implemented (Bootstrap Stage)

#### Math Library (`std/math/`)
Mathematical operations for integer arithmetic:
- `abs(x)` - Absolute value
- `min(a, b)` - Minimum of two values
- `max(a, b)` - Maximum of two values
- `pow(base, exp)` - Power function
- `sqrt(x)` - Integer square root
- `mod(a, b)` - Modulo operation

See [std/math/README.md](math/README.md) for details.

#### I/O Library (`std/io/`)
File input/output operations:
- `file_read(filename)` - Read file contents
- `file_write(filename, content)` - Write to file
- `file_append(filename, content)` - Append to file
- `file_exists(filename)` - Check file existence

See [std/io/README.md](io/README.md) for details.

#### String Operations
Basic string manipulation:
- `length(s)` - String length
- `concat(s1, s2)` - String concatenation
- `compare(s1, s2)` - String comparison

#### Array Operations
Array utilities:
- `array_length(arr)` - Array length

#### I/O Operations
Console output:
- `print(format, ...args)` - Printf-style formatted output

### Planned (Future Stages)

#### Core Library (`std/core/`)
Fundamental types (no allocation, no I/O):
- `Option<T>` - Optional values
- `Result<T, E>` - Error handling
- `Bool`, `Int`, `Char` - Basic types
- Comparison traits
- Arithmetic traits

#### Allocation Library (`std/alloc/`)
Memory allocation primitives (requires `AllocatorCap`):
- `Box<T>` - Heap-allocated value
- `Vec<T>` - Dynamic array
- `String` - Owned string
- Memory management functions

#### Collections Library (`std/collections/`)
Dynamic data structures (requires `AllocatorCap`):
- `Vec<T>` - Dynamic array
- `HashMap<K, V>` - Hash map
- `HashSet<T>` - Hash set
- `LinkedList<T>` - Linked list

## Library Organization

```
std/
├── README.md           # This file
├── core/               # Fundamental types (planned)
│   └── README.md
├── alloc/              # Memory allocation (planned)
│   └── README.md
├── collections/        # Data structures (planned)
│   └── README.md
├── io/                 # I/O operations (implemented)
│   └── README.md
└── math/               # Math functions (implemented)
    └── README.md
```

## Usage Examples

### Math Library

```athon
fn main() {
    let x = abs(-5);        // 5
    let y = min(10, 20);    // 10
    let z = max(10, 20);    // 20
    let p = pow(2, 8);      // 256
    let s = sqrt(100);      // 10
    let m = mod(17, 5);     // 2
}
```

### File I/O

```athon
fn main() {
    // Write to file
    let result = file_write("data.txt", "Hello, World!");
    
    if result == 1 {
        print("File written successfully");
    }
    
    // Check if file exists
    if file_exists("data.txt") == 1 {
        print("File exists");
    }
    
    // Append to file
    file_append("data.txt", "\nNew line");
}
```

### String Operations

```athon
fn main() {
    let s = "Hello";
    let len = length(s);           // 5
    
    let s1 = "Hello";
    let s2 = "World";
    let cmp = compare(s1, s2);     // Non-zero if different
}
```

## Design Principles

### 1. Minimalism
Only include what's necessary. Every function must justify its existence.

### 2. Capability-Gated
Functions that perform I/O or allocation require explicit capability tokens:

```athon
// Future: Capability-gated I/O
fn read_config(fs: FileSystemCap) -> Config {
    let content = fs.read_file("config.txt");
    parse_config(content)
}
```

### 3. No Hidden Allocations
All allocations must be explicit and visible in the type system.

### 4. Zero-Cost Abstractions
Abstractions should compile to efficient code with no runtime overhead.

### 5. Auditable
All standard library code must be simple enough to audit manually.

## Implementation Notes

### Bootstrap Stage (Current)
- Functions are built-in to the compiler
- Implemented as C helper functions
- No capability checking (bootstrap only)
- Integer-only arithmetic

### Future Stages
- Standard library written in Athōn
- Capability tokens enforced
- Generic types supported
- Trait-based design

## Future Option Type Example

```athon
// std/core/option.at (planned)

pub enum Option<T> {
    Some(T),
    None,
}

impl Option<T> {
    pub fn unwrap(self) -> T {
        match self {
            Option::Some(val) => val,
            Option::None => panic("Called unwrap on None"),
        }
    }
    
    pub fn is_some(self) -> bool {
        match self {
            Option::Some(_) => true,
            Option::None => false,
        }
    }
    
    pub fn map<U>(self, f: fn(T) -> U) -> Option<U> {
        match self {
            Option::Some(val) => Option::Some(f(val)),
            Option::None => Option::None,
        }
    }
}
```

## Contributing

When adding to the standard library:
1. Justify the need for the function
2. Consider capability requirements
3. Write comprehensive documentation
4. Add example code
5. Ensure zero-cost abstraction
6. Make it auditable

See [CONTRIBUTING.md](../CONTRIBUTING.md) for details.

## References

- [Language Guide](../docs/language-guide.md)
- [API Reference](../docs/api-reference.md)
- [Capability Security](../docs/capability-security.md)
