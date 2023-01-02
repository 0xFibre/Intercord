import { connection } from "..";
import { provider } from "../provider";
import { Dao as IDao } from "../types";
import { SuiObject, SuiMoveObject, SuiData } from "@mysten/sui.js";
import { env } from "@/config";
import { Proposal } from "./proposal";

interface CreateDaoPayload {
  name: string;
  description: string;
  links: string[];
  logoUrl: string;
  coverUrl: string;
}

export class Dao {
  public module: string;
  public proposal: Proposal;

  constructor() {
    this.module = "dao";
    this.proposal = new Proposal();
  }

  async create(payload: CreateDaoPayload) {
    const data = {
      package: env.fibrePackageId,
      module: this.module,
      function: "create_dao",
      valueArgs: [
        payload.name,
        payload.description,
        payload.logoUrl,
        payload.coverUrl,
        payload.links,
      ],
    };

    return await connection.executeMoveCall(data);
  }

  async getDao(id: string): Promise<IDao> {
    const object = await provider.getObject(id);
    if (object.status == "Exists") {
      const { fields } = <SuiData & SuiMoveObject>(
        (<SuiObject>object.details).data
      );

      return {
        id: fields.id.id,
        config: {
          logo_url: fields.config.fields.logo_url,
          cover_url: fields.config.fields.cover_url,
          links: fields.config.fields.links.map((link: any) => ({
            ...link.fields,
          })),
        },
        description: fields.description,
        name: fields.name,
        proposals: fields.proposals,
        proposals_count: fields.proposals_count,
      };
    }
    throw new Error("Dao does not exist");
  }
}
