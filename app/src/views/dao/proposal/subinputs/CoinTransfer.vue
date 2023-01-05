<template>
  <div class="mt-5">
    <h4 class="mb-0">Coint transfer details</h4>

    <v-text-field
      type="number"
      variant="underlined"
      placeholder="Transfer amount"
      @input="(e:any) => $emit('updateRest', e.target.value, 0)"
    />

    <v-text-field
      type="text"
      variant="underlined"
      placeholder="Reciever address"
      @input="(e:any) => $emit('updateRest', e.target.value, 1)"
    />
  </div>
</template>
