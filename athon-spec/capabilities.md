# Capabilities

## Concept

In Athōn, a "capability" is a linear or affine type that represents the authority to perform an action. Functions that perform I/O, memory allocation, or system calls must take the relevant capability as an argument.

## Invariants

1. Capabilities cannot be forged; they are created only by the `main` entry point or derived from parent capabilities.
2. Capabilities are linear (must be used exactly once) or affine (used at most once), preventing use-after-free of authority.

## Syntax (Pseudo-Athōn)

```athon
// A function requiring network access
fn fetch_url(net: NetworkCap, url: String) -> Result<Data, Error> {
    // ... uses 'net' to open socket
}

// A function that cannot access the network
fn pure_computation(x: Int, y: Int) -> Int {
    // Compilation error if this tries to use network!
    return x + y;
}
```

## Examples

### 1. File System Access

```athon
fn main(sys: SystemCap) {
    let (fs, rest) = sys.split_fs();
    let file = fs.open("/tmp/test.txt");
    // 'rest' still holds other capabilities
}
```

### 2. Memory Allocation

```athon
fn process_data(alloc: AllocatorCap, data: Bytes) {
    let buffer = alloc.allocate(1024);
    // ...
    alloc.deallocate(buffer);
}
```

### 3. Network Restriction

```athon
fn untrusted_plugin(data: Data) {
    // No capabilities passed.
    // This function is guaranteed to be side-effect free regarding I/O.
}
```

### 4. Capability Attenuation

```athon
fn restricted_view(fs: FileSystemCap) {
    let read_only_fs = fs.attenuate(Permissions::READ_ONLY);
    // Can read, but cannot write.
}
```
