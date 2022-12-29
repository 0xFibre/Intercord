module fibre::dao_proposal {
    use sui::object::{UID};
    use std::string::{String};

    struct Proposal<T: store> has key {
        id: UID,
        type: T,
        text: String,
    }
}