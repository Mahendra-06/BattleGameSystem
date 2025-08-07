module mahi_address::BattleGame {
    use aptos_framework::signer;
    use std::vector;

    /// Struct representing an NFT character with battle stats
    struct Character has store, key {
        name: vector<u8>,      // Character name
        health: u64,           // Current health points
        max_health: u64,       // Maximum health points
        attack: u64,           // Attack power
        defense: u64,          // Defense points
        level: u64,            // Character level
        is_alive: bool,        // Character status
    }

    /// Struct representing a battle session
    struct Battle has store, key {
        player1: address,      // First player address
        player2: address,      // Second player address
        current_turn: address, // Whose turn it is
        battle_active: bool,   // Battle status
        winner: address,       // Winner of the battle
    }

    /// Function to create a new NFT character
    public fun create_character(
        owner: &signer, 
        name: vector<u8>, 
        health: u64, 
        attack: u64, 
        defense: u64
    ) {
        let character = Character {
            name,
            health,
            max_health: health,
            attack,
            defense,
            level: 1,
            is_alive: true,
        };
        move_to(owner, character);
    }

    /// Function to initiate a battle between two characters
    public fun start_battle(
        initiator: &signer, 
        player1: address, 
        player2: address
    ) acquires Character {
        // Verify both players have characters
        assert!(exists<Character>(player1), 1);
        assert!(exists<Character>(player2), 2);
        
        let char1 = borrow_global<Character>(player1);
        let char2 = borrow_global<Character>(player2);
        
        // Check if characters are alive
        assert!(char1.is_alive, 3);
        assert!(char2.is_alive, 4);

        let battle = Battle {
            player1,
            player2,
            current_turn: player1, // Player1 starts first
            battle_active: true,
            winner: @0x0,
        };
        move_to(initiator, battle);
    }
}