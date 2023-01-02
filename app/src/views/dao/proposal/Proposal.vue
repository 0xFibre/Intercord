<template>
  <v-row>
    <v-col md="8" sm="12" cols="12">
      <h2 class="mb-3">Lorem, ipsum dolor.</h2>

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
        <p class="mb-3">
          Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quasi fugiat
          quas incidunt blanditiis, suscipit dolorum adipisci consequatur,
          officiis quaerat delectus aliquid dolore.
        </p>

        <p class="mb-3">
          Quisquam enim nulla facilis amet, facere nam error illum expedita
          ipsum minima ab suscipit consequatur impedit quos sunt rem repellendus
          atque quidem dolor praesentium! Aspernatur dolores ullam consectetur
          velit atque, libero dolor.
        </p>

        <p class="mb-3">
          Atque maiores non sequi dignissimos, consectetur accusamus eius! Non
          quibusdam laborum illo culpa dolore praesentium repellendus!
        </p>
      </div>

      <v-sheet flat class="d-flex mt-10 pe-3">
        <v-list-item
          border
          width="50%"
          class="pa-2"
          title="Proposal"
          subtitle="0xa1505...5185e01"
          target="_blank"
          :href="`https://explorer.sui.io/object/${$route.params.proposalId}`"
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
          :href="`https://explorer.sui.io/object/${$route.params.proposalId}`"
          prepend-icon="mdi-account-outline"
        />
      </v-sheet>
    </v-col>

    <v-col md="4" sm="12" cols="12">
      <!-- <v-card flat border>
        <v-card-text> -->
      <div>
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
  </v-row>
</template>
