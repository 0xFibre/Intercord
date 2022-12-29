module fibre::dao_proposal {
    use std::string::{Self, String};
    use std::vector;

    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::coin::{Coin};
    use sui::tx_context::{Self, TxContext};

    use fibre::dao::{Self, Dao};

    struct CoinTransferProposal<phantom T> has key {
        id: UID,
        amount: u64,
        recipient: address,
        coin: Coin<T>,
    }

    struct Proposal has key, store {
        id: UID,
        type: String,
        status: String,
        text: String,
        proposer: address,
        pointer: u64
    }

    const VOTING_PROPOSAL: vector<u8> = b"VotingProposal";
    const COIN_TRANSFER_PROPOSAL: vector<u8> = b"CoinTransferProposal";

    const ACTIVE_STATUS: vector<u8> = b"Active";
    const APPROVED_STATUS: vector<u8> = b"Approved";
    const REJECTED_STATUS: vector<u8> = b"Rejected";

    public entry fun new(dao: &mut Dao, text: vector<u8>, ctx: &mut TxContext) {
        let proposal = create_proposal(text, dao::get_proposals_count(dao), ctx);
        let proposal_ids = dao::get_proposal_ids(dao);

        vector::push_back(&mut proposal_ids, object::id(&proposal));
        dao::increment_proposals_count(dao);
        transfer::share_object(proposal);
    }

    fun create_proposal(type: vector<u8>, text: vector<u8>, pointer: u64, ctx: &mut TxContext): Proposal {
        Proposal {
            id: object::new(ctx),
            type: string::utf8(type),
            status: string::utf8(ACTIVE_STATUS),
            text: string::utf8(text),
            proposer: tx_context::sender(ctx),
            pointer,
        }
    }
}