use std::env;
use std::fs;
use std::io::{self, Write};
use std::path::{Path, PathBuf};
use std::process::{Command, exit};

const VERSION: &str = "0.4.0";
const HELP: &str = r#"
Athōn - Capability-secure systems programming language

USAGE:
    athon <COMMAND> [OPTIONS] [FILE]

COMMANDS:
    run <file>              Compile and run an Athōn program
    build <file>            Compile to executable
    compile <file>          Compile to C source
    check <file>            Check syntax without compiling
    new <name>              Create a new Athōn project
    init                    Initialize Athōn project in current directory
    test                    Run all tests in project
    clean                   Remove build artifacts
    repl                    Start interactive REPL (future)
    version                 Show version information
    help                    Show this help message

OPTIONS:
    -o, --output <file>     Specify output file name
    -O, --optimize          Enable optimizations
    -g, --debug             Include debug symbols
    -v, --verbose           Verbose output
    --no-run                Compile only, don't run
    --keep-c                Keep intermediate C files

EXAMPLES:
    athon run hello.at                  # Compile and run
    athon build hello.at -o hello       # Build executable
    athon new my-project                # Create new project
    athon test                          # Run tests

For more information, visit: https://github.com/beamitpal/athon
"#;

struct Config {
    command: String,
    file: Option<String>,
    output: Option<String>,
    optimize: bool,
    debug: bool,
    verbose: bool,
    no_run: bool,
    keep_c: bool,
}

fn main() {
    let args: Vec<String> = env::args().collect();
    
    if args.len() < 2 {
        print_help();
        exit(1);
    }
    
    let config = parse_args(&args);
    
    match config.command.as_str() {
        "run" => cmd_run(&config),
        "build" => cmd_build(&config),
        "compile" => cmd_compile(&config),
        "check" => cmd_check(&config),
        "new" => cmd_new(&config),
        "init" => cmd_init(&config),
        "test" => cmd_test(&config),
        "clean" => cmd_clean(&config),
        "repl" => cmd_repl(&config),
        "version" => cmd_version(),
        "help" | "--help" | "-h" => print_help(),
        _ => {
            eprintln!("Error: Unknown command '{}'", config.command);
            eprintln!("Run 'athon help' for usage information");
            exit(1);
        }
    }
}

fn parse_args(args: &[String]) -> Config {
    let mut config = Config {
        command: args[1].clone(),
        file: None,
        output: None,
        optimize: false,
        debug: false,
        verbose: false,
        no_run: false,
        keep_c: false,
    };
    
    let mut i = 2;
    while i < args.len() {
        match args[i].as_str() {
            "-o" | "--output" => {
                if i + 1 < args.len() {
                    config.output = Some(args[i + 1].clone());
                    i += 2;
                } else {
                    eprintln!("Error: --output requires a value");
                    exit(1);
                }
            }
            "-O" | "--optimize" => {
                config.optimize = true;
                i += 1;
            }
            "-g" | "--debug" => {
                config.debug = true;
                i += 1;
            }
            "-v" | "--verbose" => {
                config.verbose = true;
                i += 1;
            }
            "--no-run" => {
                config.no_run = true;
                i += 1;
            }
            "--keep-c" => {
                config.keep_c = true;
                i += 1;
            }
            arg if !arg.starts_with('-') => {
                config.file = Some(arg.to_string());
                i += 1;
            }
            _ => {
                eprintln!("Error: Unknown option '{}'", args[i]);
                exit(1);
            }
        }
    }
    
    config
}

fn cmd_run(config: &Config) {
    let file = config.file.as_ref().expect("No file specified");
    
    if config.verbose {
        println!("🚀 Running {}...", file);
    }
    
    // Compile to C
    let c_file = compile_to_c(file, config);
    
    // Compile C to executable
    let exe_file = compile_c_to_exe(&c_file, config);
    
    // Run executable
    if !config.no_run {
        if config.verbose {
            println!("▶️  Executing {}...", exe_file);
        }
        
        let status = Command::new(format!("./{}", exe_file))
            .status()
            .expect("Failed to run executable");
        
        if !status.success() {
            exit(status.code().unwrap_or(1));
        }
    }
    
    // Cleanup
    if !config.keep_c {
        let _ = fs::remove_file(&c_file);
    }
    if !config.no_run {
        let _ = fs::remove_file(&exe_file);
    }
}

