# AI Usage Policy

## Principles

1. **Human in the Loop**: AI is a tool, not a coder. All AI-generated code must be reviewed by a human.
2. **No Telemetry**: AI tools must run locally or be strictly audited to ensure no code exfiltration.
3. **Provenance**: We must track which parts of the code were suggested by AI.

## Requirements

- **Tagging**: Commits containing AI code must include `[AI-Gen]` in the body.
- **Review**: AI code requires 2 reviewers instead of the usual 1.
- **Model**: Only open-weights models (e.g., Llama, Mistral) running on sovereign infrastructure are permitted for sensitive components.
