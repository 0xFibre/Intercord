<template>
  <v-row>
    <template v-if="state.proposal && !state.loading">
      <v-col md="8" sm="12" cols="12">
        <h2 class="mb-3">{{ state.proposal.title }}</h2>

        <div class="d-flex mb-5">
          <v-chip label density="comfortable" color="success"> Active </v-chip>
          <v-spacer />
          <v-btn
            class="ma-0"
            flat
            density="comfortable"
            prepend-icon="mdi-share-variant"
          >
            Share
          </v-btn>
        </div>

        <div class="mt-3">
          {{ state.proposal.description }}
        </div>

        <v-sheet flat class="d-flex mt-10 pe-3">
          <v-list-item
            border
            width="50%"
            class="pa-2"
            title="Proposal"
            subtitle="0xa1505...5185e01"
            target="_blank"
            :href="`https://explorer.sui.io/object/${state.proposal.id}`"
            prepend-icon="mdi-file-document-edit-outline"
          />

          <v-spacer class="mx-2" />

          <v-list-item
            border
            width="50%"
            class="pa-2"
            title="Proposer"
            subtitle="0xa1505...5185e01"
            target="_blank"
            :href="`https://explorer.sui.io/address/${state.proposal.proposer}`"
            prepend-icon="mdi-account-outline"
          />
        </v-sheet>
      </v-col>

      <v-col md="4" sm="12" cols="12">
        <!-- <v-card flat border>
            <v-card-text> -->
        <div v-if="state.proposal.type == 1">
          <h3 class="mb-3">Poll options</h3>

          <template v-for="option in (state.proposal.meta as any).options">
            <v-btn block flat variant="tonal" class="my-2">
              {{ option }}
            </v-btn>
          </template>
        </div>

        <div v-else>
          <h3 class="mb-3">Voting</h3>
          <v-btn block flat color="success" variant="tonal" class="my-2">
            Yes
          </v-btn>
          <v-btn block flat color="error" variant="tonal" class="my-2">
            No
          </v-btn>
          <v-btn block flat variant="tonal" class="my-2"> Abstain </v-btn>
        </div>
        <!-- </v-card-text>
                </v-card> -->
      </v-col>
    </template>
    <template v-else>
      <Loader />
    </template>
  </v-row>
</template>

<script lang="ts" setup>
import Loader from "@/components/Loader.vue";
import { dao } from "@/lib";
import { Proposal } from "@/lib/types";
import { reactive, onMounted } from "vue";
import { useRoute } from "vue-router";

interface State {
  loading: boolean;
  proposal?: Proposal;
}

const route = useRoute();
const state: State = reactive({ loading: false, proposal: undefined });

onMounted(async () => {
  state.loading = true;
  state.proposal = await dao.proposal.getProposal(
    <string>route.params.proposalId
  );
  state.loading = false;
});
</script>
