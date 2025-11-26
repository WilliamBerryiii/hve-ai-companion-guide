# MCP Server Setup (Optional)

You've verified that all five chat modes work correctly. Your HVE environment is now fully functional for the core workflows covered in this book.

This section covers an **optional enhancement**: Model Context Protocol (MCP) configuration. MCP extends GitHub Copilot's capabilities with specialized external data access—but isn't required to complete this book or use HVE effectively.

If you're working through this book as a first-time learner, feel free to skip this section and return later when you need external documentation access or development operations automation.

## What is MCP and Why It Matters

**GitHub Copilot** provides comprehensive AI assistance using your workspace files, chat history, and training data. **Model Context Protocol (MCP)** extends Copilot with specialized external servers for documentation access and development operations.

**Without MCP:**

* GitHub Copilot uses: Your workspace files + chat history + AI training data
* Capabilities: Code completion, chat assistance, workspace understanding
* Limitations: No access to latest SDK docs, package versions, or live development operations (repos, work items)

**With MCP:**

* GitHub Copilot uses: Everything above + MCP servers (documentation, repos, work items, pipelines)
* Additional capabilities: Live documentation lookup, repository operations, work item tracking, CI/CD integration
* Benefits: Research with authoritative external sources, automate development operations

## MCP Server Categories

MCP servers fall into two primary categories based on use case:

### Documentation Servers

Access authoritative technical documentation and SDK references in real-time.

* **Context7** - Multi-language package documentation (npm, PyPI, Maven, NuGet, Packagist)
* **Microsoft Learn** - Microsoft product documentation (Azure, .NET, VS Code, Microsoft 365)

**Use documentation servers when:**

* Researching third-party libraries or frameworks
* Checking package versions and API changes
* Finding code examples for specific SDKs
* Working with Microsoft technologies (Azure, .NET, etc.)

### Development Operations Servers

Automate and streamline interactions with development platforms.

* **GitHub** - Repository management, issues, pull requests, Actions, security
* **Azure DevOps** - Work items, pipelines, repos, test plans, wiki

**Use development operations servers when:**

* Managing GitHub repositories and automating PR workflows
* Tracking work items and planning sprints in Azure DevOps
* Analyzing CI/CD pipeline runs and logs
* Coordinating team collaboration across platforms

> [!NOTE]
> **MCP is optional for HVE workflows.** You can complete this book without configuring any MCP servers. They enhance research quality and development operations but aren't required for core GitHub Copilot functionality.

## MCP Server Comparison

Choose MCP servers based on your technology stack and development workflow needs.

| Feature                | Context7                                                       | Microsoft Learn                                                       | GitHub                                                | Azure DevOps                                   |
|------------------------|----------------------------------------------------------------|-----------------------------------------------------------------------|-------------------------------------------------------|------------------------------------------------|
| **Category**           | Documentation                                                  | Documentation                                                         | Development Operations                                | Development Operations                         |
| **Type**               | Local npm package                                              | Remote HTTP endpoint                                                  | Remote HTTP (recommended) or Docker                   | Local npm package                              |
| **Installation**       | `npx -y @upstash/context7-mcp@latest`                          | No installation (remote endpoint)                                     | Remote: None; Local: Docker or Go binary              | `npx -y @azure-devops/mcp <org-name>`          |
| **Primary Use Case**   | SDK/package documentation (npm, PyPI, Maven, NuGet, Packagist) | Microsoft product documentation (Azure, .NET, VS Code, Microsoft 365) | Repository management, issues, PRs, Actions, security | Work items, pipelines, repos, test plans, wiki |
| **Best For**           | Open-source library research, version checking, API examples   | Microsoft technology stack, Azure services, official docs             | GitHub ecosystem operations and automation            | Azure DevOps ecosystem operations and CI/CD    |
| **Authentication**     | API key (optional, free tier available)                        | None required (public endpoint)                                       | OAuth (remote, via Copilot) or PAT (local)            | OAuth/Interactive browser login                |
| **Coverage**           | Multi-language package registries worldwide                    | Microsoft Learn (learn.microsoft.com) complete catalog                | GitHub.com, GHES, GHEC                                | Azure DevOps Services and Server               |
| **Tools Available**    | 2 tools (resolve-library-id, get-library-docs)                 | 3 tools (search, fetch, code samples)                                 | 100+ tools across 20+ toolsets                        | 80+ tools across 9 domains                     |
| **Complexity**         | Low (simple npm command)                                       | Very Low (just URL)                                                   | Medium (OAuth setup or Docker)                        | Medium (org parameter + OAuth)                 |
| **When to Use**        | Researching third-party libraries, checking package versions   | Working with Azure, .NET, Microsoft 365, Windows                      | Managing GitHub repos, automating issues/PRs          | Managing ADO work items, pipelines, or repos   |
| **Status**             | Production                                                     | Production                                                            | Production                                            | Public Preview                                 |
| **Enterprise Support** | N/A                                                            | N/A                                                                   | GHES, GHEC                                            | Azure DevOps Server                            |

