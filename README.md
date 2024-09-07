# Bounty--Level-Up-Your-Rock-Paper-Scissors-Game
This smart contract implements the classic Rock Paper Scissors game on the Aptos blockchain, allowing players to compete against the computer over multiple rounds. The game tracks scores, rounds, and automatically generates the computer’s move.

## Features

- Play multiple rounds of Rock Paper Scissors against a computer.
- Players set their move, and the computer’s move is randomly generated.
- Track the player’s and computer’s scores throughout the rounds.
- The game determines the winner after all rounds are complete.
- A reset function to restart the game.

## Key Functions

- **start_game:** Initializes a new game session with a defined number of rounds.
- **set_player_move:** Sets the player's move for the current round.
- **randomly_set_computer_move:** Randomly assigns a move for the computer.
- **finalize_game_results:** Determines the winner of each round and updates the score.
- **reset_game:** Resets the game, clearing all data for a fresh start.

## Scoring and Results

- The game tracks player and computer wins over multiple rounds.
- Once the rounds are complete, the game determines the overall winner.
- Players can check their score and whether the game is over using the available view functions.

## Game Views

- **get_player_move:** Retrieve the player's last move.
- **get_computer_move:** Retrieve the computer's last move.
- **get_game_results:** Get the result of the last round.
- **get_player_score:** Get the player's win count.
- **get_computer_score:** Get the computer's win count.
- **is_game_over:** Check if the game is over.
- **rounds_left:** See how many rounds are remaining in the game.

## Demo
https://share.zight.com/geuKWqpx
