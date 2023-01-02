export interface Proposal {
  id: string;
  title: string;
  description: string;
  pointer: string;
  type: number;
  status: number;
  daoId: string;
  proposer: string;
  meta?: TransferMeta | string[];
}

interface TransferMeta {
  amount: string;
  recipient: string;
}
