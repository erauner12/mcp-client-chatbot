import type { NextConfig } from "next";

export default (phase: string, { defaultConfig }) => {
  if (phase?.endsWith("-build")) {
    process.env.MCP_NO_INITIAL = "true";
  }
  const nextConfig: NextConfig = {
    output: "standalone", // Add this line
    serverExternalPackages: ["@libsql/client"],
    /* config options here */
  };
  return nextConfig;
};