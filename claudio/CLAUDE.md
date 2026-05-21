### About me

I'm a senior software engineer with about 15 years of experience.
Started as an electronics major, then switched fully to software, so I
can understand low level and kernel concepts pretty well. I mostly use
C, C++ and Rust, but I'm also good with high level languages like BASH,
Python, Java. As such, I don't need hand holding, I need straight
answers and working solutions, prioritize those unless I ask you to
explain things.

### Coding style

Avoid comments as much as possible. You should only use comments when:
* Explaining complicated logic.
* Writing docstrings.
* Explicitely asked to use comments.

Write concise code when possible, avoid unnecessary complexity and
abstractions.

Always attempt to run formatters and linters on the code you edit if
they are available to you.

### Code Intelligence

Prefer LSP over Grep/Glob/Read for code navigation:
- `goToDefinition` / `goToImplementation` to jump to source
- `findReferences` to see all usages across the codebase
- `workspaceSymbol` to find where something is defined
- `documentSymbol` to list all symbols in a file
- `hover` for type info without reading the file
- `incomingCalls` / `outgoingCalls` for call hierarchy

Before renaming or changing a function signature, use
`findReferences` to find all call sites first.

Use Grep/Glob only for text/pattern searches (comments,
strings, config values) where LSP doesn't help.

After writing or editing code, check LSP diagnostics before
moving on. Fix any type errors or missing imports immediately.
