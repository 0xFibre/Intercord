<template>
  <div class="mt-5">
    <h4 class="mb-0">Coint transfer details</h4>

    <v-text-field
      type="number"
      variant="underlined"
      placeholder="Transfer amount"
      v-model="state.input[0]"
      @input="onInput(0)"
    />

    <v-text-field
      type="text"
      variant="underlined"
      placeholder="Reciever address"
      v-model="state.input[1]"
      @input="onInput(1)"
    />
  </div>
</template>

<script lang="ts" setup>
import { reactive } from "vue";

const emit = defineEmits(["updateRest"]);
const state: { input: any[] } = reactive({ input: [0, ""] });

function onInput(id: number) {
  emit("updateRest", state.input[id]);
}
</script>
