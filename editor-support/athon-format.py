#!/usr/bin/env python3
"""
Athōn Code Formatter
Formats Athōn source code with consistent style
"""

import sys
import re
from typing import List, Tuple

class AthonFormatter:
    def __init__(self, indent_size: int = 4):
        self.indent_size = indent_size
        self.indent_level = 0
        
    def format_file(self, content: str) -> str:
        """Format Athōn source code"""
        lines = content.split('\n')
        formatted_lines = []
        
        in_multiline_comment = False
        in_string = False
        
        for line in lines:
            # Handle multiline comments
            if '/*' in line and not in_string:
                in_multiline_comment = True
            
            if in_multiline_comment:
                formatted_lines.append(line.rstrip())
                if '*/' in line:
                    in_multiline_comment = False
                continue
            
            # Skip empty lines (preserve them)
            if not line.strip():
                formatted_lines.append('')
                continue
            
            # Format the line
            formatted_line = self.format_line(line)
            formatted_lines.append(formatted_line)
        
        return '\n'.join(formatted_lines)
    
    def format_line(self, line: str) -> str:
        """Format a single line"""
        stripped = line.strip()
        
        # Handle closing braces
        if stripped.startswith('}'):
            self.indent_level = max(0, self.indent_level - 1)
        
        # Calculate indentation
        indent = ' ' * (self.indent_level * self.indent_size)
        
        # Format the line content
        formatted = self.format_content(stripped)
        
        # Handle opening braces
        if stripped.endswith('{'):
            self.indent_level += 1
        
        return indent + formatted
    
    def format_content(self, content: str) -> str:
        """Format line content"""
        # Add space after keywords
        keywords = ['fn', 'let', 'if', 'else', 'while', 'for', 'in', 'match', 
                   'return', 'break', 'continue', 'struct', 'enum', 'type', 
                   'trait', 'impl', 'import', 'pub']
        
        for keyword in keywords:
            # Add space after keyword if not already present
            content = re.sub(rf'\b{keyword}\b(?!\s)', f'{keyword} ', content)
        
        # Format operators with spaces
        # Binary operators
        content = re.sub(r'([^=!<>])=([^=])', r'\1 = \2', content)  # Assignment
        content = re.sub(r'([^=!<>])==', r'\1 ==', content)  # Equality
        content = re.sub(r'!=', ' != ', content)  # Not equal
        content = re.sub(r'<=', ' <= ', content)  # Less than or equal
        content = re.sub(r'>=', ' >= ', content)  # Greater than or equal
        content = re.sub(r'([^<])<([^=])', r'\1 < \2', content)  # Less than
        content = re.sub(r'([^>])>([^=])', r'\1 > \2', content)  # Greater than
        
        # Arithmetic operators
        content = re.sub(r'([^\s])\+([^\s])', r'\1 + \2', content)
        content = re.sub(r'([^\s])-([^\s])', r'\1 - \2', content)
        content = re.sub(r'([^\s])\*([^\s])', r'\1 * \2', content)
        content = re.sub(r'([^\s])/([^\s])', r'\1 / \2', content)
        
        # Format commas
        content = re.sub(r',(?!\s)', ', ', content)
        
        # Format colons (but not ::)
        content = re.sub(r'(?<!:):(?!:)(?!\s)', ': ', content)
        
        # Clean up multiple spaces
        content = re.sub(r' +', ' ', content)
        
        return content.strip()

def main():
    if len(sys.argv) < 2:
        print("Usage: athon-format.py <file.at>")
        print("   or: athon-format.py --stdin")
        sys.exit(1)
    
    formatter = AthonFormatter(indent_size=4)
    
    if sys.argv[1] == '--stdin':
        # Read from stdin
        content = sys.stdin.read()
        formatted = formatter.format_file(content)
        print(formatted, end='')
    else:
        # Read from file
        filename = sys.argv[1]
        try:
            with open(filename, 'r') as f:
                content = f.read()
            
            formatted = formatter.format_file(content)
            
            # Write back to file or stdout
            if '--check' in sys.argv:
                # Just check if formatting is needed
                if content != formatted:
                    print(f"File {filename} needs formatting")
                    sys.exit(1)
                else:
                    print(f"File {filename} is already formatted")
                    sys.exit(0)
            elif '--write' in sys.argv or '-w' in sys.argv:
                # Write back to file
                with open(filename, 'w') as f:
                    f.write(formatted)
                print(f"Formatted {filename}")
            else:
                # Print to stdout
                print(formatted, end='')
        
        except FileNotFoundError:
            print(f"Error: File '{filename}' not found")
            sys.exit(1)
        except Exception as e:
            print(f"Error: {e}")
            sys.exit(1)

if __name__ == '__main__':
    main()
