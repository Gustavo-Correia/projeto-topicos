# AI-Assisted Development Setup

<cite>
**Referenced Files in This Document**
- [AGENTS.md](file://AGENTS.md)
- [CLAUDE.md](file://CLAUDE.md)
- [.agents/skills/flutter-development/SKILL.md](file://.agents/skills/flutter-development/SKILL.md)
- [.agents/skills/flutter-review/SKILL.md](file://.agents/skills/flutter-review/SKILL.md)
- [.agents/skills/flutter-state/SKILL.md](file://.agents/skills/flutter-state/SKILL.md)
- [.agents/skills/flutter-tests/SKILL.md](file://.agents/skills/flutter-tests/SKILL.md)
- [.agents/skills/flutter-ui/SKILL.md](file://.agents/skills/flutter-ui/SKILL.md)
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)
- [docs/reference/CLAUDE_PROMPT.md](file://docs/reference/CLAUDE_PROMPT.md)
- [pubspec.yaml](file://pubspec.yaml)
- [lib/main.dart](file://lib/main.dart)
</cite>

## Table of Contents
1. [Introduction](#introduction)
2. [Project Structure](#project-structure)
3. [Core Components](#core-components)
4. [Architecture Overview](#architecture-overview)
5. [Detailed Component Analysis](#detailed-component-analysis)
6. [Dependency Analysis](#dependency-analysis)
7. [Performance Considerations](#performance-considerations)
8. [Troubleshooting Guide](#troubleshooting-guide)
9. [Conclusion](#conclusion)
10. [Appendices](#appendices)

## Introduction
This document explains how to configure and use AI-assisted development tools for the ASSINATURAS NINJA project, focusing on:
- Skills framework setup under .agents/skills
- Agent configuration via AGENTS.md and CLAUDE.md
- Automated development assistance features
- Claude integration for code generation, review, and debugging
- Flutter-specific skills: state management, UI design, testing, and code review
- Setup instructions, usage examples, and best practices

The goal is to enable a consistent, repeatable workflow where an AI agent follows project rules and applies specialized skills to improve productivity and quality.

## Project Structure
The AI-assisted development setup centers around:
- A skills directory with Flutter-focused skill definitions
- Agent configuration files that define behavior and prompts
- A reference prompt for Claude interactions
- The Flutter application entry point and dependencies

```mermaid
graph TB
subgraph "AI Skills"
S1[".agents/skills/flutter-development"]
S2[".agents/skills/flutter-review"]
S3[".agents/skills/flutter-state"]
S4[".agents/skills/flutter-tests"]
S5[".agents/skills/flutter-ui"]
end
subgraph "Agent Config"
C1["AGENTS.md"]
C2["CLAUDE.md"]
R1["docs/reference/CLAUDE_PROMPT.md"]
end
subgraph "Flutter App"
F1["lib/main.dart"]
P1["pubspec.yaml"]
end
C1 --> S1
C1 --> S2
C1 --> S3
C1 --> S4
C1 --> S5
C2 --> R1
S1 --> F1
S2 --> F1
S3 --> F1
S4 --> F1
S5 --> F1
P1 --> F1
```

**Diagram sources**
- [AGENTS.md](file://AGENTS.md)
- [CLAUDE.md](file://CLAUDE.md)
- [.agents/skills/flutter-development/SKILL.md](file://.agents/skills/flutter-development/SKILL.md)
- [.agents/skills/flutter-review/SKILL.md](file://.agents/skills/flutter-review/SKILL.md)
- [.agents/skills/flutter-state/SKILL.md](file://.agents/skills/flutter-state/SKILL.md)
- [.agents/skills/flutter-tests/SKILL.md](file://.agents/skills/flutter-tests/SKILL.md)
- [.agents/skills/flutter-ui/SKILL.md](file://.agents/skills/flutter-ui/SKILL.md)
- [docs/reference/CLAUDE_PROMPT.md](file://docs/reference/CLAUDE_PROMPT.md)
- [lib/main.dart](file://lib/main.dart)
- [pubspec.yaml](file://pubspec.yaml)

**Section sources**
- [AGENTS.md](file://AGENTS.md)
- [CLAUDE.md](file://CLAUDE.md)
- [.agents/skills/flutter-development/SKILL.md](file://.agents/skills/flutter-development/SKILL.md)
- [.agents/skills/flutter-review/SKILL.md](file://.agents/skills/flutter-review/SKILL.md)
- [.agents/skills/flutter-state/SKILL.md](file://.agents/skills/flutter-state/SKILL.md)
- [.agents/skills/flutter-tests/SKILL.md](file://.agents/skills/flutter-tests/SKILL.md)
- [.agents/skills/flutter-ui/SKILL.md](file://.agents/skills/flutter-ui/SKILL.md)
- [docs/reference/CLAUDE_PROMPT.md](file://docs/reference/CLAUDE_PROMPT.md)
- [lib/main.dart](file://lib/main.dart)
- [pubspec.yaml](file://pubspec.yaml)

## Core Components
- Skills Framework: Each Flutter capability is encapsulated as a skill with its own SKILL.md and optional references. These guide the agent’s behavior when performing tasks like state management, UI work, tests, or reviews.
- Agent Configuration: AGENTS.md defines how the agent loads and uses skills; CLAUDE.md configures Claude-specific behaviors and constraints.
- Reference Prompt: docs/reference/CLAUDE_PROMPT.md provides a standardized prompt template for Claude interactions.
- Application Context: lib/main.dart and pubspec.yaml provide the runtime context (entrypoint and dependencies) that skills should respect.

Key responsibilities:
- Skill authors define intent, inputs, outputs, and constraints for each domain.
- Agent configuration orchestrates which skills are active and how they interact with the codebase.
- Claude prompt reference ensures consistent tone, structure, and safety across generations.

**Section sources**
- [AGENTS.md](file://AGENTS.md)
- [CLAUDE.md](file://CLAUDE.md)
- [.agents/skills/flutter-development/SKILL.md](file://.agents/skills/flutter-development/SKILL.md)
- [.agents/skills/flutter-review/SKILL.md](file://.agents/skills/flutter-review/SKILL.md)
- [.agents/skills/flutter-state/SKILL.md](file://.agents/skills/flutter-state/SKILL.md)
- [.agents/skills/flutter-tests/SKILL.md](file://.agents/skills/flutter-tests/SKILL.md)
- [.agents/skills/flutter-ui/SKILL.md](file://.agents/skills/flutter-ui/SKILL.md)
- [docs/reference/CLAUDE_PROMPT.md](file://docs/reference/CLAUDE_PROMPT.md)
- [lib/main.dart](file://lib/main.dart)
- [pubspec.yaml](file://pubspec.yaml)

## Architecture Overview
The AI-assisted development architecture connects the agent, skills, and the Flutter app:

```mermaid
sequenceDiagram
participant Dev as "Developer"
participant Agent as "AI Agent"
participant Skills as "Skills Framework"
participant Flutter as "Flutter App"
participant Claude as "Claude Integration"
Dev->>Agent : Request task (e.g., implement feature)
Agent->>Skills : Load relevant skills (state, ui, tests, review)
Skills->>Flutter : Inspect codebase and rules
Agent->>Claude : Generate code/review/debug using prompt reference
Claude-->>Agent : Output artifacts (code, suggestions, diffs)
Agent-->>Dev : Present changes and next steps
```

**Diagram sources**
- [AGENTS.md](file://AGENTS.md)
- [CLAUDE.md](file://CLAUDE.md)
- [.agents/skills/flutter-development/SKILL.md](file://.agents/skills/flutter-development/SKILL.md)
- [.agents/skills/flutter-review/SKILL.md](file://.agents/skills/flutter-review/SKILL.md)
- [.agents/skills/flutter-state/SKILL.md](file://.agents/skills/flutter-state/SKILL.md)
- [.agents/skills/flutter-tests/SKILL.md](file://.agents/skills/flutter-tests/SKILL.md)
- [.agents/skills/flutter-ui/SKILL.md](file://.agents/skills/flutter-ui/SKILL.md)
- [docs/reference/CLAUDE_PROMPT.md](file://docs/reference/CLAUDE_PROMPT.md)
- [lib/main.dart](file://lib/main.dart)

## Detailed Component Analysis

### Skills Framework Setup
- Purpose: Provide modular, reusable guidance for specific Flutter domains.
- Structure: Each skill has a SKILL.md describing scope, inputs, outputs, and constraints. Some include references (e.g., project rules).
- Usage: The agent selects appropriate skills based on the requested task.

Recommended workflow:
- Identify the domain (state, UI, tests, review).
- Ensure the corresponding SKILL.md is present and up-to-date.
- Invoke the agent with a clear request referencing the skill name and desired outcome.

Best practices:
- Keep SKILL.md concise and actionable.
- Use references for shared rules to avoid duplication.
- Version control all skill changes alongside code.

**Section sources**
- [.agents/skills/flutter-development/SKILL.md](file://.agents/skills/flutter-development/SKILL.md)
- [.agents/skills/flutter-review/SKILL.md](file://.agents/skills/flutter-review/SKILL.md)
- [.agents/skills/flutter-state/SKILL.md](file://.agents/skills/flutter-state/SKILL.md)
- [.agents/skills/flutter-tests/SKILL.md](file://.agents/skills/flutter-tests/SKILL.md)
- [.agents/skills/flutter-ui/SKILL.md](file://.agents/skills/flutter-ui/SKILL.md)
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)

### Agent Configuration
- AGENTS.md: Defines how the agent discovers and applies skills, and sets global behavior.
- CLAUDE.md: Configures Claude-specific settings such as tone, safety, and output format.

Setup checklist:
- Confirm AGENTS.md points to the correct skills directory.
- Validate CLAUDE.md includes required environment variables and constraints.
- Test a simple task to ensure the agent loads skills and respects configuration.

Operational tips:
- Centralize common constraints in CLAUDE.md to maintain consistency.
- Use explicit skill names in requests to reduce ambiguity.
- Maintain separate environments for dev/staging if needed.

**Section sources**
- [AGENTS.md](file://AGENTS.md)
- [CLAUDE.md](file://CLAUDE.md)

### Claude Integration for Code Generation, Review, and Debugging
- Reference Prompt: docs/reference/CLAUDE_PROMPT.md standardizes how to ask Claude for help.
- Typical flows:
  - Code generation: Provide context (files, requirements), specify target skill, and request implementation.
  - Code review: Ask for structured feedback aligned with project rules and skill constraints.
  - Debugging: Share error logs, stack traces, and minimal reproduction steps; request root cause analysis and fixes.

Usage examples:
- For generation: “Implement X using flutter-state skill, following project rules.”
- For review: “Review PR diff against flutter-review skill and list improvements.”
- For debugging: “Analyze crash log and propose targeted fixes respecting flutter-development rules.”

Safety and quality:
- Always validate generated code with static analysis and tests.
- Prefer incremental changes with clear commit messages.
- Use the reference prompt to keep outputs consistent and actionable.

**Section sources**
- [docs/reference/CLAUDE_PROMPT.md](file://docs/reference/CLAUDE_PROMPT.md)
- [CLAUDE.md](file://CLAUDE.md)
- [.agents/skills/flutter-development/SKILL.md](file://.agents/skills/flutter-development/SKILL.md)

### Flutter Development Skills

#### State Management Skill
- Scope: Define providers, streams, or state containers consistently.
- Inputs: Feature description, existing state patterns, data flow requirements.
- Outputs: Updated provider/state classes, wiring in main or screens, tests if applicable.
- Constraints: Follow project rules and dependency declarations.

```mermaid
flowchart TD
Start(["State Task"]) --> Analyze["Analyze current state usage"]
Analyze --> Design["Design new state structure"]
Design --> Implement["Implement provider/state class"]
Implement --> Integrate["Integrate into screens/services"]
Integrate --> Verify{"Static analysis passes?"}
Verify --> |No| Fix["Fix issues and re-run"]
Verify --> |Yes| Test["Add/update tests"]
Test --> Done(["Complete"])
```

**Diagram sources**
- [.agents/skills/flutter-state/SKILL.md](file://.agents/skills/flutter-state/SKILL.md)
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)
- [pubspec.yaml](file://pubspec.yaml)

**Section sources**
- [.agents/skills/flutter-state/SKILL.md](file://.agents/skills/flutter-state/SKILL.md)
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)
- [pubspec.yaml](file://pubspec.yaml)

#### UI Design Skill
- Scope: Build responsive, accessible, and theme-consistent screens and widgets.
- Inputs: Mockups or descriptions, component library usage, theming rules.
- Outputs: Widget trees, layout components, animations if needed.
- Constraints: Adhere to project style guidelines and asset organization.

```mermaid
flowchart TD
UStart(["UI Task"]) --> Requirements["Gather UI requirements"]
Requirements --> Layout["Draft layout and hierarchy"]
Layout --> Widgets["Implement widgets and themes"]
Widgets --> Review["Self-review against guidelines"]
Review --> Iterate{"Feedback received?"}
Iterate --> |Yes| Refine["Refine UI and accessibility"]
Iterate --> |No| Finalize["Finalize and commit"]
```

**Diagram sources**
- [.agents/skills/flutter-ui/SKILL.md](file://.agents/skills/flutter-ui/SKILL.md)
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)

**Section sources**
- [.agents/skills/flutter-ui/SKILL.md](file://.agents/skills/flutter-ui/SKILL.md)
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)

#### Testing Skill
- Scope: Unit, widget, and integration tests aligned with project standards.
- Inputs: Feature logic, UI components, services, and expected behaviors.
- Outputs: Test files, mocks, fixtures, and test utilities.
- Constraints: Follow naming conventions, coverage targets, and CI expectations.

```mermaid
flowchart TD
TStart(["Test Task"]) --> Scope["Define test scope and cases"]
Scope --> Write["Write unit/widget/integration tests"]
Write --> Run["Run tests locally"]
Run --> Pass{"All tests pass?"}
Pass --> |No| Debug["Debug failures and fix"]
Pass --> |Yes| Commit["Commit with clear messages"]
```

**Diagram sources**
- [.agents/skills/flutter-tests/SKILL.md](file://.agents/skills/flutter-tests/SKILL.md)
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)

**Section sources**
- [.agents/skills/flutter-tests/SKILL.md](file://.agents/skills/flutter-tests/SKILL.md)
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)

#### Code Review Skill
- Scope: Structured review process focusing on correctness, readability, performance, and security.
- Inputs: Diff or file set, change rationale, related issues.
- Outputs: Review comments, suggested improvements, risk assessment.
- Constraints: Align with project rules and team standards.

```mermaid
flowchart TD
RStart(["Review Task"]) --> Gather["Collect changed files and context"]
Gather --> CheckRules["Check against project rules"]
CheckRules --> Evaluate["Evaluate design and implementation"]
Evaluate --> Feedback["Provide prioritized feedback"]
Feedback --> Resolve{"Changes accepted?"}
Resolve --> |No| Revise["Revise and resubmit"]
Resolve --> |Yes| Approve["Approve and merge"]
```

**Diagram sources**
- [.agents/skills/flutter-review/SKILL.md](file://.agents/skills/flutter-review/SKILL.md)
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)

**Section sources**
- [.agents/skills/flutter-review/SKILL.md](file://.agents/skills/flutter-review/SKILL.md)
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)

### Conceptual Overview
The skills framework acts as a plugin system for the agent, enabling domain-specific expertise without changing core agent logic. By centralizing rules and prompts, teams can evolve standards while maintaining consistent AI behavior.

```mermaid
graph TB
Agent["AI Agent"] --> Loader["Skill Loader"]
Loader --> StateSkill["flutter-state"]
Loader --> UISkill["flutter-ui"]
Loader --> TestSkill["flutter-tests"]
Loader --> ReviewSkill["flutter-review"]
Agent --> Rules["Project Rules"]
Agent --> Prompt["Claude Prompt Reference"]
```

[No sources needed since this diagram shows conceptual workflow, not actual code structure]

## Dependency Analysis
The skills depend on the Flutter application context and shared rules:
- Skills reference project rules for consistency.
- The agent reads configuration from AGENTS.md and CLAUDE.md.
- The Flutter app’s entrypoint and dependencies inform what can be implemented or tested.

```mermaid
graph TB
Rules[".agents/skills/flutter-development/references/project-rules.md"]
State[".agents/skills/flutter-state/SKILL.md"]
UI[".agents/skills/flutter-ui/SKILL.md"]
Tests[".agents/skills/flutter-tests/SKILL.md"]
Review[".agents/skills/flutter-review/SKILL.md"]
Main["lib/main.dart"]
Pub["pubspec.yaml"]
Agents["AGENTS.md"]
ClaudeCfg["CLAUDE.md"]
Prompt["docs/reference/CLAUDE_PROMPT.md"]
State --> Rules
UI --> Rules
Tests --> Rules
Review --> Rules
Agents --> State
Agents --> UI
Agents --> Tests
Agents --> Review
ClaudeCfg --> Prompt
Main --> Pub
```

**Diagram sources**
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)
- [.agents/skills/flutter-state/SKILL.md](file://.agents/skills/flutter-state/SKILL.md)
- [.agents/skills/flutter-ui/SKILL.md](file://.agents/skills/flutter-ui/SKILL.md)
- [.agents/skills/flutter-tests/SKILL.md](file://.agents/skills/flutter-tests/SKILL.md)
- [.agents/skills/flutter-review/SKILL.md](file://.agents/skills/flutter-review/SKILL.md)
- [lib/main.dart](file://lib/main.dart)
- [pubspec.yaml](file://pubspec.yaml)
- [AGENTS.md](file://AGENTS.md)
- [CLAUDE.md](file://CLAUDE.md)
- [docs/reference/CLAUDE_PROMPT.md](file://docs/reference/CLAUDE_PROMPT.md)

**Section sources**
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)
- [.agents/skills/flutter-state/SKILL.md](file://.agents/skills/flutter-state/SKILL.md)
- [.agents/skills/flutter-ui/SKILL.md](file://.agents/skills/flutter-ui/SKILL.md)
- [.agents/skills/flutter-tests/SKILL.md](file://.agents/skills/flutter-tests/SKILL.md)
- [.agents/skills/flutter-review/SKILL.md](file://.agents/skills/flutter-review/SKILL.md)
- [lib/main.dart](file://lib/main.dart)
- [pubspec.yaml](file://pubspec.yaml)
- [AGENTS.md](file://AGENTS.md)
- [CLAUDE.md](file://CLAUDE.md)
- [docs/reference/CLAUDE_PROMPT.md](file://docs/reference/CLAUDE_PROMPT.md)

## Performance Considerations
- Keep prompts focused and scoped to reduce token usage and latency.
- Prefer incremental changes and small diffs for faster reviews and merges.
- Cache repeated context (e.g., project rules) to minimize redundant processing.
- Run static analysis and tests locally before requesting AI review to reduce back-and-forth.

[No sources needed since this section provides general guidance]

## Troubleshooting Guide
Common issues and resolutions:
- Agent does not load skills:
  - Verify AGENTS.md paths and skill directory structure.
  - Ensure CLAUDE.md contains valid configuration and credentials.
- Inconsistent outputs:
  - Confirm docs/reference/CLAUDE_PROMPT.md is referenced and unchanged.
  - Re-check project rules for conflicting constraints.
- Flutter build or analysis errors after AI changes:
  - Run static analysis and tests locally.
  - Narrow down affected files and revert partial changes if necessary.
- Permission or environment problems:
  - Validate environment variables and toolchain versions.
  - Ensure platform-specific configurations (Android/iOS) are intact.

**Section sources**
- [AGENTS.md](file://AGENTS.md)
- [CLAUDE.md](file://CLAUDE.md)
- [docs/reference/CLAUDE_PROMPT.md](file://docs/reference/CLAUDE_PROMPT.md)
- [.agents/skills/flutter-development/references/project-rules.md](file://.agents/skills/flutter-development/references/project-rules.md)

## Conclusion
By organizing Flutter expertise into discrete skills and centralizing agent configuration, ASSINATURAS NINJA enables reliable, scalable AI-assisted development. Following the setup instructions, leveraging the reference prompt, and adhering to project rules will streamline code generation, review, and debugging workflows while maintaining high quality and consistency.

[No sources needed since this section summarizes without analyzing specific files]

## Appendices

### Quick Start Checklist
- Ensure AGENTS.md and CLAUDE.md are configured correctly.
- Verify skills exist under .agents/skills and follow the SKILL.md format.
- Use docs/reference/CLAUDE_PROMPT.md as the base for Claude requests.
- Apply one skill per task to keep outputs focused.
- Validate changes with static analysis and tests before committing.

**Section sources**
- [AGENTS.md](file://AGENTS.md)
- [CLAUDE.md](file://CLAUDE.md)
- [.agents/skills/flutter-development/SKILL.md](file://.agents/skills/flutter-development/SKILL.md)
- [.agents/skills/flutter-review/SKILL.md](file://.agents/skills/flutter-review/SKILL.md)
- [.agents/skills/flutter-state/SKILL.md](file://.agents/skills/flutter-state/SKILL.md)
- [.agents/skills/flutter-tests/SKILL.md](file://.agents/skills/flutter-tests/SKILL.md)
- [.agents/skills/flutter-ui/SKILL.md](file://.agents/skills/flutter-ui/SKILL.md)
- [docs/reference/CLAUDE_PROMPT.md](file://docs/reference/CLAUDE_PROMPT.md)