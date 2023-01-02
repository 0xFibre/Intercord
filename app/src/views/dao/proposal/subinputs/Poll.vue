<template>
  <h4 class="mt-5 mb-0">Poll options</h4>

  <template v-for="(d, i) in data">
    <v-text-field
      type="text"
      variant="underlined"
      :placeholder="`Option ${i}`"
      :value="data[i]"
      @input="(e) => $emit('updateRest', e.target.value, i)"
    />
  </template>

  <div class="d-flex">
    <v-spacer />

    <v-btn
      flat
      density="compact"
      class="pa-0"
      prepend-icon="mdi-plus"
      @click="$emit('updateRest', '', data.length)"
    >
      add option
    </v-btn>
  </div>
</template>

<script lang="ts" setup>
defineProps(["data"]);
</script>
