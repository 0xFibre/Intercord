module fibre::error {
    const ErrorPrefix: u64 = 2002;

    public fun not_dao_admin(): u64 {
        ErrorPrefix + 000
    }

    public fun empty_poll_option(): u64 {
        ErrorPrefix + 001
    }
}