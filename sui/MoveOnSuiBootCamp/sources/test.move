//Sui Programming Language
// My first lessons
//a module for a Non-Fungible Token (NFT) system called SuiGhana_nft

    //module declaration 
module my_nft::SuiGhana_nft{

    //defining imports 
    use sui::url::{Self, Url};
    use std::string;
    use sui::event;
    

    //definig nft structure
        public struct SuiGhana_nft has key, store {
        id: UID,
        name: string::String, 
        description: string::String,
        url: Url,
    }

    //minting an event structure 
        public struct Mintnft_event has copy, drop {
        object_id: ID,
        creator: address,
        name: string::String,
    }

    //the mint function 
        public entry fun mint(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext,
    ) {
        
        //inside the mint function
                let nft = SuiGhana_nft {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url),
        };

        let sender = tx_context::sender(ctx);

                event::emit(Mintnft_event {
            object_id: object::uid_to_inner(&nft.id),
            creator: sender,
            name: nft.name,
        });

// Emits a Mintnft_event to notify that a new NFT has been minted
            transfer::public_transfer(nft, sender);


    //update decription function
        public entry fun update_description(
        nft: &mut SuiGhana_nft,
        new_description: vector<u8>,
    ) {
        nft.description = string::utf8(new_description);
    }








}