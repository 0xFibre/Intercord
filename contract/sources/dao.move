module fibre::dao {
    use std::string::{Self, String};
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{TxContext};
    use sui::transfer;
    use sui::balance::{Self, Balance};
    use sui::table::{Self, Table};
    use sui::sui::SUI;
    use sui::event::emit;

    friend fibre::dao_proposal;
    friend fibre::dao_member;
    friend fibre::dao_treasury;
    
    struct Dao has key {
        id: UID,
        name: String,
        description: String,
        config: Config,
        proposals_count: u64,
        balance: Balance<SUI>,
        proposals: vector<ID>,
        members: Table<address, ID>
    }

    struct DaoCreated has copy, drop {
        id: ID,
    }

    struct Link has store {
        data: String,
        pointer: u64
    }

    struct Config has store {
        logo_url: String,
        cover_url: String,
        links: vector<Link>
    }

    fun new(name: vector<u8>, description:vector<u8>, logo_url: vector<u8>, cover_url: vector<u8>, links: vector<vector<u8>>, ctx: &mut TxContext): Dao {
        let id = object::new(ctx);
        let config = Config {
            logo_url: string::utf8(logo_url),
            cover_url: string::utf8(cover_url),
            links: parse_dao_links(links)
        };

        emit(
            DaoCreated { 
                id: object::uid_to_inner(&id), 
            }
        );

        Dao {
            id,
            name: string::utf8(name),
            description: string::utf8(description),
            proposals_count: 0,
            balance: balance::zero(),
            members: table::new(ctx),
            proposals: vector::empty(),
            config,
        }
    }

    public entry fun create_dao(name: vector<u8>, description: vector<u8>, logo_url: vector<u8>, cover_url: vector<u8>, links: vector<vector<u8>>, ctx: &mut TxContext) {
        let dao = new(name, description, logo_url, cover_url, links, ctx);

        transfer::share_object(dao);
    }

    fun parse_dao_links(links: vector<vector<u8>>): vector<Link> {
        let links_str = vector::empty<Link>();

        let i = 0;
        while(vector::length(&links_str) < vector::length(&links)) {
            let link = Link { 
                pointer: i, 
                data: string::utf8(*vector::borrow(&links, i)) 
            };

            vector::push_back(&mut links_str, link);
            i = i + 1;
        };

        links_str
    }

    // Getter functions

    public fun balance(self: &Dao): &Balance<SUI> {
        &self.balance
    }

    public(friend) fun balance_mut(self: &mut Dao): &mut Balance<SUI> {
        &mut self.balance
    }

    public fun proposals_count(self: &Dao): u64 {
        self.proposals_count
    }

    public fun proposals(self: &Dao): &vector<ID> {
        &self.proposals
    }

    public(friend) fun proposals_mut(self: &mut Dao): &mut vector<ID> {
        &mut self.proposals
    }

    public fun members(self: &Dao): &Table<address, ID> {
        &self.members
    }

    public(friend) fun members_mut(self: &mut Dao): &mut Table<address, ID> {
        &mut self.members
    }

    // Setter functions

    public fun increment_proposals_count(self: &mut Dao) {
       self.proposals_count = self.proposals_count + 1;
    }
}