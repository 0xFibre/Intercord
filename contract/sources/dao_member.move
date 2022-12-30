
module fibre::dao_member {
    use std::vector;

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{TxContext};
    use sui::transfer;
    use sui::event::emit;

    use fibre::dao::{Self, Dao};

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
        dao::assert_dao_admin(dao, ctx);

        let member = new(address, ctx);
        let dao_members = dao::members_mut(dao);

        vector::push_back(dao_members, object::id(&member));

        emit(
            NewMember {
                dao_id: object::id(dao),
                member_id: object::id(&member)
            }
        );

        transfer::share_object(member);
    }
}