<template>
  <v-row>
    <v-col md="6" cols="12">
      <h3 class="mb-5">DAO information</h3>

      <div class="my-2 d-flex justify-space-between">
        <span class="font-weight-medium">Name:</span>
        <span>{{ dao.name }}</span>
      </div>
      <div class="my-2 d-flex justify-space-between">
        <span class="font-weight-medium">Total members:</span>
        <span>{{ 0 }}</span>
      </div>
      <div class="my-2 d-flex justify-space-between">
        <span class="font-weight-medium">Total proposals:</span>
        <span>{{ dao.proposals_count }}</span>
      </div>
    </v-col>

    <v-col md="6" cols="12">
      <h3 class="mb-5">DAO links</h3>

      <template v-for="(link, i) in dao.config.links">
        <v-divider v-if="i !== 0" class="my-2" />
        <div class="d-flex justify-space-between">
          <v-avatar size="15">
            <v-img :src="getIconUrl(link.data)" />
          </v-avatar>

          <v-btn
            flat
            density="compact"
            class="pa-0 ma-0"
            target="_blank"
            :href="link.data"
          >
            {{ link.data }}
          </v-btn>
        </div>
      </template>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import { defineProps } from "vue";

defineProps(["dao"]);

function getIconUrl(link: string) {
  const platform = getPlatform(link);
  return `/assets/icons/${platform}.svg`;
}

function getPlatform(text: string) {
  const parts = new URL(text).hostname.split(".");

  // new RegExp(
  //     "(^|^[^:]+:\/\/|[^\.]+\.)" +
  //       parts[parts.length - 2] +
  //       "\." +
  //       parts[parts.length - 1],
  //     "gm"
  //   )

  return parts[parts.length - 2];
}
</script>
