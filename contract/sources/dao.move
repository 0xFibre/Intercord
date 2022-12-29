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
        balance: Balance<SUI>,
        proposals_count: u64,
        proposal_ids: vector<ID>
    }

    struct DaoCreated has copy, drop {
        id: ID,
        admin: address,
    }

    struct Config has store {
        logo_url: Option<String>
    }

    public entry fun new(name: vector<u8>, description:vector<u8>, admin: address, ctx: &mut TxContext) {
        let dao = create_dao(string::utf8(name), string::utf8(description), admin, ctx);

        emit(DaoCreated { 
            id: object::uid_to_inner(&dao.id),
            admin: dao.admin
        });

        transfer::share_object(dao);
    }

    fun create_dao(name: String, description: String, admin: address, ctx: &mut TxContext): Dao {
        Dao {
            id: object::new(ctx),
            name,
            admin,
            description,
            config: option::none(),
            balance: balance::zero(),
            proposals_count: 0,
            proposal_ids: vector::empty<ID>()
        }
    }

    // query functions

    public fun get_balance(self: &Dao): &Balance<SUI> {
        &self.balance
    }

    public fun get_balance_mut(self: &mut Dao): &mut Balance<SUI> {
        &mut self.balance
    }

    public fun get_proposals_count(self: &Dao): u64 {
        self.proposals_count
    }

    public fun get_proposal_ids(self: &Dao): vector<ID> {
        self.proposal_ids
    }

    // mutation functions

    public fun increment_proposals_count(self: &mut Dao) {
       self.proposals_count = self.proposals_count + 1;
    }

    // assert functions

    public fun assert_dao_admin(self: &Dao, ctx: &mut TxContext) {
        assert!(self.admin == tx_context::sender(ctx), error::not_dao_admin())
    }
}