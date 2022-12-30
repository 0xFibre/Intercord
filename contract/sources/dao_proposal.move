module fibre::dao_proposal {
    use std::string::{Self, String};
    use std::vector;

    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::dynamic_field as field;

    use fibre::dao::{Self, Dao};

    struct CoinTransferProposal<phantom T> has key, store {
        id: UID,
        amount: u64,
        recipient: address
    }

    struct PollProposal has key {
        id: UID,
        options: vector<String>
    }

    struct Proposal has key, store {
        id: UID,
        type: u8,
        status: u8,
        text: String,
        proposer: address,
        pointer: u64
    }

    const DYNAMIC_FIELD_KEY: u8 = 0;

    const POLL_PROPOSAL_TYPE: u8 = 0;
    const COIN_TRANSFER_PROPOSAL_TYPE: u8 = 1;

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

    fun record_proposal(dao: &mut Dao, proposal: Proposal) {
        let dao_proposals = dao::proposals_mut(dao);

        vector::push_back(dao_proposals, object::id(&proposal));
        dao::increment_proposals_count(dao);

        transfer::share_object(proposal);
    }

    public entry fun create_transfer_proposal<T>(dao: &mut Dao, text: vector<u8>, amount: u64, recipient: address, ctx: &mut TxContext) {
        let proposal = new(COIN_TRANSFER_PROPOSAL_TYPE, text, dao::proposals_count(dao), ctx);

        let value = CoinTransferProposal<T> {
            id: object::new(ctx),
            amount,
            recipient
        };

        field::add<u8, CoinTransferProposal<T>>(&mut proposal.id, DYNAMIC_FIELD_KEY, value);
        record_proposal(dao, proposal);
    }
}