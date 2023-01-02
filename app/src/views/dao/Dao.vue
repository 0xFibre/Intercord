<template>
  <template v-if="!state.data.loading && state.data.dao">
    <v-img
      cover
      class="rounded"
      height="200px"
      style="position;: relative"
      src="https://images.pexels.com/photos/268941/pexels-photo-268941.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
    />

    <div class="ms-3" style="position: relative; top: -40px">
      <div class="d-flex">
        <v-avatar rounded size="100" style="border: 3.5px solid white">
          <v-img
            cover
            src="https://cdn.pixabay.com/photo/2017/06/10/09/43/colorful-background-2389472_1280.jpg"
          />
        </v-avatar>

        <v-spacer />

        <div class="mt-10">
          <v-btn rounded flat variant="outlined" class="my-3 mx-1">
            <template v-slot:prepend>
              <v-icon icon="mdi-cog" />
            </template>
            Settings
          </v-btn>

          <v-btn
            id="new-btn"
            color="primary"
            rounded
            flat
            variant="flat"
            class="my-3 mx-1"
          >
            <template v-slot:prepend>
              <v-icon icon="mdi-plus" />
            </template>

            New
          </v-btn>

          <v-menu
            location="start"
            location-strategy="connected"
            activator="#new-btn"
          >
            <v-list>
              <v-list-item
                v-for="(item, i) in state.newItems"
                :key="i"
                :value="i"
                :prepend-icon="item.icon"
                :to="item.path"
              >
                <v-list-item-title>Create a {{ item.title }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </div>
      </div>

      <div class="mt-3">
        <h3>{{ state.data.dao.name }}</h3>
        <p>{{ state.data.dao.description }}</p>
      </div>
    </div>

    <div class="mb-5">
      <v-tabs slider-color="primary" v-model="state.tab.current">
        <v-tab :prepend-icon="tab.icon" v-for="(tab, i) in state.tab.items">
          {{ tab.text }}
        </v-tab>
      </v-tabs>
      <v-divider />
    </div>

    <v-window v-model="state.tab.current">
      <v-window-item :value="0">
        <Proposals :proposalIds="state.data.dao.proposals" />
      </v-window-item>
      <v-window-item :value="3">
        <About :dao="state.data.dao" />
      </v-window-item>
    </v-window>
  </template>
  <template v-else>
    <Loader />
  </template>
</template>

<script lang="ts" setup>
import Loader from "@/components/Loader.vue";
import { dao } from "@/lib";
import { Dao } from "@/lib/types";
import { onMounted, reactive } from "vue";
import { useRoute } from "vue-router";
import About from "./page/About.vue";
import Proposals from "./page/Proposals.vue";

console.log("heyyy");
interface State {
  data: {
    loading: boolean;
    dao?: Dao;
  };
  tab: {
    items: { text: string; icon: string }[];
    current: number;
  };
  newItems: { title: string; icon: string; path?: string }[];
}

const route = useRoute();

const state: State = reactive({
  data: {
    loading: true,
    dao: undefined,
  },
  tab: {
    items: [
      { text: "Proposals", icon: "mdi-file-document-edit-outline" },
      { text: "Treasury", icon: "mdi-wallet" },
      //   { text: "Events", icon: "mdi-calendar" },
      { text: "Members", icon: "mdi-account-multiple-outline" },
      { text: "About", icon: "mdi-information-outline" },
    ],
    current: 0,
  },
  newItems: [
    {
      title: "Proposal",
      icon: "mdi-file-document-edit-outline",
      path: `/dao/${route.params.daoId}/proposal/create`,
    },
    { title: "Join Request", icon: "mdi-account-plus" },
  ],
});

onMounted(async () => {
  state.data.loading = true;
  const result = await dao.getDao(route.params.daoId as string);
  console.log(result);

  state.data.dao = result;
  state.data.loading = false;
});
</script>
