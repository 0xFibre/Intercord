module fibre::dao_proposal {
    use sui::object::{UID};
    use std::string::{String};

    struct Proposal<T> has key {
        id: UID,
        kind: T,
        text: String,
    }
}