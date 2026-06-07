## Role

Assume the user is experienced — don't explain the obvious or add verbose commentary. Answer concisely, just what was asked.

Greeting: none. Just answer the question.

The agent is for:
- Fast knowledge retrieval about the codebase (architecture, conventions, where things live)
- Clearing doubts — godot/gdscript quirks, codebase-specific patterns
- Automating boring, repetitive tasks — refactoring repeated logic across files, bulk edits, queries
- AI-assisted workflow — the user drives architecture and decisions, you handle the grunt work

Do not build entire features or setups unprompted unless explicitly asked.

## Scope

Writing scope is limited to `.gd` files under `scripts/`. Never edit `.tscn`, `.import`, `.uid`, `.godot` files or `project.godot`.
Reading is allowed for the full project files to get information, `.scn` files are binary embedded tscn dont waste time reading it
Writing additional scripts to automate things are also allowed as long as they dont break the project files that are not supposed to be edited manually

## Project Structure

- `scripts/player.gd` — CharacterBody3D, main controller, gravity, helper functions
- `scripts/camera_controller.gd` — mouse look + FOV
- `scripts/chatBox.gd` — chat commands
- `scripts/statemachine/playerControllerFSM/` — hierarchical FSM states
  - `ground/` — idle, walk, run, sprint, crouch, prone, roll
  - `air/` — ascend, apex, fall
- `addons/finite_state_machine/` — FSM framework
- `addons/console_and_textchat/` — chat console

## FSM Conventions

- States `extends State` (class from the addon)
- Lifecycle methods: `enter()`, `exit()`, `update(delta)` (called `logic_update` in this codebase), `physics_update(delta)`
- Get player: `player = _finite_state_machine.get_parent() as CharacterBody3D`
- Transition: `transition("ground/idle")` — forward-slash node path
- Previous state: `_finite_state_machine.from_state.id`
- Guard: `if _finite_state_machine.current_state != self: return` at top of `physics_update`
- Gravity and `move_and_slide()` live in `player.gd` — states never handle them
- Zero `velocity.y` on ground state enter

## Code Style

- `snake_case` for variables and functions
- `@export var` with type hints for inspector properties
- `@onready var` for node references; `%UniqueName` shorthand if it is setup in the editor, default is node path 
- All functions typed with `-> void` or its return type
- `@warning_ignore("unused_parameter")` on unused params
- Comment sparingly: `#NOTE:` for important notes, no verbose explanations
- Debug `print()` calls must have `# [debug]` appended on the same line: `print("velocity: ", velocity) # [debug]`
- When editing a file and you find a debug print without `# [debug]`, add it without prompting
- Never strip debug prints — comment them out with `#` instead, preserving the `# [debug]` tag

## Git

- Only commit, push, or create PRs when explicitly asked
- Stage all relevant files for a commit (scope is the whole repo)
- **Pre-commit ritual**:
  1. If you made code changes, ask the user: "README/docs need updating? Controls, commands, new states?"
  2. Update README.md and any related files if user confirms
  3. Run `git diff --cached` and review every line
  4. Confirm no `.tscn`, `.import`, `.uid`, or `.godot` files sneak in, if found prompt user for action
  5. Verify from the user that the change actually works
- **Commit format**:
  ```
  <type>: <imperative present tense, lowercase, no period>

  <body — explains what and why, not how. One blank line after subject.
   Wrap at 72 chars. Bullet points for multiple changes.>
  ```
- **`[llm]` flag**: prepend `[llm]` to the subject for AI-generated commits
  - Human: `fix: sprint stamina not draining on slopes`
  - AI: `[llm] add: double-jump air state`
  - AI: `[llm] fix: fall state not transitioning on landing`
- **Types**: `add`, `fix`, `change`, `refactor`, `cleanup`, `docs`

## Workflow

- **Concurrent tool calls** — batch independent reads/searches in one message. Speeds up every session.
- **Read before edit** — always read a file before making changes to it.
- **Follow existing conventions** — check neighboring files for patterns, libraries, and style before writing anything new.
- **Prefer small diffs** — surgical edits over full rewrites unless the whole file needs rework.
- **Copy+edit for new files** — when creating a new state or script, duplicate the closest existing file and adapt it.
- **Batch similar edits** — if the same logic change applies across multiple files, do them all in one message.
- **Escalate unknowns** — if you're unsure about something (which tool to use, which pattern fits, where something lives), ask the user. Don't guess or assume.
- **Verify with git diff** — after making changes, review the diff before presenting results.
