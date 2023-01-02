<template>
  <v-row>
    <v-col md="6" class="mx-auto">
      <h3 class="">Create a Proposal</h3>

      <v-select
        v-model="state.input.type"
        placeholder="Proposal type"
        :items="state.options"
        @update:modelValue="() => (state.input.rest = [])"
        item-title="title"
        item-value="id"
        variant="underlined"
      />
      <v-text-field
        v-if="state.input.type === 0"
        v-model="state.input.title"
        variant="underlined"
        placeholder="Proposal title"
      />
      <v-textarea
        variant="underlined"
        v-model="state.input.description"
        placeholder="Proposal description"
      />

      <Poll
        :data="state.input.rest"
        v-if="state.input.type === 1"
        @updateRest="updateRest"
      />
      <Transfer v-if="state.input.type === 2" @updateRest="updateRest" />

      <v-btn
        rounded
        flat
        block
        color="primary"
        variant="flat"
        class="my-3"
        @click="createProposal"
      >
        Create proposal
      </v-btn>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import { dao } from "@/lib";
import { reactive } from "vue";
import Poll from "./subinputs/Poll.vue";
import Transfer from "./subinputs/CoinTransfer.vue";
import { useRoute } from "vue-router";

type RestType = any[];
interface State {
  options: { title: string; id: number }[];
  input: {
    type: number;
    title?: string;
    description: string;
    rest: RestType;
  };
}

const route = useRoute();
const options = [
  { title: "Plain proposal", id: 0 },
  { title: "Poll proposal", id: 1 },
  { title: "Coin Transfer proposal", id: 2 },
];

const state: State = reactive({
  options,
  input: {
    type: 0,
    title: "",
    description: "",
    rest: [],
  },
});

function updateRest(value: RestType, index: number) {
  state.input.rest[index] = value;
}

async function createProposal() {
  const data = {
    daoId: route.params.daoId as string,
    type: state.input.type,
    title: state.input.title,
    description: state.input.description,
    rest: state.input.rest.filter((r) => r !== "" || !!r),
  };

  const response = await dao.proposal.create(data);
  console.log(response);
}
</script>
