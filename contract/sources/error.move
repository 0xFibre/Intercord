module fibre::error {
    const ErrorPrefix: u64 = 2002;

    // DAO main errors

    public fun not_dao_admin(): u64 {
        ErrorPrefix + 000
    }

    // DAO proposal errors

    public fun empty_poll_option(): u64 {
        ErrorPrefix + 010
    }

    // DAO member errors

    public fun already_dao_member(): u64 {
        ErrorPrefix + 100
    }
}