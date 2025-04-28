import type { NextConfig } from "next";

export default (phase: string, { defaultConfig }) => {
  if (phase?.endsWith("-build")) {
    process.env.MCP_NO_INITIAL = "true";
  }
  const nextConfig: NextConfig = {
    output: "standalone",
    // Remove @libsql/client from here - let the bundler handle it
    // serverExternalPackages: ["@libsql/client"],
    /* config options here */
  };
  return nextConfig;
};
