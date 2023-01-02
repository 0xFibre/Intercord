<template>
  <v-row>
    <v-col md="6" class="mx-auto">
      <v-window v-model="state.window.current">
        <v-window-item :value="0">
          <div class="my-3">
            <h3 class="mb-1">DAO Information</h3>
            <p class="mt-1">Provide the basic information about your DAO</p>
          </div>

          <v-text-field
            v-model="state.input.name"
            variant="underlined"
            placeholder="Enter DAO name"
          />
          <v-textarea
            v-model="state.input.description"
            variant="underlined"
            placeholder="Enter DAO description"
          />
        </v-window-item>

        <v-window-item :value="1" class="px-3">
          <div class="my-3">
            <h3 class="mb-1">DAO links</h3>
            <p class="mt-1">
              Add your DAO website link, social media links and other relevant
              links
            </p>
          </div>

          <template v-for="i in state.input.links.length">
            <div class="d-flex">
              <v-text-field
                variant="underlined"
                placeholder="https://example.com"
                v-model="state.input.links[i]"
              >
                <template v-slot:prepend>
                  <v-btn
                    rounded
                    flat
                    size="40"
                    @click="state.input.links.splice(i)"
                    icon="mdi-minus-circle-outline"
                  />
                </template>
              </v-text-field>
            </div>
          </template>

          <div class="mb-3 d-flex">
            <v-spacer />
            <v-btn
              rounded
              flat
              density="compact"
              prepend-icon="mdi-plus"
              @click="() => state.input.links.push('')"
            >
              add link
            </v-btn>
          </div>
        </v-window-item>

        <v-window-item :value="2">
          <div class="my-3">
            <h3 class="mb-1">DAO assets</h3>
            <p class="mt-1">Add a logo and cover image to your DAO.</p>
          </div>

          <div style="position: relative">
            <v-img
              height="150px"
              width="100%"
              cover
              style="position;: relative"
              src="https://images.pexels.com/photos/268941/pexels-photo-268941.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
            />

            <v-avatar rounded size="100" style="position;: absolute; top: 40">
              <v-img src="https://img.icons8.com/ios/512/image.png" />
            </v-avatar>
          </div>
        </v-window-item>
      </v-window>

      <div class="d-flex mt-3">
        <v-btn
          rounded
          flat
          color="primary"
          :disabled="!state.window.hasPrev"
          prepend-icon="mdi-chevron-left"
          @click="back"
        >
          Back
        </v-btn>

        <v-spacer />

        <v-btn
          rounded
          v-if="state.window.current === state.window.steps"
          flat
          color="primary"
          append-icon="mdi-check-circle"
          @click="createDao"
        >
          Create DAO
        </v-btn>

        <v-btn
          rounded
          v-else
          flat
          color="primary"
          :disabled="!state.window.hasNext"
          append-icon="mdi-chevron-right"
          @click="next"
        >
          Next
        </v-btn>
      </div>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import { dao } from "@/lib";
import { reactive } from "vue";

interface State {
  window: {
    steps: number;
    current: number;
    hasNext: boolean;
    hasPrev: boolean;
  };
  input: {
    name: string;
    description: string;
    links: string[];
  };
}

const state: State = reactive({
  window: {
    steps: 2,
    current: 0,
    hasNext: true,
    hasPrev: false,
  },
  input: {
    name: "",
    description: "",
    links: [""],
  },
});

function next() {
  state.window.current += 1;
  state.window.hasPrev = state.window.current > 0;
  state.window.hasNext = state.window.current < state.window.steps;
}

function back() {
  state.window.current -= 1;
  state.window.hasPrev = state.window.current > 0;
  state.window.hasNext = state.window.current < state.window.steps;
}

async function createDao() {
  const data = {
    name: state.input.name,
    description: state.input.description,
    links: state.input.links.filter((link) => link !== "" || !!link),
    logoUrl: "",
    coverUrl: "",
  };

  const newDao = await dao.create(data);
  console.log(newDao);
}
</script>
