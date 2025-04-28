# MCP Client Chatbot

**English** | [한국어](./docs/ko.md)

[![Local First](https://img.shields.io/badge/Local-First-blueviolet)](#)
[![MCP Supported](https://img.shields.io/badge/MCP-Supported-00c853)](https://modelcontextprotocol.io/introduction)

**MCP Client Chatbot** is a versatile chat interface that supports various AI model providers like [OpenAI](https://openai.com/), [Anthropic](https://www.anthropic.com/), [Google](https://ai.google.dev/), and [Ollama](https://ollama.com/). **It is designed for instant execution in 100% local environments without complex configuration**, enabling users to fully control computing resources on their personal computer or server.

> Built with [Vercel AI SDK](https://sdk.vercel.ai) and [Next.js](https://nextjs.org/), this app adopts modern patterns for building AI chat interfaces. Leverage the power of [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction) to seamlessly integrate external tools into your chat experience.

**🌟 Open Source Project**
MCP Client Chatbot is a 100% community-driven open source project.

## Table of Contents

- [MCP Client Chatbot](#mcp-client-chatbot)
  - [Table of Contents](#table-of-contents)
  - [Demo](#demo)
    - [🧩 Browser Automation with Playwright MCP](#-browser-automation-with-playwright-mcp)
    - [⚡️ Quick Tool Mentions (`@`)](#️-quick-tool-mentions-)
    - [🔌 Adding MCP Servers Easily](#-adding-mcp-servers-easily)
    - [🛠️ Standalone Tool Testing](#️-standalone-tool-testing)
  - [✨ Key Features](#-key-features)
  - [🚀 Getting Started](#-getting-started)
    - [Environment Variables](#environment-variables)
    - [MCP Server Setup](#mcp-server-setup)
  - [🐳 Docker Deployment](#-docker-deployment)
    - [Building the Image](#building-the-image)
    - [Pushing to Docker Hub](#pushing-to-docker-hub)
    - [Running the Container](#running-the-container)
    - [Optional PostgreSQL Container](#optional-postgresql-container)
  - [💡 Use Cases](#-use-cases)
  - [🗺️ Roadmap: Upcoming Features](#️-roadmap-upcoming-features)
  - [🙌 Contributing](#-contributing)

---

## Demo

Here are some quick examples of how you can use MCP Client Chatbot:

---

### 🧩 Browser Automation with Playwright MCP

![playwright-demo](./docs/images/preview-1.gif)

**Example:** Control a web browser using Microsoft's [playwright-mcp](https://github.com/microsoft/playwright-mcp) tool.

Sample prompt:

```prompt
Please go to GitHub and visit the cgoinglove profile.
Open the mcp-client-chatbot project.
Then, click on the README.md file.
After that, close the browser.
Finally, tell me how to install the package.
```
---


### ⚡️ Quick Tool Mentions (`@`)

![mention](https://github.com/user-attachments/assets/45d26beb-2143-4b29-b229-8ed2d765fe2b)

Quickly call any registered MCP tool during chat by typing `@toolname`. No need to memorize — just type `@` and pick from the list!

---

### 🔌 Adding MCP Servers Easily

![mcp-server-install](https://github.com/user-attachments/assets/c71fd58d-b16e-4517-85b3-160685a88e38)

Add new MCP servers easily through the UI, and start using new tools without restarting the app.

---

### 🛠️ Standalone Tool Testing

![tool-test](https://github.com/user-attachments/assets/980dd645-333f-4e5c-8ac9-3dc59db19e14)


MCP tools independently from chat sessions for easier development and debugging.

---


## ✨ Key Features

* **💻 100% Local Execution:** Run directly on your PC or server without complex deployment, fully utilizing and controlling your computing resources.
* **🤖 Multiple AI Model Support:** Flexibly switch between providers like OpenAI, Anthropic, Google AI, and Ollama.
* **🛠️ Powerful MCP Integration:** Seamlessly connect external tools (browser automation, database operations, etc.) into chat via Model Context Protocol.
* **🚀 Standalone Tool Tester:** Test and debug MCP tools separately from the main chat interface.
* **💬 Intuitive Mentions:** Trigger available tools with `@` in the input field.
* **⚙️ Easy Server Setup:** Configure MCP connections via UI or `.mcp-config.json` file.
* **📄 Markdown UI:** Communicate in a clean, readable markdown-based interface.
* **💾 Zero-Setup Local DB:** Uses SQLite by default for local storage (PostgreSQL also supported).
* **🧩 Custom MCP Server Support:** Modify the built-in MCP server logic or create your own.

## 🚀 Getting Started

This project uses [pnpm](https://pnpm.io/) as the recommended package manager.

```bash
# 1. Install dependencies
pnpm i

# 2. Initialize project (creates .env, sets up DB)
pnpm initial

# 3. Start dev server
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser to get started.

-----

### Environment Variables

The `pnpm initial` command generates a `.env` file. Add your API keys there:

```dotenv
# .env.example content, copy to .env and fill values
GOOGLE_GENERATIVE_AI_API_KEY=****
OPENAI_API_KEY=****
XAI_API_KEY=****
ANTHROPIC_API_KEY=****
POSTGRES_URL=postgres://postgres:postgres@localhost:5432/chatbot
FILEBASE_URL=file:node_modules/local.db
USE_FILE_SYSTEM_DB=true
```

SQLite is the default DB (`db.sqlite`). To use PostgreSQL, set `USE_FILE_SYSTEM_DB=false` and define `POSTGRES_URL` in `.env`. Ensure your Postgres server is running and accessible.

-----

### MCP Server Setup

You can connect MCP tools via:

1. **UI Setup:** Go to http://localhost:3000/mcp and configure through the interface.
2. **Direct File Edit:** Modify `.mcp-config.json` in project root.
3. **Custom Logic:** Edit `./custom-mcp-server/index.ts` to implement your own logic.

-----

## 🐳 Docker Deployment

This project includes a `Dockerfile` at the root to build the Next.js application image.

### Building the Image

Use the provided pnpm script to build the Docker image. It tags the image with `latest` and the short Git commit hash.

```bash
# Ensure you have Docker running
# This command looks for Dockerfile in the project root
pnpm docker:build
```

This command executes:
`docker build -t erauner12/mcp-client-chatbot:latest -t erauner12/mcp-client-chatbot:$(git rev-parse --short HEAD) .`

### Pushing to Docker Hub

After building, push the image to your Docker Hub repository (`erauner12/mcp-client-chatbot`). Ensure you are logged into Docker Hub (`docker login`).

```bash
pnpm docker:push
```

This command executes:
`docker push erauner12/mcp-client-chatbot:latest && docker push erauner12/mcp-client-chatbot:$(git rev-parse --short HEAD)`

### Running the Container

You can run the built image directly using `docker run`. Remember to pass necessary environment variables.

```bash
# Example using SQLite (ensure USE_FILE_SYSTEM_DB=true in your .env or pass it here)
# Note: Use separate -e flags for each variable and ensure no inline comments.
# Use quotes around variable values, especially if they contain special characters.
docker run -it --rm -p 3000:3000 \
  -e OPENAI_API_KEY="YOUR_OPENAI_KEY" \
  -e USE_FILE_SYSTEM_DB="true" \
  -e FILEBASE_URL="file:/app/data/local.db" \
  -e NEXTAUTH_SECRET="YOUR_RANDOM_SECRET" \
  -v mcp_chatbot_data:/app/data \
  erauner12/mcp-client-chatbot:latest
```

**Notes:**
- Replace `YOUR_OPENAI_KEY` and `YOUR_RANDOM_SECRET` with actual values. Generate a strong secret for `NEXTAUTH_SECRET`.
- The `-v mcp_chatbot_data:/app/data` line creates a named volume `mcp_chatbot_data` to persist the SQLite database outside the container. The internal path `/app/data` is used for the volume mount point; ensure `FILEBASE_URL` points within this mounted directory (e.g., `file:/app/data/local.db`).
- If using PostgreSQL, ensure the `POSTGRES_URL` environment variable points to your running Postgres instance (e.g., `postgres://user:pass@host:port/db`) and set `USE_FILE_SYSTEM_DB=false`.

### Optional PostgreSQL Container

The project includes helper scripts to build and run a PostgreSQL container specifically for development or testing purposes, using the Dockerfile in `docker/pg/`.

```bash
# Build the Postgres helper image (tagged as chatbot-pg)
# This uses docker/pg/Dockerfile
pnpm docker:build-pg

# Start the Postgres container (named chatbot-postgres)
pnpm docker:start-pg

# Stop and remove the Postgres container
pnpm docker:stop-pg
```

When using this helper container, your `POSTGRES_URL` would typically be `postgres://postgres:postgres@localhost:5432/chatbot` if running the main app locally, or `postgres://postgres:postgres@chatbot-postgres:5432/chatbot` if running the main app in Docker on the same Docker network.

-----

## 💡 Use Cases

* [Supabase Integration](./docs/use-cases/supabase.md): Use MCP to manage Supabase DB, auth, and real-time features.

-----

## 🗺️ Roadmap: Upcoming Features

We're making MCP Client Chatbot even more powerful with these planned features:

* **🎨 Canvas Mode:** Real-time editing interface for LLM + user collaboration (e.g. code, blogs).
* **🧩 LLM UI Generation:** Let LLMs render charts, tables, forms dynamically.
* **📜 Rule Engine:** Persistent system prompt/rules across the session.
* **🖼️ Image & File Uploads:** Multimodal interaction via uploads and image generation.
* **🐙 GitHub Mounting:** Mount local GitHub repos to ask questions and work on code.
* **📚 RAG Agent:** Retrieval-Augmented Generation using your own documents.
* **🧠 Planning Agent:** Smarter agent that plans and executes complex tasks.
* **🧑‍💻 Agent Builder:** Tool to create custom AI agents for specific goals.

👉 See full roadmap in [ROADMAP.md](./docs/ROADMAP.md)

-----

## 🙌 Contributing

We welcome all contributions! Bug reports, feature ideas, code improvements — everything helps us build the best local AI assistant.

Let’s build it together 🚀