module fibre::dao_treasury {
    use sui::coin::{Self, Coin};
    use sui::balance;
    use sui::tx_context::{Self, TxContext};
    use sui::sui::SUI;
    use sui::transfer;

    use fibre::dao::{Self, Dao, DaoManagerCap};

    public entry fun deposit(dao: &mut Dao, payment: &mut Coin<SUI>, amount: u64, _ctx: &mut TxContext) {
        let coin_balance = coin::balance_mut(payment);

        let paid = balance::split(coin_balance, amount);
        balance::join(dao::balance_mut(dao), paid);
    }

    public entry fun withdraw(_: &mut DaoManagerCap, dao: &mut Dao, amount: u64, ctx: &mut TxContext) {
        let withdrawal = coin::take(dao::balance_mut(dao), amount, ctx);
        transfer::transfer(withdrawal, tx_context::sender(ctx));
    }
}