# Math Library

The Athōn math library provides common mathematical functions.

## Functions

### Basic Operations
- `abs(x: int) -> int` - Absolute value
- `min(a: int, b: int) -> int` - Minimum of two values
- `max(a: int, b: int) -> int` - Maximum of two values
- `pow(base: int, exp: int) -> int` - Power (base^exp)

### Advanced Operations
- `sqrt(x: int) -> int` - Integer square root (floor)
- `mod(a: int, b: int) -> int` - Modulo operation

## Example

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

## Implementation Notes

These functions are implemented as built-in functions in the bootstrap compiler and compile to efficient C code.
