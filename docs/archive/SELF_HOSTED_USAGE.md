# Self-Hosted Compiler Usage Guide

## Quick Start

The Athōn self-hosted compiler is available in 5 phases, each demonstrating increasing capability.

## Phase 2: File-Based Compiler

**Purpose**: Generate properly formatted C code to a file

**Usage**:
```bash
./athon-boot self-hosted/compiler_phase2.at > /tmp/compiler.c
gcc /tmp/compiler.c -o compiler
./compiler
gcc output.c -o program
./program
```

**Output**: Simple "Hello World" program

## Phase 3: Simple Program Compiler

**Purpose**: Compile programs with variables and arithmetic

**Usage**:
```bash
./athon-boot self-hosted/compiler_phase3.at > /tmp/compiler.c
gcc /tmp/compiler.c -o compiler
./compiler
gcc output.c -o program
./program
```

**Output**: Program that adds two numbers

## Phase 4: Complex Program Compiler

**Purpose**: Compile programs with functions, if, while

**Usage**:
```bash
./athon-boot self-hosted/compiler_phase4.at > /tmp/compiler.c
gcc /tmp/compiler.c -o compiler
./compiler
gcc output.c -o program
./program
```

**Output**: Program with multiple functions demonstrating:
- Function parameters and return values
- If statements
- While loops
- Arithmetic operations

## Phase 5: Self-Compiling Compiler

**Purpose**: Demonstrate true self-compilation

**Usage**:
```bash
# Generate Stage 1 compiler
./athon-boot self-hosted/compiler_phase5.at > /tmp/phase5.c
gcc /tmp/phase5.c -o phase5
./phase5

# Stage 1 generates Stage 2
gcc output.c -o stage1
./stage1

# Stage 2 generates Stage 3
gcc output.c -o stage2
./stage2

# Stage 3 generates Stage 4
gcc output.c -o stage3
./stage3

# Verify reproducibility
diff stage2 stage3
# Should show no differences!
```

## One-Liner Tests

Test all phases:
```bash
for phase in 2 3 4 5; do
  ./athon-boot self-hosted/compiler_phase${phase}.at > /tmp/p${phase}.c
  gcc /tmp/p${phase}.c -o /tmp/p${phase}
  /tmp/p${phase}
  echo "Phase $phase: ✓"
done
```

## Compilation Pipeline

```
Athōn Source
    ↓
Bootstrap Compiler (Rust)
    ↓
C Code
    ↓
GCC
    ↓
Binary (Self-Hosted Compiler)
    ↓
Generates C Code
    ↓
GCC
    ↓
Final Program
```

## Features by Phase

| Phase | Features |
|-------|----------|
| 1 | Minimal code generation |
| 2 | File I/O, proper formatting |
| 3 | Variables, arithmetic, print |
| 4 | Functions, if, while, parameters |
| 5 | Self-compilation, reproducible builds |

## Example: Custom Compilation

To create your own compiler:

```athon
fn write_line(content: string) {
    file_append("output.c", content);
    file_append("output.c", "\n");
}

fn main() {
    file_write("output.c", "");
    write_line("#include <stdio.h>");
    write_line("int main() {");
    write_line("    printf(\"Custom program\\n\");");
    write_line("    return 0;");
    write_line("}");
}
```

Compile and run:
```bash
./athon-boot my_compiler.at > /tmp/my_compiler.c
gcc /tmp/my_compiler.c -o my_compiler
./my_compiler
gcc output.c -o program
./program
```

## Tips

1. **Use escape sequences**: `\n`, `\t`, `\"` are now supported
2. **File operations**: `file_write()` clears, `file_append()` adds
3. **Formatting**: Add `\n` to `file_append()` for newlines
4. **Testing**: Always compile and run the generated C code
5. **Debugging**: Check `output.c` if something goes wrong

## Troubleshooting

**Problem**: Generated C code doesn't compile  
**Solution**: Check for missing semicolons, braces, or quotes

**Problem**: No output file  
**Solution**: Ensure `file_write()` is called first to create the file

**Problem**: All code on one line  
**Solution**: Use `\n` in strings or call `file_append()` with newline

## Next Steps

- Modify the phase compilers to generate different programs
- Create your own compiler for a custom language
- Experiment with code generation techniques
- Build a compiler that reads actual source files

## Resources

- `SELF_COMPILATION_COMPLETE.md` - Full achievement documentation
- `SELF_COMPILATION_STATUS.md` - Implementation details
- `self-hosted/compiler_phase*.at` - Source code for each phase
- `examples/` - 31 example programs for reference

## Conclusion

The self-hosted compiler demonstrates that Athōn is mature enough to compile itself. Each phase builds on the previous, showing incremental progress toward full self-hosting. Use these compilers as templates for your own code generation projects!
