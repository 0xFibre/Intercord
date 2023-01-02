interface Env {
  fibrePackageId: string;
}

const environment = import.meta.env;

export const env: Env = {
  fibrePackageId: environment.VITE_FIBRE_PACKAGE_ID || "",
};
