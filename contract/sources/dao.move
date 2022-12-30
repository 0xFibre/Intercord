module fibre::dao {
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use sui::event::emit;

    use fibre::error;
    
    struct Dao has key {
        id: UID,
        name: String,
        description: String,
        admin: address,
        config: Option<Config>,
        proposals_count: u64,
        members_count: u64,
        balance: Balance<SUI>,
        proposals: vector<ID>,
        members: vector<ID>
    }

    struct DaoCreated has copy, drop {
        id: ID,
        admin: address,
    }

    struct Config has store {
        logo_url: Option<String>
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
            members_count: 0,
            proposals_count: 0,
            balance: balance::zero(),
            config: option::none<Config>(),
            members: vector::empty<ID>(),
            proposals: vector::empty<ID>()
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

    public fun balance_mut(self: &mut Dao): &mut Balance<SUI> {
        &mut self.balance
    }

    public fun proposals_count(self: &Dao): u64 {
        self.proposals_count
    }

    public fun proposals(self: &Dao): &vector<ID> {
        &self.proposals
    }

    public fun proposals_mut(self: &mut Dao): &mut vector<ID> {
        &mut self.proposals
    }

    public fun members(self: &Dao): &vector<ID> {
        &self.members
    }

    public fun members_mut(self: &mut Dao): &mut vector<ID> {
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