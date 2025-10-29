# utfpr_tictactoe

### A Variation of the Tic-Tac-Toe Game

In this version of Tic-Tac-Toe, we have:

* 3 players, using the symbols **X**, **O**, and **+**
* a **4×4 board**
* players can place their symbol **on top of another player's symbol**
* **Two revenge prevention rules** to keep the game fair and prevent stalemates

## Game Example

1. `X plays (1,1)`
2. `O plays (1,2)`
3. `+ plays (1,3)`
4. `X plays (1,4)`
5. `O plays (1,3)` - **overwrites \+**
6. `+ plays (1,2)` - **overwrites O**
7. `X plays (1,2)` - **overwrites \+**
8. `O plays (2,1)`
9. `+ plays (1,3)` - **overwrites O**
10. `X plays (1,3)` - **overwrites \+**

## Revenge Rules

### 1. Cell-Based Revenge (Position-Specific)

If player A overwrites player B at a specific position, then player B cannot overwrite player A at that same position.

**Example**:
```
Position (1,1): X plays
Position (1,1): O overwrites X
Position (1,1): X tries to overwrite O ← BLOCKED
```

The block is removed when a third player takes that position.

### 2. Cross-Revenge Prevention (Global)

If player A overwrites player B, then player A cannot overwrite player B again anywhere until player A does something else (plays empty or overwrites a different player).

**Example**:
```
Position (1,1): O overwrites X
Position (2,2): O tries to overwrite X ← BLOCKED
Position (3,3): O plays empty or overwrites +
Position (2,2): O can now overwrite X ✓
```

This prevents two players from repeatedly stealing from each other.

### How to Run

```bash
elixir run.exs
```

Or using Mix:

```bash
mix run -e "UtfprTictactoe.main()"
```

### How to Play

1. Each player chooses their symbol (x, o, or +)
2. Symbols must be different for each player
3. Players take turns placing symbols on the board
4. Enter position in format: row,column (e.g., 1,1 or 2,3)

### Next steps

- Fork the repo
- Write a test and the code to pass that test
- Create a pull request
