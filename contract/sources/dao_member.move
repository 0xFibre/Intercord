
module fibre::dao_member {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{TxContext};
    use sui::table;
    use sui::transfer;
    use sui::event::emit;

    use fibre::dao::{Self, Dao};
    use fibre::error;

    struct Member has key, store {
        id: UID,
        address: address,
        votes_count: u64
    }

    struct NewMember has copy, drop {
        dao_id: ID,
        member_id: ID
    }

    fun new(address: address, ctx: &mut TxContext): Member {
        let id = object::new(ctx);

        Member {
            id,
            address,
            votes_count: 0
        }
    }

    public entry fun add_member(dao: &mut Dao, address: address, ctx: &mut TxContext) {
        assert_not_member(dao, address);

        let member = new(address, ctx);
        let dao_members = dao::members_mut(dao);

        table::add(dao_members, address, object::id(&member));

        emit(
            NewMember {
                dao_id: object::id(dao),
                member_id: object::id(&member)
            }
        );

        transfer::transfer(member, address);
    }

    fun is_member(dao: &Dao, address: address): bool {
        table::contains(dao::members(dao), address)
    }

    
    fun assert_not_member(dao: &Dao, address: address) {
        assert!(!is_member(dao, address), error::already_dao_member())
    }
}