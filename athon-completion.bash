#!/bin/bash
# Bash completion for Athōn CLI

_athon_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local commands="run build compile check new init test clean repl version help"
    
    # Complete commands
    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
        return 0
    fi
    
    # Complete .at files for relevant commands
    case "${COMP_WORDS[1]}" in
        run|build|compile|check)
            COMPREPLY=($(compgen -f -X '!*.at' -- ${cur}))
            return 0
            ;;
        -o|--output)
            COMPREPLY=($(compgen -f -- ${cur}))
            return 0
            ;;
    esac
}

complete -F _athon_completions athon
