module fibre::dao {
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::balance::{Self, Balance};
    use sui::table::{Self, Table};
    use sui::sui::SUI;
    use sui::event::emit;

    use fibre::error;

    friend fibre::dao_proposal;
    friend fibre::dao_member;
    friend fibre::dao_treasury;
    
    struct Dao has key {
        id: UID,
        name: String,
        description: String,
        admin: address,
        config: Config,
        proposals_count: u64,
        balance: Balance<SUI>,
        proposals: vector<ID>,
        members: Table<address, ID>
    }

    struct DaoCreated has copy, drop {
        id: ID,
        admin: address,
    }

    struct Config has store {
        logo_url: Option<String>,
    }

    fun new(name: vector<u8>, description:vector<u8>, admin: address, ctx: &mut TxContext): Dao {
        let id = object::new(ctx);

        emit(
            DaoCreated { 
                id: object::uid_to_inner(&id), 
                admin 
            }
        );

        Dao {
            id,
            name: string::utf8(name),
            admin,
            description: string::utf8(description),
            proposals_count: 0,
            balance: balance::zero(),
            config: Config {
                logo_url: option::none(),
            },
            members: table::new(ctx),
            proposals: vector::empty()
        }
    }

    public entry fun create_dao(name: vector<u8>, description: vector<u8>, admin: address, ctx: &mut TxContext) {
        let dao = new(name, description, admin, ctx);

        transfer::share_object(dao);
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


    // Assertion functions

    public fun assert_dao_admin(self: &Dao, ctx: &mut TxContext) {
        assert!(self.admin == tx_context::sender(ctx), error::not_dao_admin())
    }
}