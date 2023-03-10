module fibre::dao_proposal {
    use std::string::{Self, String};
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::table::{Self, Table};
    use sui::dynamic_field as field;

    use fibre::dao::{Self, Dao};
    use fibre::dao_member::{Self, Member};
    use fibre::u64::{Self, U64};
    use fibre::error;

    struct CoinTransferProposal<phantom T> has key, store {
        id: UID,
        amount: u64,
        recipient: address
    }

    struct PollProposal has key, store {
        id: UID,
        options: vector<String>
    }

    struct Proposal has key, store {
        id: UID,
        type: u8,
        status: u8,
        title: String,
        description: String,
        proposer: address,
        pointer: u64,
        dao_id: ID,
        member_votes: Table<address, u8>,
        votes_count: Table<u8, U64>,
    }

    const DYNAMIC_FIELD_KEY: u8 = 0;

    const PLAIN_PROPOSAL_TYPE: u8 = 0;
    const POLL_PROPOSAL_TYPE: u8 = 1;
    const COIN_TRANSFER_PROPOSAL_TYPE: u8 = 2;

    const ACTIVE_STATUS: u8 = 0;
    const APPROVED_STATUS: u8 = 1;
    const REJECTED_STATUS: u8 = 2;

    const VOTE_YES: u8 = 0;
    const VOTE_NO: u8 = 1;
    const VOTE_ABSTAIN: u8 = 2;

    fun new(dao: &Dao, type: u8, title: vector<u8>, description: vector<u8>, ctx: &mut TxContext): Proposal {

        Proposal {
            id: object::new(ctx),
            dao_id: object::id(dao),
            status: ACTIVE_STATUS,
            title: string::utf8(title),
            description: string::utf8(description),
            proposer: tx_context::sender(ctx),
            member_votes: table::new(ctx),
            votes_count: table::new(ctx),
            pointer: dao::proposals_count(dao),
            type,
        }
    }

    fun record_proposal(dao: &mut Dao, proposal: Proposal) {
        let dao_proposals = dao::proposals_mut(dao);

        vector::push_back(dao_proposals, object::id(&proposal));
        dao::increment_proposals_count(dao);

        transfer::share_object(proposal);
    }

    public entry fun create_plain_proposal(dao: &mut Dao, title: vector<u8>, description: vector<u8>, ctx: &mut TxContext) {
        let proposal = new(dao, PLAIN_PROPOSAL_TYPE, title, description, ctx);
        record_proposal(dao, proposal);
    }

    public entry fun create_poll_proposal(dao: &mut Dao, description: vector<u8>, options: vector<vector<u8>>, ctx: &mut TxContext) {
        assert!(!vector::is_empty(&options), error::empty_poll_option());

        let proposal = new(dao, POLL_PROPOSAL_TYPE, b"Poll Proposal", description, ctx);

        let string_options = vector::empty<String>();

        let i = 0;
        while(vector::length(&string_options) < vector::length(&options)) {
            let option = vector::borrow(&options, i);
            vector::push_back(&mut string_options, string::utf8(*option));

            i = i + 1;
        };

        let value = PollProposal {
            id: object::new(ctx),
            options: string_options
        };

        field::add<u8, PollProposal>(&mut proposal.id, DYNAMIC_FIELD_KEY, value);
        record_proposal(dao, proposal);
    }

    public entry fun create_coin_transfer_proposal<T>(dao: &mut Dao, description: vector<u8>, amount: u64, recipient: address, ctx: &mut TxContext) {
        let proposal = new(dao, COIN_TRANSFER_PROPOSAL_TYPE, b"Coin Transfer Proposal", description, ctx);

        let value = CoinTransferProposal<T> {
            id: object::new(ctx),
            amount,
            recipient
        };

        field::add<u8, CoinTransferProposal<T>>(&mut proposal.id, DYNAMIC_FIELD_KEY, value);
        record_proposal(dao, proposal);
    }

    public entry fun vote_proposal(dao: &mut Dao, proposal: &mut Proposal, member: &mut Member, vote: u8, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        assert_dao_proposal_match(dao, proposal);
        
        dao_member::assert_member(dao, sender);
        dao_member::assert_dao_member_match(dao, member, ctx);

        assert_not_voted(proposal, sender);
        record_proposal_vote(proposal, vote, ctx);

        if(can_execute_proposal(proposal)) {
            execute_proposal(proposal, ctx);
        }
    }

    fun record_proposal_vote(proposal: &mut Proposal, vote: u8, ctx: &TxContext) {
        if(table::contains(&proposal.votes_count, vote)) {
            let votes_count = table::borrow_mut(&mut proposal.votes_count, vote);
            u64::add(votes_count, 1);
        } else {
            table::add(&mut proposal.votes_count, vote, u64::new(1));
        };

        table::add(&mut proposal.member_votes, tx_context::sender(ctx), vote);
    }

    fun execute_proposal(proposal: &mut Proposal, ctx: &mut TxContext) {

    }

    fun can_execute_proposal(proposal: &Proposal): bool {
        true
    }

    fun has_voted(proposal: &Proposal, address: address): bool {
        table::contains(&proposal.member_votes, address)
    }

    fun votes_count(proposal: &Proposal, vote: u8): &U64 {
        table::borrow(&proposal.votes_count, vote)
    }

    fun assert_not_voted(proposal: &Proposal, address: address) {
        assert!(!has_voted(proposal, address), error::already_voted_proposal())
    }

    fun assert_dao_proposal_match(dao: &Dao, proposal: &Proposal) {
        assert!(&proposal.dao_id == object::borrow_id(dao), error::dao_proposal_mismatch())
    }
}