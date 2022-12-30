module fibre::dao_treasury {
    use sui::object::{Self, ID};
    use sui::coin::{Self, Coin};
    use sui::balance;
    use sui::tx_context::{Self, TxContext};
    use sui::sui::SUI;
    use sui::transfer;
    use sui::event::emit;

    use fibre::dao::{Self, Dao};

    friend fibre::dao_proposal;

    struct CoinDeposit has copy, drop {
        coin_id: ID,
        depositor: address,
        amount: u64
    }

    struct CoinWithdrawal has copy, drop {
        coin_id: ID,
        reciever: address,
        amount: u64,
    }

    public(friend) fun deposit_coin(dao: &mut Dao, payment: &mut Coin<SUI>, amount: u64, ctx: &mut TxContext) {
        let coin_balance = coin::balance_mut(payment);
        let paid = balance::split(coin_balance, amount);

        emit(
            CoinDeposit { 
                coin_id: object::id(payment),
                depositor: tx_context::sender(ctx),
                amount: balance::value(&paid)
            }
        );
        
        balance::join(dao::balance_mut(dao), paid);
    }

    public(friend) fun withdraw_coin(dao: &mut Dao, reciever: address, amount: u64, ctx: &mut TxContext) {
        dao::assert_dao_admin(dao, ctx);
        
        let withdrawal = coin::take(dao::balance_mut(dao), amount, ctx);

        emit(
            CoinWithdrawal { 
                coin_id: object::id(&withdrawal),
                reciever,
                amount
            }
        );

        transfer::transfer(withdrawal, reciever);
    }
}