fn cmd_build(config: &Config) {
    let file = config.file.as_ref().expect("No file specified");
    
    if config.verbose {
        println!("🔨 Building {}...", file);
    }
    
    // Determine output executable name
    let output = config.output.clone().unwrap_or_else(|| {
        Path::new(file)
            .file_stem()
            .unwrap()
            .to_str()
            .unwrap()
            .to_string()
    });
    
    // Compile to C (use temp name to avoid conflicts)
    let c_file = format!("{}.c", Path::new(file).file_stem().unwrap().to_str().unwrap());
    
    if config.verbose {
        println!("📝 Compiling {} to {}...", file, c_file);
    }
    
    let athon_output = Command::new("athon-boot")
        .arg(file)
        .output()
        .expect("Failed to run athon-boot");
    
    if !athon_output.status.success() {
        eprintln!("Error: Compilation failed");
        io::stderr().write_all(&athon_output.stderr).unwrap();
        exit(1);
    }
    
    fs::write(&c_file, athon_output.stdout)
        .expect("Failed to write C file");
    
    // Compile C to executable
    let mut gcc_args = vec![&c_file, "-o", &output];
    
    if config.optimize {
        gcc_args.push("-O3");
    }
    if config.debug {
        gcc_args.push("-g");
    }
    
    if config.verbose {
        println!("🔧 Compiling C code: gcc {}", gcc_args.join(" "));
    }
    
    let status = Command::new("gcc")
        .args(&gcc_args)
        .status()
        .expect("Failed to run gcc");
    
    if !status.success() {
        eprintln!("Error: C compilation failed");
        exit(1);
    }
    
    // Cleanup
    if !config.keep_c {
        let _ = fs::remove_file(&c_file);
    }
    
    println!("✅ Built successfully: {}", output);
}

fn cmd_compile(config: &Config) {
    let file = config.file.as_ref().expect("No file specified");
    
    if config.verbose {
        println!("📝 Compiling {} to C...", file);
    }
    
    let c_file = compile_to_c(file, config);
    
    println!("✅ Compiled to: {}", c_file);
}

fn cmd_check(config: &Config) {
    let file = config.file.as_ref().expect("No file specified");
    
    if config.verbose {
        println!("🔍 Checking {}...", file);
    }
    
    // Just try to compile, don't save output
    let output = Command::new("./athon-boot")
        .arg(file)
        .output()
        .expect("Failed to run athon-boot");
    
    if output.status.success() {
        println!("✅ No errors found");
    } else {
        eprintln!("❌ Errors found:");
        io::stderr().write_all(&output.stderr).unwrap();
        exit(1);
    }
}

fn cmd_new(config: &Config) {
    let name = config.file.as_ref().expect("No project name specified");
    
    if config.verbose {
        println!("📦 Creating new project: {}...", name);
    }
    
    // Create project structure
    let project_dir = PathBuf::from(name);
    fs::create_dir_all(&project_dir).expect("Failed to create project directory");
    fs::create_dir_all(project_dir.join("src")).expect("Failed to create src directory");
    fs::create_dir_all(project_dir.join("tests")).expect("Failed to create tests directory");
    
    // Create main.at
    let main_content = r#"fn main() {
    print("Hello from {}!", "PROJECT_NAME");
}
"#.replace("PROJECT_NAME", name);
    
    fs::write(project_dir.join("src/main.at"), main_content)
        .expect("Failed to write main.at");
    
    // Create athon.toml
    let toml_content = format!(r#"[package]
name = "{}"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]

[dependencies]

[build]
optimize = false
debug = true
"#, name);
    
    fs::write(project_dir.join("athon.toml"), toml_content)
        .expect("Failed to write athon.toml");
    
    // Create README
    let readme_content = format!(r#"# {}

A new Athōn project.

## Build

```bash
athon build src/main.at
```

## Run

```bash
athon run src/main.at
```
"#, name);
    
    fs::write(project_dir.join("README.md"), readme_content)
        .expect("Failed to write README.md");
    
    // Create .gitignore
    let gitignore_content = r#"# Build artifacts
*.c
*.o
*.out
/target/
/build/

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~
"#;
    
    fs::write(project_dir.join(".gitignore"), gitignore_content)
        .expect("Failed to write .gitignore");
    
    println!("✅ Created project: {}", name);
    println!("\nNext steps:");
    println!("  cd {}", name);
    println!("  athon run src/main.at");
}