### When to Use Each Server

**Choose Context7 when:**

* Working with open-source libraries across multiple languages (JavaScript, Python, Java, PHP, etc.)
* Need to verify package versions and check for API changes
* Looking for code examples and usage patterns from official package documentation

**Choose Microsoft Learn when:**

* Using Microsoft technologies (Azure, .NET, Visual Studio, Microsoft 365)
* Need authoritative documentation for Microsoft products and services
* Working with Azure cloud services and want up-to-date service documentation

**Choose GitHub when:**

* Managing GitHub repositories and need to automate common operations
* Analyzing issues, pull requests, or GitHub Actions workflows
* Working with GitHub Enterprise Server or Enterprise Cloud
* Need code security analysis or Dependabot operations

**Choose Azure DevOps when:**

* Using Azure DevOps for work item tracking or project management
* Managing CI/CD pipelines with Azure Pipelines
* Need to query or update work items programmatically
* Working with Azure Repos or Azure Test Plans

**Common combinations:**

* **Documentation-focused:** Context7 + Microsoft Learn (covers both open-source and Microsoft docs)
* **Operations-focused:** GitHub + Azure DevOps (covers both platforms)
* **Microsoft stack:** Microsoft Learn + Azure DevOps (comprehensive Microsoft ecosystem)
* **Open-source focus:** Context7 + GitHub (library research and repository operations)
* **Comprehensive:** All four servers (maximum capabilities)

## Installing MCP Extension

Before configuring MCP servers, install the Model Context Protocol extension for VS Code.

**Prerequisites:**

* Node.js 18+ (already installed for hve-core)
* VS Code 1.95+ (latest version recommended)

**Install MCP VS Code Extension:**

1. Open VS Code Extensions view (`Ctrl+Shift+X`)
2. Search: `Model Context Protocol`
3. Install the extension (look for official publisher)
4. Reload VS Code when prompted

> [!NOTE]
> The MCP extension enables VS Code to communicate with MCP servers. No additional SDK installation is required unless you're building custom MCP servers.

## Setting Up MCP Servers

Choose one or more servers based on your technology stack and workflow needs. Each server can be configured independently in your project's `.vscode/mcp.json` file.

### Context7 Setup (Documentation Server)

Context7 provides authoritative SDK and package documentation from npm, PyPI, Maven, NuGet, and Packagist registries.

**Use Context7 when:** Researching open-source libraries, checking package versions, or finding API examples.

**Installation:**

Context7 doesn't require installation—it runs via `npx` each time. Test availability:

```bash
npx -y @upstash/context7-mcp@latest --help
```

**Expected output:** Context7 help information and available commands

**Configuration:**

Create or edit `.vscode/mcp.json` in your project:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

#### Optional: Add API key for higher rate limits

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "CONTEXT7_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

> [!TIP]
> Context7 works without an API key using public registry data. Add `CONTEXT7_API_KEY` only if you need higher rate limits for production use. Visit <https://upstash.com/docs/oss/context7/overview> for details.

**Verification:**

In GitHub Copilot Chat:

```text
Try this test query:

1. Open Copilot Chat sidebar (`Ctrl+Alt+I` or `Cmd+Alt+I`)
2. Click the **agent picker dropdown** and select **task-researcher**
3. Type: `Research the latest version and key features of Express.js`
4. Press Enter

**Expected Response:**
```

**Expected evidence:**

* Research document includes npm registry data with current version
* Evidence log shows: `[MCP Tool Call: resolve-library-id]` or `[MCP Tool Call: get-library-docs]`
* External source citations reference Context7 or npm registry
* No error about MCP server unavailable

**Success criteria:**

