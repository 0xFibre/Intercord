module fibre::dao_treasury {
    use sui::object::{Self, ID};
    use sui::coin::{Self, Coin};
    use sui::balance;
    use sui::tx_context::{Self, TxContext};
    use sui::sui::SUI;
    use sui::transfer;
    use sui::event::emit;

    use fibre::dao::{Self, Dao, DaoManagerCap};

    struct Deposit has copy, drop {
        coin_id: ID,
        depositor: address,
        amount: u64
    }

    struct Withdrawal has copy, drop {
        coin_id: ID,
        caller: address,
        reciever: address,
        amount: u64,
    }

    public entry fun deposit(dao: &mut Dao, payment: &mut Coin<SUI>, amount: u64, ctx: &mut TxContext) {
        let coin_balance = coin::balance_mut(payment);
        let paid = balance::split(coin_balance, amount);

        emit(Deposit { 
            coin_id: object::id(payment),
            depositor: tx_context::sender(ctx),
            amount: balance::value(&paid)
        });
        
        balance::join(dao::balance_mut(dao), paid);
    }

    public entry fun withdraw(_: &mut DaoManagerCap, dao: &mut Dao, amount: u64, ctx: &mut TxContext) {
        let withdrawal = coin::take(dao::balance_mut(dao), amount, ctx);
        let caller = tx_context::sender(ctx);
        let reciever = tx_context::sender(ctx);

        emit(Withdrawal { 
            coin_id: object::id(&withdrawal),
            caller,
            reciever,
            amount
        });

        transfer::transfer(withdrawal, reciever);
    }
}