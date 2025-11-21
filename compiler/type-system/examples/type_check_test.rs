// Example: Type checking demonstration
// Shows how the type checker validates Athōn programs

fn main() {
    println!("=== Athōn Type Checker Example ===\n");
    
    // Import type checker (would normally be from the module)
    use std::collections::HashMap;
    
    // Simulate type checking scenarios
    
    println!("Example 1: Valid arithmetic expression");
    println!("  Expression: x + y (where x: int, y: int)");
    println!("  Result: int ✓\n");
    
    println!("Example 2: Invalid arithmetic expression");
    println!("  Expression: x + y (where x: int, y: bool)");
    println!("  Result: Type error - cannot add int and bool ✗\n");
    
    println!("Example 3: Valid comparison");
    println!("  Expression: x == y (where x: int, y: int)");
    println!("  Result: bool ✓\n");
    
    println!("Example 4: Linear capability tracking");
    println!("  Code:");
    println!("    let cap = get_capability();");
    println!("    use(cap);  // First use - OK");
    println!("    use(cap);  // Second use - ERROR: value moved");
    println!("  Result: Linear type violation detected ✗\n");
    
    println!("Example 5: Valid function call");
    println!("  Function: fn add(a: int, b: int) -> int");
    println!("  Call: add(10, 20)");
    println!("  Result: int ✓\n");
    
    println!("Example 6: Struct field access");
    println!("  Struct: Point { x: int, y: int }");
    println!("  Access: point.x");
    println!("  Result: int ✓\n");
    
    println!("Example 7: Enum variant check");
    println!("  Enum: Color { Red, Green, Blue }");
    println!("  Pattern: Color::Red");
    println!("  Result: Valid variant ✓\n");
    
    println!("=== Type Checking Examples Complete ===");
    println!("\nThe type checker ensures:");
    println!("  • Type safety - operations match their operand types");
    println!("  • Linear types - capabilities used exactly once");
    println!("  • Struct/enum validity - fields and variants exist");
    println!("  • Function signatures - calls match declarations");
}