* ✅ Research document cites npm package versions
* ✅ MCP tool calls appear in evidence log
* ✅ External authoritative sources included

---

### Microsoft Learn Setup (Documentation Server)

Microsoft Learn provides authoritative documentation for Microsoft products and services including Azure, .NET, VS Code, and Microsoft 365.

**Use Microsoft Learn when:** Working with Microsoft technologies and need up-to-date official documentation.

**Installation:**

Microsoft Learn MCP is a remote HTTP endpoint—no installation required.

**Verify endpoint availability:**

```powershell
curl.exe -I https://learn.microsoft.com/api/mcp
```

**Expected response:** `HTTP/2 200` (endpoint is accessible)

**Configuration:**

Add to `.vscode/mcp.json`:

```json
{
  "mcpServers": {
    "microsoft-learn": {
      "type": "http",
      "url": "https://learn.microsoft.com/api/mcp"
    }
  }
}
```

> [!NOTE]
> Microsoft Learn MCP is a public endpoint with no authentication required. It provides direct access to the entire Microsoft Learn documentation catalog at learn.microsoft.com.

**Verification:**

In GitHub Copilot Chat:

```text
Try this test query:

1. Open Copilot Chat sidebar (`Ctrl+Alt+I` or `Cmd+Alt+I`)
2. Click the **agent picker dropdown** and select **task-researcher**
3. Type: `Research Azure Functions HTTP trigger configuration and best practices`
4. Press Enter

**Expected Response:**
```

**Expected evidence:**

* Research document includes Microsoft Learn documentation references
* Links to learn.microsoft.com articles
* Evidence log shows MCP tool calls to Microsoft Learn endpoint
* Up-to-date Azure service information

**Success criteria:**

* ✅ Research includes learn.microsoft.com citations
* ✅ Microsoft-specific terminology and service names
* ✅ No authentication errors

---

### GitHub Setup (Development Operations Server)

GitHub MCP provides repository management, issue tracking, pull request automation, GitHub Actions integration, and security analysis.

**Use GitHub when:** Automating GitHub operations, analyzing repos/issues/PRs, or working with GitHub Enterprise.

**Installation:**

#### Recommended: Remote HTTP (No installation, uses GitHub Copilot OAuth)

No installation required. Authentication handled automatically via GitHub Copilot subscription.

**Configuration:**

Add to `.vscode/mcp.json`:

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    }
  }
}
```

> [!TIP]
> The remote GitHub MCP server uses your GitHub Copilot subscription for authentication. No personal access token (PAT) management required.

#### Alternative: Local Docker (requires PAT)

For advanced use cases or GitHub Enterprise Server:

```json
{
  "inputs": [
    {
      "type": "promptString",
      "id": "github_token",
      "description": "GitHub Personal Access Token",
      "password": true
    }
  ],
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
      }
    }
  }
}
```

**Verification:**

In GitHub Copilot Chat:

```text
Try this test query:

1. Open Copilot Chat sidebar (`Ctrl+Alt+I` or `Cmd+Alt+I`)
2. Click the **agent picker dropdown** and select **task-researcher**
3. Type: `Research recent issues in the microsoft/vscode repository tagged as 'bug'`
4. Press Enter

**Expected Response:**
```

**Expected evidence:**

* Research document includes recent GitHub issues
* Issue numbers, titles, and current status
* Evidence log shows GitHub MCP tool calls (e.g., `search_issues`, `get_issue`)
* Links to github.com

**Success criteria:**

* ✅ Research includes live GitHub data (not stale training data)
* ✅ GitHub MCP tool calls in evidence log
* ✅ No authentication errors

---

### Azure DevOps Setup (Development Operations Server)

Azure DevOps MCP provides work item tracking, pipeline management, repository operations, test plans, and wiki access.

**Use Azure DevOps when:** Managing ADO work items, analyzing pipelines, or coordinating team workflows.

**Installation:**

Azure DevOps MCP runs via `npx` and requires your organization name.

**Test availability:**

```bash
npx -y @azure-devops/mcp --help
```

**Expected output:** Azure DevOps MCP help and available options

**Configuration:**

Add to `.vscode/mcp.json`:

```json
{
  "inputs": [
    {
      "id": "ado_org",
      "type": "promptString",
      "description": "Azure DevOps organization name (e.g., 'contoso')"
    }
  ],
  "mcpServers": {
    "azure-devops": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@azure-devops/mcp", "${input:ado_org}"]
    }
  }
}
```

**Authentication:**

On first use, Azure DevOps MCP opens a browser for interactive OAuth login. Your credentials must match the specified organization.

> [!IMPORTANT]
> Azure DevOps MCP requires your organization name as a mandatory parameter. Replace `${input:ado_org}` with your actual organization name or use the input prompt shown above.

#### Optional: Filter domains to reduce tool count

```json
{
  "mcpServers": {
    "azure-devops": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@azure-devops/mcp",
        "${input:ado_org}",
        "--domains",
        "core,work,work-items"
      ]
    }
  }
}
```

**Available domains:** `core`, `work`, `work-items`, `repositories`, `pipelines`, `test-plans`, `wiki`, `search`, `advanced-security`

**Verification:**

In GitHub Copilot Chat:

```text
Try this test query:

