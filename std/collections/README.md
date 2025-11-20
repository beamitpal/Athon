# std/collections

Common data structures:

- `Vec<T>`: Growable array.
- `HashMap<K, V>`: Hash map.

All collections require an allocator to be passed at construction:

```athon
let v = Vec::new(alloc_cap);
```
