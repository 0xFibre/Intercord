import { createRouter, createWebHistory } from "vue-router";

import Connect from "@/views/Connect.vue";
import CreateDao from "@/views/dao/Create.vue";
import DaoPage from "@/views/dao/Dao.vue";
import CreateDaoProposal from "@/views/dao/proposal/Create.vue";
import ProposalPage from "@/views/dao/proposal/Proposal.vue";

const routes = [
  {
    path: "/",
    component: () => import("@/layouts/default/Default.vue"),
    children: [
      {
        path: "/connect",
        name: "Connect",
        component: Connect,
      },
      {
        path: "/dao/create",
        name: "CreateDao",
        component: CreateDao,
      },
      {
        path: "/dao/:daoId",
        name: "DaoPage",
        component: DaoPage,
      },
      {
        path: "/dao/:daoId/proposal/create",
        name: "CreateDaoProposal",
        component: CreateDaoProposal,
      },
      {
        path: "/proposals/:proposalId",
        name: "ProposalPage",
        component: ProposalPage,
      },
    ],
  },
];

export const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});
