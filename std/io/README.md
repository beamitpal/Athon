# I/O Library

The Athōn I/O library provides file input/output operations.

## File Operations

### Reading Files
- `file_read(filename: string) -> string` - Reads entire file content as a string

### Writing Files
- `file_write(filename: string, content: string) -> int` - Writes content to file (overwrites if exists)
  - Returns 1 on success, 0 on failure
- `file_append(filename: string, content: string) -> int` - Appends content to file
  - Returns 1 on success, 0 on failure

### File Utilities
- `file_exists(filename: string) -> int` - Checks if file exists
  - Returns 1 if file exists, 0 otherwise

## Example

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
        
        // Read the file
        let content = file_read("output.txt");
        print("Content: {}", content);
    }
    
    // Append to file
    file_append("output.txt", "\nNew line!");
}
```

## Safety Notes

- File operations can fail (file not found, permission denied, etc.)
- Always check return values for write/append operations
- File paths are relative to the program's working directory
- In a capability-secure version, these functions would require `FileSystemCap`

## Implementation Notes

These functions are implemented as built-in functions in the bootstrap compiler and compile to C file I/O operations (fopen, fread, fwrite, etc.).
