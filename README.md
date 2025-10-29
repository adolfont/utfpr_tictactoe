# utfpr_tictactoe

### A Variation of the Tic-Tac-Toe Game

In this version of Tic-Tac-Toe, we have:

* 3 players, using the symbols **X**, **O**, and **+**
* a **4×4 board**
* players can place their symbol **on top of another player's symbol**
* **Two revenge prevention rules** to keep the game fair and prevent stalemates

## How to Play

1. Each player chooses their symbol (x, o, or +)
2. Symbols must be different for each player
3. Players take turns placing symbols on the board
4. Enter position in format: row,column (e.g., 1,1 or 2,3)

### Game Example

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

<details>
<summary>Complete game with board states</summary>

1. `X plays (1,1)`

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X |   |   |   |
| 2 |   |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

2. `O plays (1,2)`

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | O |   |   |
| 2 |   |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

3. `+ plays (1,3)`

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | O | + |   |
| 2 |   |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

4. `X plays (1,4)`

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | O | + | X |
| 2 |   |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

5. `O plays (1,3)` - **overwrites +**

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | O | O | X |
| 2 |   |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

6. `+ plays (1,2)` - **overwrites O**

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | + | O | X |
| 2 |   |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

7. `X plays (1,2)` - **overwrites +**

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | X | O | X |
| 2 |   |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

8. `O plays (2,1)`

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | X | O | X |
| 2 | O |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

9. `+ plays (1,3)` - **overwrites O**

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | X | + | X |
| 2 | O |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

10. `X plays (1,3)` - **overwrites +**

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | X | X | X |
| 2 | O |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

**Winner: X** (row 1 complete)

</details>

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

<details>
<summary>Complete example demonstrating all revenge rules</summary>

**Turn 1 - X plays (1,1)**

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X |   |   |   |
| 2 |   |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

**Turn 2 - O plays (1,1)** - overwrites X

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | O |   |   |   |
| 2 |   |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

*O's last_steal = X*

**Turn 3 - \+ plays (2,1)**

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | O |   |   |   |
| 2 | + |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

**Turn 4 - X tries (1,1)** - **BLOCKED by cell revenge**, plays (1,2) instead

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | O | X |   |   |
| 2 | + |   |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

*Cell revenge: X cannot retake (1,1)*

**Turn 5 - O tries (1,2)** - **BLOCKED by cross-revenge**, plays (2,2) instead

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | O | X |   |   |
| 2 | + | O |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

*Cross-revenge: O cannot steal from X again (O's last_steal = X)*

**Turn 6 - \+ plays (1,1)** - overwrites O

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | + | X |   |   |
| 2 | + | O |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

*Cell history at (1,1) changes - cell revenge cleared for X take from O and vice-versa, but not for O retake from \+*

*\+'s last_steal = O*

**Turn 7 - X plays (1,1)** - **ALLOWED** (cell revenge cleared)

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | X |   |   |
| 2 | + | O |   |   |
| 3 |   |   |   |   |
| 4 |   |   |   |   |

*X's last_steal = \+*

**Turn 8 - O plays (3,1)** - empty cell

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | X |   |   |
| 2 | + | O |   |   |
| 3 | O |   |   |   |
| 4 |   |   |   |   |

*O's played empty, cross-revenge cleared*

**Turn 9 - \+ plays (2,2)** - overwrites O

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | X |   |   |
| 2 | + | + |   |   |
| 3 | O |   |   |   |
| 4 |   |   |   |   |

**Turn 10 - X plays (1,2)** - overwrites X (own symbol, blocked), plays (3,1) instead - overwrites O

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | X |   |   |
| 2 | + | + |   |   |
| 3 | X |   |   |   |
| 4 |   |   |   |   |

**Turn 11 - O tries (3,1)** - **BLOCKED by cell revenge**, plays (1,2) instead - **ALLOWED** (cross-revenge cleared)

|   | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| 1 | X | O |   |   |
| 2 | + | + |   |   |
| 3 | X |   |   |   |
| 4 |   |   |   |   |

</details>

### How to Run

```bash
elixir run.exs
```

Or using Mix:

```bash
mix run -e "UtfprTictactoe.main()"
```

## Next Steps

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/feature-name`)
3. Commit your changes (`git commit -m 'Add feature description'`)
4. Push to the branch (`git push origin feature/feature-name`)
5. Open a Pull Request
