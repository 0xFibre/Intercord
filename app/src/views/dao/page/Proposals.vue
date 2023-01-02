<template>
  <v-row>
    <template v-for="proposal in state.proposals">
      <v-col md="4" cols="12">
        <v-card :to="`/proposals/${proposal.id}`" flat border height="170px">
          <v-card-text style="height: 130px">
            <h3 class="mb-3">{{ proposal.title }}</h3>
            <p>
              Lorem ipsum, dolor sit amet consectetur adipisicing elit. Vel sit,
              totam aperiam doloremque facere nihil ducimus, molestiae molestias
              inventoree...
            </p>
          </v-card-text>

          <v-card-action class="d-flex">
            <div class="ps-3 d-flex">
              <div>
                <v-icon size="15" icon="mdi-vote-outline" />
                <span style="font-size: 13px"> 2,590 </span>
              </div>

              <!-- &nbsp;&nbsp;

              <div>
                <v-icon size="15" icon="mdi-account-outline" />
                <v-btn
                  flat
                  tyle="font-size: 12px"
                  class="pa-0"
                  density="compact"
                >
                  {{ "0x9c6...1378" }}
                </v-btn>
              </div> -->
            </div>

            <v-spacer />

            <div class="pe-3">
              <v-chip label density="compact" color="success"> Active </v-chip>
            </div>
          </v-card-action>
        </v-card>
      </v-col>
    </template>
  </v-row>
</template>

<script lang="ts" setup>
import { dao } from "@/lib";
import { Proposal } from "@/lib/types";
import { onMounted, reactive } from "vue";

interface State {
  proposals: Proposal[];
}

const props = defineProps(["proposalIds"]);
const state: State = reactive({ proposals: [] });

onMounted(async () => {
  const proposals = await dao.proposal.getProposals(props.proposalIds);
  state.proposals = proposals;
});
</script>
