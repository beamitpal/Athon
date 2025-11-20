# Type System Rules

## Capability Safety

1. **Linearity**: A linear capability must be consumed exactly once.
   - `fn use(c: Cap)` -> `c` is moved into `use`. Caller cannot use `c` again.
2. **Affinity**: An affine capability can be used at most once (can be dropped).
3. **Borrowing**: Capabilities can be borrowed `&mut` or `&`.

## Type Checking Algorithm

1. **Resolution**: Resolve all type names to definitions.
2. **Capability Check**:
   - Track the state of all linear variables.
   - Ensure no path exists where a linear variable is dropped without being consumed.
   - Ensure no path uses a moved variable.
3. **Region Check**:
   - Verify that references do not outlive their regions.

## Pseudocode

```
check_function(func):
  context = new_context()
  for param in func.params:
    context.add(param.name, param.type, state=ALIVE)

  analyze_block(func.body, context)

  for var in context:
    if var.is_linear() and var.state == ALIVE:
      error("Linear variable not consumed: " + var.name)
```
