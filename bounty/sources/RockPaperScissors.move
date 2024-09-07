address 0xca080f89a769434d2eabd00d58b039f50e1318d2ef01b3941017bce368afdfc8 {

module RockPaperScissors {
    use std::signer;
    use aptos_framework::randomness;

    const ROCK: u8 = 1;
    const PAPER: u8 = 2;
    const SCISSORS: u8 = 3;

    struct Game has key, drop {
        player: address,
        player_move: u8,   
        computer_move: u8,
        result: u8,
        player_wins: u64,
        computer_wins: u64,
        total_rounds: u64,
        current_round: u64,
    }

    public entry fun start_game(account: &signer, total_rounds: u64) acquires Game {
        let player = signer::address_of(account);

        if (exists<Game>(player)) {
            let game = borrow_global_mut<Game>(player);
            if (game.current_round > game.total_rounds) {
                game.total_rounds = if (total_rounds > 0) total_rounds else game.total_rounds;
                game.current_round = 0; // Reset to 0 to start counting from 1
            } else {
                game.current_round = game.current_round + 1;
            };

            game.player_move = 0;
            game.computer_move = 0;
            game.result = 0;
        } else {
            let game = Game {
                player,
                player_move: 0,
                computer_move: 0,
                result: 0,
                player_wins: 0,
                computer_wins: 0,
                total_rounds,
                current_round: 0, // Start with 0 so the first round will be 1
            };
            move_to(account, game);
        }
    }

    public entry fun set_player_move(account: &signer, player_move: u8) acquires Game {
        let game = borrow_global_mut<Game>(signer::address_of(account));
        if (game.current_round > game.total_rounds){
            abort 1
        };
        game.player_move = player_move;
    }

    #[randomness]
    entry fun randomly_set_computer_move(account: &signer) acquires Game {
        randomly_set_computer_move_internal(account);
    }

    public(friend) fun randomly_set_computer_move_internal(account: &signer) acquires Game {
        let game = borrow_global_mut<Game>(signer::address_of(account));
        if (game.current_round > game.total_rounds){
            abort 1
        };
        let random_number = randomness::u8_range(1, 4);
        game.computer_move = random_number;
    }

    public entry fun finalize_game_results(account: &signer) acquires Game {
        let game = borrow_global_mut<Game>(signer::address_of(account));

        if (game.current_round > game.total_rounds){
            abort 1
        };

        let result = determine_winner(game.player_move, game.computer_move);
        game.result = result;

        if (result == 2) {
            game.player_wins = game.player_wins + 1;
        } else if (result == 3) {
            game.computer_wins = game.computer_wins + 1;
        };

        game.current_round = game.current_round + 1;

        if (game.current_round > game.total_rounds) {
            if (game.player_wins > game.computer_wins) {
                game.result = 2;
            } else if (game.computer_wins > game.player_wins) {
                game.result = 3;
            } else {
                game.result = 1;
            }
        }
    }

    fun determine_winner(player_move: u8, computer_move: u8): u8 {
        if (player_move == ROCK && computer_move == SCISSORS) {
            2
        } else if (player_move == PAPER && computer_move == ROCK) {
            2
        } else if (player_move == SCISSORS && computer_move == PAPER) {
            2
        } else if (computer_move == ROCK && player_move == SCISSORS) {
            3
        } else if (computer_move == PAPER && player_move == ROCK) {
            3
        } else if (computer_move == SCISSORS && player_move == PAPER) {
            3
        } else {
            1
        } 
    }

    public entry fun reset_game(account: &signer) acquires Game {
        let game = borrow_global_mut<Game>(signer::address_of(account));
        game.player_move = 0;
        game.computer_move = 0;
        game.result = 0;
        game.player_wins = 0;
        game.computer_wins = 0;
        game.total_rounds = 0;
        game.current_round = 0;
    }

    #[view]
    public fun get_player_move(account_addr: address): u8 acquires Game {
        borrow_global<Game>(account_addr).player_move
    }

    #[view]
    public fun get_computer_move(account_addr: address): u8 acquires Game {
        borrow_global<Game>(account_addr).computer_move
    }

    #[view]
    public fun get_game_results(account_addr: address): u8 acquires Game {
        borrow_global<Game>(account_addr).result
    }

    #[view]
    public fun get_player_score(account_addr: address): u64 acquires Game {
        borrow_global<Game>(account_addr).player_wins
    }

    #[view]
    public fun get_computer_score(account_addr: address): u64 acquires Game {
        borrow_global<Game>(account_addr).computer_wins
    }

    #[view]
    public fun is_game_over(account_addr: address): bool acquires Game {
        let game = borrow_global<Game>(account_addr);
        game.current_round > game.total_rounds
    }

    #[view]
    public fun rounds_left(account_addr: address): u64 acquires Game {
        let game = borrow_global<Game>(account_addr);
        game.total_rounds - game.current_round
    }
}

}