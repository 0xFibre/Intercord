module fibre::dao {
    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use std::option::{Self, Option};
    use sui::transfer;
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;

    use fibre::error;

    struct Dao has key {
        id: UID,
        name: String,
        description: String,
        admin: address,
        config: Option<Config>,
        balance: Balance<SUI>
    }

    struct Config has store {
        logo_url: Option<String>
    }

    public entry fun new(name: vector<u8>, description:vector<u8>, admin: address, ctx: &mut TxContext) {
        let dao = create_dao(string::utf8(name), string::utf8(description), admin, ctx);

        transfer::share_object(dao);
    }

    fun create_dao(name: String, description: String, admin: address, ctx: &mut TxContext): Dao {
        Dao {
            id: object::new(ctx),
            name,
            admin,
            description,
            config: option::none(),
            balance: balance::zero()
        }
    }

    public fun balance(self: &Dao): &Balance<SUI> {
        &self.balance
    }

    public fun balance_mut(self: &mut Dao): &mut Balance<SUI> {
        &mut self.balance
    }

    public fun assert_dao_admin(dao: &Dao, ctx: &mut TxContext) {
        assert!(dao.admin == tx_context::sender(ctx), error::not_dao_admin())
    }
}