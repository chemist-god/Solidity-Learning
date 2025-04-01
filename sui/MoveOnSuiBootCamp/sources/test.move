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















}