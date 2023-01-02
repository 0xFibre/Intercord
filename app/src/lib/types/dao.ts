export interface Dao {
  id: string;
  name: string;
  description: string;
  proposals: string[];
  proposals_count: string;
  config: DaoConfig;
}

interface DaoConfig {
  cover_url: string;
  logo_url: string;
  links: { data: string; pointer: string }[];
}
