import { env } from "@/config";
import { SuiData, SuiMoveObject, SuiObject } from "@mysten/sui.js";
import { connection } from "..";
import { provider } from "../provider";
import { Proposal as IProposal } from "../types";

interface CreateProposalayload {
  daoId: string;
  type: number;
  title?: string;
  description: string;
  rest: any[];
}

export class Proposal {
  public module: string;

  constructor() {
    this.module = "dao_proposal";
  }

  async create(payload: CreateProposalayload) {
    switch (payload.type) {
      case 0:
        return await this.createPlainProposal(payload);
      case 1:
        return await this.createPollProposal(payload);
      case 2:
        return await this.createCoinTransferProposal(payload);
      default:
        throw new Error("Invalid proposal type");
    }
  }

  private async createPlainProposal(payload: CreateProposalayload) {
    const data = {
      package: env.fibrePackageId,
      module: this.module,
      function: "create_plain_proposal",
      valueArgs: [payload.daoId, payload.title, payload.description],
    };

    return await connection.executeMoveCall(data);
  }

  private async createPollProposal(payload: CreateProposalayload) {
    const data = {
      package: env.fibrePackageId,
      module: this.module,
      function: "create_poll_proposal",
      valueArgs: [payload.daoId, payload.description, payload.rest],
    };

    return await connection.executeMoveCall(data);
  }

  private async createCoinTransferProposal(payload: CreateProposalayload) {
    const data = {
      package: env.fibrePackageId,
      module: this.module,
      function: "create_coin_transfer_proposal",
      typeArgs: ["0x2::sui::SUI"],
      valueArgs: [
        payload.daoId,
        payload.description,
        payload.rest[0],
        payload.rest[1],
      ],
    };

    return await connection.executeMoveCall(data);
  }

  async getProposals(ids: string[]): Promise<IProposal[]> {
    const proposals: IProposal[] = [];
    const objects = await provider.getObjectBatch(ids);

    for (let i = 0; i < objects.length; i++) {
      const object = objects[i];

      if (object.status == "Exists") {
        const { fields } = <SuiData & SuiMoveObject>(
          (<SuiObject>object.details).data
        );

        const proposal: IProposal = {
          id: fields.id.id,
          daoId: fields.dao_id,
          description: fields.description,
          title: fields.title,
          status: fields.status,
          type: fields.type,
          pointer: fields.pointer,
          proposer: fields.proposer,
        };

        proposals.push(proposal);
      }
    }

    return proposals;
  }

  async getProposal(id: string): Promise<IProposal> {
    const object = await provider.getObject(id);

    if (object.status == "Exists") {
      const { fields } = <SuiData & SuiMoveObject>(
        (<SuiObject>object.details).data
      );

      const proposal: IProposal = {
        id: fields.id.id,
        daoId: fields.dao_id,
        description: fields.description,
        title: fields.title,
        status: fields.status,
        type: fields.type,
        pointer: fields.pointer,
        proposer: fields.proposer,
      };

      const objects = await provider.getObjectsOwnedByObject(proposal.id);
      if (objects.length > 0) {
        const loadedObject = await provider.getObject(objects[0].objectId);
        if (loadedObject.status === "Exists") {
          const { data } = loadedObject.details;
          proposal.meta = data.fields.value.fields;
        }
      }

      return proposal;
    }

    throw new Error("Proposal not found");
  }
}