1. Open Copilot Chat sidebar (`Ctrl+Alt+I` or `Cmd+Alt+I`)
2. Click the **agent picker dropdown** and select **task-researcher**
3. Type: `Research active work items in the current sprint for project 'MyProject'`
4. Press Enter

**Expected Response:**
```

**Expected evidence:**

* Research document includes work item IDs, titles, and status
* Evidence log shows Azure DevOps MCP tool calls
* Current sprint and project data
* No authentication errors

**Success criteria:**

* ✅ Research includes live Azure DevOps data
* ✅ Work items or pipeline information retrieved
* ✅ OAuth authentication succeeded

---

## Multi-Server Configuration Examples

You can configure multiple MCP servers simultaneously. Here are common combinations:

### Documentation-Focused Configuration

Context7 for open-source libraries + Microsoft Learn for Microsoft technologies:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "microsoft-learn": {
      "type": "http",
      "url": "https://learn.microsoft.com/api/mcp"
    }
  }
}
```

### Operations-Focused Configuration

GitHub for repository operations + Azure DevOps for work items:

```json
{
  "inputs": [
    {
      "id": "ado_org",
      "type": "promptString",
      "description": "Azure DevOps organization name"
    }
  ],
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "azure-devops": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@azure-devops/mcp", "${input:ado_org}"]
    }
  }
}
```

### Comprehensive Configuration

All four essential MCP servers:

```json
{
  "inputs": [
    {
      "id": "ado_org",
      "type": "promptString",
      "description": "Azure DevOps organization name"
    }
  ],
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "microsoft-learn": {
      "type": "http",
      "url": "https://learn.microsoft.com/api/mcp"
    },
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "azure-devops": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@azure-devops/mcp", "${input:ado_org}"]
    }
  }
}
```

> [!TIP]
> Start with one or two servers based on your immediate needs. You can always add more servers later by editing `.vscode/mcp.json`.

## Troubleshooting MCP Setup

### General MCP Issues

#### Issue: MCP extension not recognized

**Diagnosis:** Extension not installed or VS Code needs reload

**Solution:**

1. Verify extension installed: `Ctrl+Shift+X` → Search "Model Context Protocol"
2. Reload VS Code: `Ctrl+Shift+P` → "Developer: Reload Window"
3. Check `.vscode/mcp.json` exists and has valid JSON syntax

---

#### Issue: .vscode/mcp.json changes not taking effect

**Diagnosis:** VS Code hasn't reloaded the configuration

**Solution:**

1. Save `.vscode/mcp.json`
2. Reload VS Code window: `Ctrl+Shift+P` → "Developer: Reload Window"
3. Verify configuration syntax with a JSON validator

---

### Context7 Troubleshooting

#### Issue: Context7 server not found

**Diagnosis:** `npx` not in PATH or network connectivity issue

**Solution:**

```bash
# Verify npx is available
npx --version

# Test Context7 availability
npx -y @upstash/context7-mcp@latest --help

# Verify Node.js installation
node --version
# Should be 18.0.0 or higher
```

---

#### Issue: Context7 rate limit exceeded

**Diagnosis:** Heavy usage without API key (free tier limits)

**Solution:**

1. Add `CONTEXT7_API_KEY` to configuration
2. Visit <https://upstash.com/docs/oss/context7/overview> to get API key
3. Reduce research frequency or target specific libraries

---

### Microsoft Learn Troubleshooting

#### Issue: Microsoft Learn endpoint unreachable

