# Memory Model

## Region-Based Memory Management

Athōn uses a region-based memory model combined with affine types. Memory is allocated in "regions" (arenas). When a region is destroyed, all objects within it are deallocated.

## Affine Types

Values in Athōn are affine by default.

- **Move Semantics**: Assigning a value moves it. The old location is invalidated.
- **Borrowing**: Values can be borrowed immutably or mutably, enforced by the compiler (similar to Rust's borrow checker but simplified for regions).

## Example

```athon
region r {
    let x = r.alloc(Point { x: 10, y: 20 });
    let y = x; // Move. 'x' is now invalid.
    // print(x); // Compile error
} // 'y' is deallocated here automatically.
```

## Thread Safety

Memory regions are thread-local by default. Sharing data between threads requires explicit "Exchange Heaps" and moving ownership across thread boundaries.
