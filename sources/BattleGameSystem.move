module mahi_address::BattleGame {
    use aptos_framework::signer;
    use std::vector;

    struct Character has store, key {
        name: vector<u8>,      
        health: u64,           
        max_health: u64,       
        attack: u64,           
        defense: u64,          
        level: u64,            
        is_alive: bool,        
    }
    struct Battle has store, key {
        player1: address,       
        player2: address,      
        current_turn: address, 
        battle_active: bool,   
        winner: address,       
    }
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
    public fun start_battle(
        initiator: &signer, 
        player1: address, 
        player2: address
    ) acquires Character {
        assert!(exists<Character>(player1), 1);
        assert!(exists<Character>(player2), 2);
        
        let char1 = borrow_global<Character>(player1);
        let char2 = borrow_global<Character>(player2);
        
        assert!(char1.is_alive, 3);
        assert!(char2.is_alive, 4);

        let battle = Battle {
            player1,
            player2,
            current_turn: player1, 
            battle_active: true,
            winner: @0x0,
        };
        move_to(initiator, battle);
    }

}
