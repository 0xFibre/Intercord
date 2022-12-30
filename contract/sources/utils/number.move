module fibre::number {
    struct Number has store {
        value: u64
    }

    public fun new(value: u64): Number {
        Number { 
            value
        }
    }

    public fun add(number: &mut Number, value: u64) {
        number.value = number.value + value
    }

    public fun sub(number: &mut Number, value: u64) {
        number.value = number.value - value
    }

    public fun mul(number: &mut Number, value: u64) {
        number.value = number.value * value
    }

    public fun div(number: &mut Number, value: u64) {
        number.value = number.value / value
    }
}