const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');

// Find formatter
function findFormatter() {
    const possiblePaths = [
        path.join(__dirname, '..', 'athon-format.py'),
        '/usr/local/bin/athon-format.py',
        path.join(process.env.HOME || '', '.local', 'bin', 'athon-format.py')
    ];

    for (const p of possiblePaths) {
        if (fs.existsSync(p)) {
            return p;
        }
    }

    return null;
}

// Prettier plugin interface
const plugin = {
    languages: [
        {
            name: 'Athōn',
            parsers: ['athon'],
            extensions: ['.at'],
            vscodeLanguageIds: ['athon']
        }
    ],
    parsers: {
        athon: {
            parse: (text) => {
                // Return AST-like structure (simplified)
                return {
                    type: 'Program',
                    body: text
                };
            },
            astFormat: 'athon-ast',
            locStart: () => 0,
            locEnd: () => 0
        }
    },
    printers: {
        'athon-ast': {
            print: (path, options, print) => {
                const node = path.getValue();
                
                // Use athon-format.py for actual formatting
                const formatterPath = findFormatter();
                if (!formatterPath) {
                    console.warn('Athōn formatter not found, returning original text');
                    return node.body;
                }

                return new Promise((resolve, reject) => {
                    const process = exec(`python3 "${formatterPath}" --stdin`, (error, stdout, stderr) => {
                        if (error) {
                            console.error('Formatter error:', stderr);
                            resolve(node.body);
                            return;
                        }
                        resolve(stdout);
                    });

                    process.stdin.write(node.body);
                    process.stdin.end();
                });
            }
        }
    },
    options: {
        indentSize: {
            type: 'int',
            category: 'Athōn',
            default: 4,
            description: 'Number of spaces for indentation'
        }
    },
    defaultOptions: {
        printWidth: 100,
        tabWidth: 4,
        useTabs: false
    }
};

module.exports = plugin;
