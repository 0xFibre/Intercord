module fibre::number {
    struct Number has store {
        value: u64
    }

    public fun new(value: u64): Number {
        Number { 
            value
        }
    }

    public fun add(self: &mut Number, value: u64) {
        self.value = self.value + value
    }

    public fun sub(self: &mut Number, value: u64) {
        self.value = self.value - value
    }

    public fun mul(self: &mut Number, value: u64) {
        self.value = self.value * value
    }

    public fun div(self: &mut Number, value: u64) {
        self.value = self.value / value
    }

    public fun value(self: &Number): u64 {
        self.value
    }
}