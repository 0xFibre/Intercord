module fibre::dao_proposal {
    use std::string::{Self, String};
    use std::vector;

    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    use fibre::dao::{Self, Dao};

    // struct CoinTransferProposal<phantom T> has key {
    //     id: UID,
    //     amount: u64,
    //     recipient: address,
    //     coin: Coin<T>,
    // }

    struct Proposal has key, store {
        id: UID,
        type: u8,
        status: u8,
        text: String,
        proposer: address,
        pointer: u64
    }

    const VOTING_PROPOSAL: u8 = 0;
    const COIN_TRANSFER_PROPOSAL: u8 = 1;

    const ACTIVE_STATUS: u8 = 0;
    const APPROVED_STATUS: u8 = 1;
    const REJECTED_STATUS: u8 = 2;

    fun new(type: u8, text: vector<u8>, pointer: u64, ctx: &mut TxContext): Proposal {
        let id = object::new(ctx);

        Proposal {
            id,
            type,
            pointer,
            status: ACTIVE_STATUS,
            text: string::utf8(text),
            proposer: tx_context::sender(ctx)
        }
    }

    public entry fun create_proposal(dao: &mut Dao, type: u8, text: vector<u8>, ctx: &mut TxContext) {
        let proposal = new(type, text, dao::proposals_count(dao), ctx);

        let dao_proposals = dao::proposals_mut(dao);

        vector::push_back(dao_proposals, object::id(&proposal));
        dao::increment_proposals_count(dao);

        transfer::share_object(proposal);
    }
}