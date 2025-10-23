# utfpr_tictactoe

### A Variation of the Tic-Tac-Toe Game

In this version of Tic-Tac-Toe, we have:

* 3 players, using the symbols **X**, **O**, and **+**
* a **4×4 board**
* players can place their symbol **on top of another player’s symbol**
  * However, there is a **no-revenge rule**: if, in the previous move, **X** placed a symbol over **O**, then in **O**’s next turn, they **cannot** place their symbol over **X**.
 


### Next steps

- Fork the repo
- Write a test and the code to pass that test
- Create a pull request



### Examples

#### Revenge not allowed

- X plays on (1,1)
- O plays on (1,1)
- \+ plays on (1,1)
- X plays on (1,1)
- O plays on (1,1)
- \+ plays on (2,2)
- X plays on (1,1) -- not allowed
