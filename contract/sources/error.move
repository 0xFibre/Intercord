module fibre::error {
    const ErrorPrefix: u64 = 2002;

    // DAO main errors

    public fun not_dao_admin(): u64 {
        ErrorPrefix + 0
    }


    // DAO proposal errors

    public fun dao_proposal_mismatch(): u64 {
        ErrorPrefix + 10
    }

    public fun empty_poll_option(): u64 {
        ErrorPrefix + 11
    }

    public fun already_voted_proposal(): u64 {
        ErrorPrefix + 12
    }

    // DAO member errors

    public fun already_dao_member(): u64 {
        ErrorPrefix + 100
    }

    public fun not_dao_member(): u64 {
        ErrorPrefix + 101
    }

    public fun dao_member_mismatch(): u64 {
        ErrorPrefix + 102
    }

}