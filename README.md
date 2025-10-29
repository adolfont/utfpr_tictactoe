# utfpr_tictactoe

### A Variation of the Tic-Tac-Toe Game

In this version of Tic-Tac-Toe, we have:

* 3 players, using the symbols **X**, **O**, and **+**
* a **4×4 board**
* players can place their symbol **on top of another player's symbol**
  * However, there is a **no-revenge rule**: if, in the previous move, **X** placed a symbol over **O**, then in **O**'s next turn, they **cannot** place their symbol over **X**.

### How to Run

To run the game:

```bash
elixir run.exs
```

Or using Mix:

```bash
mix run -e "UtfprTictactoe.main()"
```

### How to Play

1. When you start the game, each player will choose their symbol (x, o, or +)
2. The symbols must be different for each player
3. The game will display the 4×4 board
4. Players take turns to place their symbols on the board
5. To make a move, enter the position in format: row,column (e.g., 1,1 or 2,3)

### Next steps

- Fork the repo
- Write a test and the code to pass that test
- Create a pull request

### Examples

#### Revenge not allowed

1. X plays on (1,1) — X on empty cell — valid move
- O plays on (1,1)  — O overwrites X  — valid move
- \+ plays on (1,1)  — \+ overwrites O  — valid move
- X plays on (1,1)  — X overwrites \+  — valid move
- O plays on (1,1)  — O overwrites X  — valid move
- \+ plays on (2,2) — \+ on empty cell — valid move
- X plays on (1,1) -- not allowed
