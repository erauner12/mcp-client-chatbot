import { existsSync, writeFileSync } from "fs";
import { MCP_CONFIG_PATH } from "lib/const";

const DEFAULT_CONFIG = {
  playwright: {
    command: "npx",
    args: ["@playwright/mcp@latest"],
  },
  custom: {
    // Use node to run the compiled JavaScript file
    command: "node",
    // Point to the compiled output in the dist directory
    args: ["custom-mcp-server/dist/index.js"],
  },
};

try {
  if (!existsSync(MCP_CONFIG_PATH)) {
    writeFileSync(MCP_CONFIG_PATH, JSON.stringify(DEFAULT_CONFIG, null, 2));
    console.log("✅ .mcp-config.json has been generated successfully");
  } else {
    console.log("✅ .mcp-config.json already exists");
  }
} catch (error) {
  console.error("❌ Failed to generate .mcp-config.json:", error);
  process.exit(1);
}
