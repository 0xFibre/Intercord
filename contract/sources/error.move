module fibre::error {
    const ERROR_PREFIX: u64 = 2002;

    public fun not_dao_admin(): u64 {
        ERROR_PREFIX + 000
    }
}