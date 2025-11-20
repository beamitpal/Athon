# AIR Format Specification

## Example: Hello World

```air
module main

fn @main(%sys: Cap) -> void {
block0:
    %str = const_string "Hello, World!\n"
    %stdout = call @get_stdout(%sys)
    call @write(%stdout, %str)
    ret void
}
```

## Syntax

- Global identifiers start with `@`.
- Local registers start with `%`.
- Types are explicit (e.g., `i32`, `ptr`, `cap`).
