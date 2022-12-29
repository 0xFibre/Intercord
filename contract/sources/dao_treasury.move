module fibre::dao_treasury {
    use sui::object::{Self, ID};
    use sui::coin::{Self, Coin};
    use sui::balance;
    use sui::tx_context::{Self, TxContext};
    use sui::sui::SUI;
    use sui::transfer;
    use sui::event::emit;

    use fibre::dao::{Self, Dao};

    struct Deposit has copy, drop {
        coin_id: ID,
        depositor: address,
        amount: u64
    }

    struct Withdrawal has copy, drop {
        coin_id: ID,
        sender: address,
        reciever: address,
        amount: u64,
    }

    public fun deposit(dao: &mut Dao, payment: &mut Coin<SUI>, amount: u64, ctx: &mut TxContext) {
        let coin_balance = coin::balance_mut(payment);
        let paid = balance::split(coin_balance, amount);

        emit(Deposit { 
            coin_id: object::id(payment),
            depositor: tx_context::sender(ctx),
            amount: balance::value(&paid)
        });
        
        balance::join(dao::get_balance_mut(dao), paid);
    }

    public fun withdraw(dao: &mut Dao, reciever: address, amount: u64, ctx: &mut TxContext) {
        dao::assert_dao_admin(dao, ctx);
        
        let withdrawal = coin::take(dao::get_balance_mut(dao), amount, ctx);
        let sender = tx_context::sender(ctx);

        emit(Withdrawal { 
            coin_id: object::id(&withdrawal),
            sender,
            reciever,
            amount
        });

        transfer::transfer(withdrawal, reciever);
    }
}