module fibre::dao {
    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use std::option::{Self, Option};
    use sui::transfer;
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;

    struct Dao has key {
        id: UID,
        name: String,
        description: String,
        config: Option<Config>,
        balance: Balance<SUI>
    }

    struct Config has store {
        logo_url: Option<String>
    }

    struct DaoManagerCap has key { 
        id: UID
    }

    public fun new(name: vector<u8>, description:vector<u8>, ctx: &mut TxContext) {
        let dao = create_dao(string::utf8(name), string::utf8(description), ctx);

        transfer::transfer(DaoManagerCap { 
            id: object::new(ctx) 
        }, tx_context::sender(ctx));
        transfer::share_object(dao);
    }

    fun create_dao(name: String, description: String, ctx: &mut TxContext): Dao {
        Dao {
            id: object::new(ctx),
            name,
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
}