**Diagnosis:** Network connectivity issue or endpoint temporarily unavailable

**Solution:**

```powershell
# Test endpoint connectivity
curl.exe -I https://learn.microsoft.com/api/mcp

# If timeout, check network/firewall
# If 404/500, endpoint may be temporarily down

# Verify no corporate proxy blocking access
# Check with IT if behind corporate firewall
```

---

#### Issue: Microsoft Learn returns no results

**Diagnosis:** Query doesn't match Microsoft documentation scope

**Solution:**

1. Verify you're asking about Microsoft products (Azure, .NET, VS Code, etc.)
2. Use specific product names: "Azure Functions" not "serverless"
3. Microsoft Learn only covers Microsoft documentation, not third-party libraries

---

### GitHub MCP Troubleshooting

#### Issue: GitHub OAuth authentication failed

**Diagnosis:** GitHub Copilot subscription inactive or not signed in

**Solution:**

1. Verify GitHub Copilot subscription active
2. Sign in to GitHub in VS Code: Status bar → GitHub account
3. Restart VS Code after signing in
4. Check GitHub Copilot status: `Ctrl+Shift+P` → "GitHub Copilot: Check Status"

---

#### Issue: GitHub MCP returns permission denied

**Diagnosis:** OAuth token lacks required scopes for repository access

**Solution:**

1. For public repos: OAuth should work automatically
2. For private repos: Verify you're a repository collaborator
3. Alternative: Use local Docker configuration with PAT that has appropriate scopes
4. Create PAT at <https://github.com/settings/personal-access-tokens/new>

---

#### Issue: Docker GitHub MCP fails to start

**Diagnosis:** Docker not running or PAT token invalid

**Solution:**

```bash
# Verify Docker is running
docker --version
docker ps

# Test GitHub MCP Docker image
docker pull ghcr.io/github/github-mcp-server

# Verify PAT token has required scopes:
# - repo (for repository access)
# - read:org (for organization data)
# - workflow (for GitHub Actions)
```

---

### Azure DevOps MCP Troubleshooting

#### Issue: Azure DevOps organization not found

**Diagnosis:** Organization name incorrect or not accessible

**Solution:**

1. Verify organization name: <https://dev.azure.com/{organization}>
2. Check spelling—organization names are case-sensitive
3. Ensure your account has access to the organization
4. Try accessing organization in browser first

---

#### Issue: Azure DevOps OAuth authentication fails

**Diagnosis:** Browser authentication didn't complete or credentials mismatched

**Solution:**

1. When browser opens, sign in with account that has organization access
2. Accept permission prompts
3. Check for browser popup blockers preventing authentication
4. Clear cached credentials: Delete `.mcp/` directory in home folder
5. Retry authentication with `npx -y @azure-devops/mcp <org-name>`

---

#### Issue: Azure DevOps returns too many tools

**Diagnosis:** All 80+ tools loaded by default, overwhelming tool selection

**Solution:**

Use domain filtering to load only needed tools:

```json
{
  "mcpServers": {
    "azure-devops": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@azure-devops/mcp",
        "your-org",
        "--domains",
        "core,work-items"
      ]
    }
  }
}
```

**Recommended domains:**

* Always include: `core` (project/team operations)
* For work items: `work`, `work-items`
* For repos: `repositories`
* For CI/CD: `pipelines`

---

### Performance Issues

#### Issue: MCP slows down research significantly

**Diagnosis:** Network latency, rate limiting, or multiple servers configured

**Solution:**

1. Use MCP selectively: Only for external library/service research
2. Configure fewer servers: Remove unused servers from `mcp.json`
3. Use domain filtering (Azure DevOps) or toolset filtering (GitHub local)
4. Check network latency to remote endpoints
5. For local servers, verify adequate system resources (CPU, memory)

---

#### Issue: Research includes irrelevant MCP results

**Diagnosis:** MCP server invoked for inappropriate query type

**Solution:**

1. Craft specific queries: "Research Express.js documentation" not "How do I use Express?"
2. Use appropriate server for task: Context7 for libraries, Microsoft Learn for Azure
3. For internal codebase questions, disable MCP temporarily
4. Guide researcher with context: "Using Microsoft Learn, research Azure Functions"

---

**Previous:** [Chat Modes Configuration](./04-chat-modes-configuration.md) | **Next:** [Chapter Summary](./06-summary.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
