# Star Story

A third-person 3D character controller playground built in Godot 4.

## Controls

| Key | Action |
|-----|--------|
| WASD | Movement |
| Space | Jump (hold to charge) |
| Shift | Sprint |
| Mouse | Look around |
| Esc | Toggle cursor / pause input |
| / or T | Open chat console |
| Enter | Submit chat / command |

## Movement States

The player uses a hierarchical finite state machine under `scripts/statemachine/playerControllerFSM/`:

**Ground states:**
- Idle — standing still, regenerates stamina
- Walk — slow movement
- Run — medium speed (activated by double-tap W)
- Sprint — fast movement, drains stamina fast
- Crouch / CrouchIdle / CrouchWalk — lowered profile
- Prone / ProneIdle / ProneWalk — fully prone
- Roll — dodge roll
- JumpWindup — hold Space to charge jump (0–10 scale)

**Air states:**
- Ascend — rising after jump
- Apex — peak of the arc
- Fall — descending with air control

**Hurt states:**
- Stagger — reaction to damage
- HurtIdle / HurtMove — recovery

## Stamina

Each movement state has a drain or regain rate. Stamina is capped at MAX_STAMINA.

| State | Stamina |
|-------|---------|
| Idle | Regenerates at 42/s |
| Walk | Drains at 3/s |
| Run | Drains at 8/s |
| Sprint | Drains at 20/s |

## Chat Commands

Open the console with `/` or `T`, then type:

| Command | Description |
|---------|-------------|
| `/help` | List all registered commands |
| `/clear` | Clear the console |
| `/ping` | Ping-pong test |
| `/kill @p` | Kill the player |
| `/tp <location>` | Teleport to a spawn point |
| `/ch @p <property> <value>` | Modify player properties |

### Teleport locations

`/tp mainSpawn`, `/tp buildings`, `/tp terrain`, `/tp slope`, `/tp crouch`, `/tp platforms`

### /ch properties

`/ch @p stamina <value>` — set stamina  
`/ch @p springLength <value>` — set camera spring arm length  
`/ch @p fov <value>` — set camera FOV

## Project Structure

```
scripts/
  player.gd                  — main player controller
  camera_controller.gd       — mouse look + FOV dynamics
  chatBox.gd                 — chat command registration
  testworld.gd               — test scene logic
  statemachine/              — FSM states
    playerControllerFSM/
      ground/                — ground movement states
      air/                   — jump and air states
addons/
  console_and_textchat/      — chat console plugin
  finite_state_machine/      — FSM framework
scenes/
  player.tscn
  testworld.scn
plans/                       — dev notes and plans

## Acknowledgments

- [Console and Textchat](https://github.com/Mike-Bros/ConsoleAddon) by Keilain (Mike-Bros) — chat console plugin
- [Finite State Machine](https://github.com/iamyoki/godot-finite-state-machine) by iamyoki — FSM framework
```
