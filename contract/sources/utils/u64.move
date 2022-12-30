module fibre::u64 {
    struct U64 has store {
        value: u64
    }

    public fun new(value: u64): U64 {
        U64 { 
            value
        }
    }

    public fun add(self: &mut U64, value: u64) {
        self.value = self.value + value
    }

    public fun sub(self: &mut U64, value: u64) {
        self.value = self.value - value
    }

    public fun mul(self: &mut U64, value: u64) {
        self.value = self.value * value
    }

    public fun div(self: &mut U64, value: u64) {
        self.value = self.value / value
    }

    public fun value(self: &U64): u64 {
        self.value
    }
}