fn cmd_init(config: &Config) {
    if config.verbose {
        println!("📦 Initializing Athōn project...");
    }
    
    let current_dir = env::current_dir().expect("Failed to get current directory");
    let name = current_dir.file_name().unwrap().to_str().unwrap();
    
    // Create directories if they don't exist
    let _ = fs::create_dir("src");
    let _ = fs::create_dir("tests");
    
    // Create athon.toml if it doesn't exist
    if !Path::new("athon.toml").exists() {
        let toml_content = format!(r#"[package]
name = "{}"
version = "0.1.0"

[dependencies]

[build]
optimize = false
debug = true
"#, name);
        
        fs::write("athon.toml", toml_content)
            .expect("Failed to write athon.toml");
    }
    
    println!("✅ Initialized Athōn project");
}

fn cmd_test(_config: &Config) {
    println!("🧪 Running tests...");
    
    // Find all test files
    let test_dir = Path::new("tests");
    if !test_dir.exists() {
        println!("No tests directory found");
        return;
    }
    
    let mut passed = 0;
    let mut failed = 0;
    
    for entry in fs::read_dir(test_dir).expect("Failed to read tests directory") {
        let entry = entry.expect("Failed to read entry");
        let path = entry.path();
        
        if path.extension().and_then(|s| s.to_str()) == Some("at") {
            let file_name = path.file_name().unwrap().to_str().unwrap();
            print!("  Testing {}... ", file_name);
            io::stdout().flush().unwrap();
            
            // Compile and run test
            let c_file = format!("/tmp/{}.c", file_name);
            let exe_file = format!("/tmp/{}.out", file_name);
            
            let compile_status = Command::new("./athon-boot")
                .arg(&path)
                .stdout(fs::File::create(&c_file).unwrap())
                .status();
            
            if compile_status.is_err() || !compile_status.unwrap().success() {
                println!("❌ FAILED (compilation)");
                failed += 1;
                continue;
            }
            
            let gcc_status = Command::new("gcc")
                .args(&[&c_file, "-o", &exe_file])
                .status();
            
            if gcc_status.is_err() || !gcc_status.unwrap().success() {
                println!("❌ FAILED (C compilation)");
                failed += 1;
                let _ = fs::remove_file(&c_file);
                continue;
            }
            
            let run_status = Command::new(&exe_file).status();
            
            if run_status.is_ok() && run_status.unwrap().success() {
                println!("✅ PASSED");
                passed += 1;
            } else {
                println!("❌ FAILED (execution)");
                failed += 1;
            }
            
            // Cleanup
            let _ = fs::remove_file(&c_file);
            let _ = fs::remove_file(&exe_file);
        }
    }
    
    println!("\n📊 Results: {} passed, {} failed", passed, failed);
    
    if failed > 0 {
        exit(1);
    }
}

fn cmd_clean(_config: &Config) {
    println!("🧹 Cleaning build artifacts...");
    
    let patterns = vec!["*.c", "*.o", "*.out", "build/", "target/"];
    
    for pattern in patterns {
        if pattern.ends_with('/') {
            if Path::new(pattern).exists() {
                fs::remove_dir_all(pattern).ok();
                println!("  Removed {}", pattern);
            }
        } else {
            // Simple glob for current directory
            if let Ok(entries) = fs::read_dir(".") {
                for entry in entries.flatten() {
                    let path = entry.path();
                    if let Some(ext) = path.extension() {
                        if pattern.contains(&format!(".{}", ext.to_str().unwrap())) {
                            fs::remove_file(&path).ok();
                            println!("  Removed {}", path.display());
                        }
                    }
                }
            }
        }
    }
    
    println!("✅ Clean complete");
}

fn cmd_repl(_config: &Config) {
    println!("🔮 Athōn REPL (coming soon!)");
    println!("This feature is planned for a future release.");
}

fn cmd_version() {
    println!("Athōn version {}", VERSION);
    println!("Capability-secure systems programming language");
}

fn print_help() {
    println!("{}", HELP);
}

fn compile_to_c(file: &str, config: &Config) -> String {
    // For compile_to_c, use the output config if provided, otherwise default to .c extension
    let output_file = if config.command == "compile" {
        config.output.clone().unwrap_or_else(|| {
            format!("{}.c", Path::new(file).file_stem().unwrap().to_str().unwrap())
        })
    } else {
        // For build/run, always use a temp .c file
        format!("{}.c", Path::new(file).file_stem().unwrap().to_str().unwrap())
    };
    
    if config.verbose {
        println!("📝 Compiling {} to {}...", file, output_file);
    }
    
    let output = Command::new("athon-boot")
        .arg(file)
        .output()
        .expect("Failed to run athon-boot");
    
    if !output.status.success() {
        eprintln!("Error: Compilation failed");
        io::stderr().write_all(&output.stderr).unwrap();
        exit(1);
    }
    
    fs::write(&output_file, output.stdout)
        .expect("Failed to write C file");
    
    output_file
}

fn compile_c_to_exe(c_file: &str, config: &Config) -> String {
    let exe_file = format!("{}.out", 
        Path::new(c_file).file_stem().unwrap().to_str().unwrap()
    );
    
    let mut gcc_args = vec![c_file, "-o", &exe_file];
    
    if config.optimize {
        gcc_args.push("-O3");
    }
    if config.debug {
        gcc_args.push("-g");
    }
    
    if config.verbose {
        println!("🔧 Compiling C: gcc {}", gcc_args.join(" "));
    }
    
    let status = Command::new("gcc")
        .args(&gcc_args)
        .status()
        .expect("Failed to run gcc");
    
    if !status.success() {
        eprintln!("Error: C compilation failed");
        exit(1);
    }
    
    exe_file
}
