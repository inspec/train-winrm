# GitHub Copilot Instructions for Train-WinRM

## Project Overview

**Train-WinRM** is a **Train** transport plugin that enables remote communication with Windows systems over **WinRM**.
It provides a consistent API to higher-level tools (for example, InSpec, Chef) for running commands, transferring files, and querying system information.

---

## Repository Structure

```
train-winrm/
├── .github/                  # GitHub workflows & issue templates
├── lib/
│   ├── train-winrm.rb        # Gem entry & transport registration
│   └── train-winrm/
│       ├── transport.rb      # Transport (options, connection builder)
│       ├── connection.rb     # Connection (commands, files, platform)
│       └── socks_proxy_patch.rb # SOCKS5/H proxy support
├── test/
│   ├── unit/                 # Unit tests (Minitest)
│   └── integration/          # Integration tests (gated)
├── train-winrm.gemspec       # Gemspec
├── Gemfile                   # Dependencies for dev/test
├── Rakefile                  # Lint/test tasks
└── README.md                 # User & developer docs
```

---

## Architecture

* **Plugin model:** Registers with Train via `Train.plugin(1)` and `name 'winrm'`.
* **Transport (`transport.rb`):** Parses and normalizes options; creates a `Connection`.
* **Connection (`connection.rb`):** Implements Train connection interface.

    * Provides `run_command`, `upload`, `download`, `file`, and `platform` APIs.
    * Uses WinRM Ruby gems under the hood (`winrm`, `winrm-fs`, etc.).
* **Proxy / Kerberos:** Optional SOCKS5/H proxy and Kerberos authentication.

---

## Key Development Patterns

1. Normalize options in **Transport**, execute logic in **Connection**.
2. Default shell is PowerShell; allow CMD if configured.
3. Respect `ssl`, `self_signed`, and CA trust; verify certificates by default.
4. Centralize retry and timeout logic for consistency.
5. Convert low-level errors to actionable Train-style exceptions.

---

## CLI / Transport Option Management (Authoritative List)

> Keep this section in sync with `transport.rb`. Only the options below are supported.

| Option                   |           Default | Required | Description                                                               |
| ------------------------ | ----------------: | :------: | ------------------------------------------------------------------------- |
| `host`                   |                 — |  **Yes** | Target hostname or IP.                                                    |
| `port`                   |                 — |    No    | WinRM port. If omitted, use protocol defaults (5985/5986) based on `ssl`. |
| `user`                   | `"administrator"` |  **Yes** | Username for authentication.                                              |
| `password`               |             `nil` |    No    | Password for auth (not used for ticket-only Kerberos).                    |
| `winrm_transport`        |      `:negotiate` |    No    | Transport/auth type (`:negotiate`, `:kerberos`, `:ssl`, `:plaintext`).    |
| `winrm_disable_sspi`     |           `false` |    No    | Disable SSPI (affects negotiate on Windows hosts/clients).                |
| `winrm_basic_auth_only`  |           `false` |    No    | Force Basic auth (lab/legacy only).                                       |
| `path`                   |        `"/wsman"` |    No    | WSMan endpoint path.                                                      |
| `ssl`                    |           `false` |    No    | Use HTTPS (generally port 5986).                                          |
| `self_signed`            |           `false` |    No    | Allow self-signed certificates when `ssl` is true.                        |
| `rdp_port`               |            `3389` |    No    | Exposed for convenience; not used by WinRM itself.                        |
| `connection_retries`     |               `5` |    No    | Retry attempts for establishing the session.                              |
| `connection_retry_sleep` |               `1` |    No    | Sleep seconds between retries.                                            |
| `max_wait_until_ready`   |             `600` |    No    | Upper bound (sec) to wait until endpoint is ready.                        |
| `ssl_peer_fingerprint`   |             `nil` |    No    | Pin server cert by fingerprint.                                           |
| `kerberos_realm`         |             `nil` |    No    | Kerberos realm (when using Kerberos).                                     |
| `kerberos_service`       |             `nil` |    No    | Kerberos SPN service (default typically `HTTP`).                          |
| `ca_trust_file`          |             `nil` |    No    | Custom CA bundle path for TLS validation.                                 |
| `operation_timeout`      |             `nil` |    No    | Server op ack timeout (sec). Ack ≠ command completion.                    |
| `winrm_shell_type`       |    `"powershell"` |    No    | Preferred shell (`"powershell"` or `"cmd"`).                              |
| `client_cert`            |             `nil` |    No    | Client cert (mutual TLS) if supported by backend.                         |
| `client_key`             |             `nil` |    No    | Client key path.                                                          |
| `client_key_pass`        |             `nil` |    No    | Client key passphrase.                                                    |
| `socks_proxy`            |             `nil` |    No    | SOCKS5/5H proxy URL (for example, `socks5h://proxy:1080`).                |
| `socks_user`             |             `nil` |    No    | SOCKS proxy username.                                                     |
| `socks_password`         |             `nil` |    No    | SOCKS proxy password.                                                     |

**Notes:**

* Prefer `socks5h://` when DNS resolution must occur via proxy.
* When `ssl: true`, prefer certificate verification; `self_signed: true` should be explicit and documented in PRs.

---

## Transport Layer Integration

* **Train.create:** `Train.create("winrm", options_hash)` returns a Transport; `#connection` returns a Connection.
* **Kerberos:** Honor `kerberos_realm` and `kerberos_service` when `winrm_transport` requires it; prefer ticket cache if available.
* **Proxy:** If `socks_proxy` is set, route sockets through SOCKS5/H. Use `socks_user` and `socks_password` if proxy auth is required.

---

## Execution & File API (Train Interface)

* **Commands:** `run_command(cmd)` returns stdout, stderr, and exitstatus.
* **File:** `file(path)` returns a Train file object (exists?, content, etc.).
* **Transfer:** `upload(local:, remote:)` and `download(remote:, local:)` implemented via `winrm-fs` where supported.
* **Platform:** Populate Windows platform details consistently for consumers.

---

## Code Style Guidelines

* **Ruby:** 3.0+ unless repo states otherwise.
* `# frozen_string_literal: true` in all Ruby files.
* Avoid mutating frozen strings; use `+""` pattern when building strings.
* Follow RuboCop rules in `.rubocop.yml`.
* Map errors to Train exceptions where sensible and include remediation text.

---

## Testing Patterns

* **Framework:** Minitest with `describe` and `it` syntax.
* **Unit tests (`test/unit/`)** must cover:

    * Option normalization and defaults
    * TLS, `self_signed`, and CA behaviors
    * Kerberos branches
    * SOCKS proxy routing (happy and sad paths)
    * Timeouts, retries, and error mapping
* **Integration tests (`test/integration/`)** (optional or gated):

    * Negotiate (5985), SSL (5986), Kerberos (with valid tickets), file transfer, elevation if supported.
* Use stubs or mocks for `winrm` and `winrm-fs` to avoid hard dependencies in unit tests.

---

## Remote Connection Development (Recipes)

### Basic Negotiate

```
bundle exec inspec shell -t winrm://user@host --winrm-transport negotiate
```

### Kerberos (ticket-based)

```
kinit user@EXAMPLE.COM
bundle exec inspec shell -t winrm://host \
  --winrm-transport kerberos
```

### With SOCKS5H proxy

```
Train.create("winrm", host: "w", socks_proxy: "socks5h://proxy:1080")
```

---

## Packaging and Distribution

* **Gemspec:** Ensure metadata and runtime dependencies (`winrm`, `winrm-fs`) are current.
* **Release tooling:** If Expeditor or GitHub Actions manage releases, do not hand-edit generated files.
* **Versioning:** Respect the repo’s release and version process; avoid manual edits to `VERSION` if managed externally.

---

## Dependencies and Bundler

Use a personal access token to avoid GitHub rate limits where needed:

```
export GITHUB_TOKEN=ghp_xxx
bundle install
```

For local development against related gems (for example, `winrm`), use `path:` overrides in `Gemfile` during experimentation (not committed).

---

## Documentation Structure and Guidelines

* **README.md** is the primary user and developer documentation.
* Keep **Supported Options** synchronized in both this document and the README.
* Use clear headings, consistent terminology (WinRM, Negotiate, Kerberos), and language-specific code blocks.
* Avoid InSpec documentation folders (no `docs-chef-io/`).
* **CHANGELOG.md:** If auto-generated by CI or release tooling, do not edit manually.

---

## Common File Locations

* **Transport:** `lib/train-winrm/transport.rb`
* **Connection:** `lib/train-winrm/connection.rb`
* **Proxy:** `lib/train-winrm/socks_proxy_patch.rb`
* **Entry:** `lib/train-winrm.rb`
* **Tests:** `test/unit/`, `test/integration/`

---

## Security Considerations

* Never log credentials or sensitive data.
* Prefer verifying TLS certificates; `self_signed` should be an explicit opt-in.
* Validate proxy URLs and Kerberos parameters.
* Provide actionable error messages for common WinRM, Kerberos, or TLS issues.

---

## Task Implementation Workflow (Train-WinRM Repo-Specific)

### 1. Jira Integration with MCP Server (if a Jira ID is provided)

* Fetch issue using `mcp_atlassian-mcp_getJiraIssue` and analyze story and acceptance criteria.
* Identify files to modify (usually `transport.rb`, `connection.rb`, `socks_proxy_patch.rb`, and test files).
* **Prompt:** **Analysis Complete.** Next step: Start implementation. Other steps remaining: Implementation → Testing → Committing the code → PR Creation → Update JIRA Ticket. Do you want to continue with the implementation?

### 2. Implementation

* Follow patterns from this document; keep option handling authoritative.
* Update **Supported Options** and README when changing behavior.
* **Prompt:** **Implementation Complete.** Next step: Create unit tests. Other steps remaining: Testing → Committing the code → PR Creation → Update JIRA Ticket. Do you want to continue with creating tests?

### 3. Testing

* Write unit tests and gate integration tests with environment flags.
* **Prompt:** **Tests Complete.** Next step: Committing the code. Other steps remaining: Committing the code → PR Creation → Update JIRA Ticket. Do you want to continue with committing the code?

### 4. Committing the Code

```
git checkout -b <JIRA_ID-or-topic>
git add -A
git commit -s -m "feat(train-winrm): <short description>"
```

* Keep code, tests, and documentation in logical commits.
* **Prompt:** **Code committed Successfully.** Next step: Create PR with GitHub CLI. Other steps remaining: PR Creation → Update JIRA Ticket. Do you want to continue with PR creation?

### 5. PR Creation (GitHub CLI)

```
gh auth status || gh auth login
git push -u origin <branch>
```

Choose change type: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `style`, `ci`, `revert`.

PR body format:

```
<!--- Provide a short summary of your changes in the Title above -->

## Description
<!--- Describe your changes in detail, what problems does it solve? -->

[Your detailed description here]

This work was completed with AI assistance following Progress AI policies.

## Related Issue
<!--- Link to Jira, issues, or discussions -->

## Types of changes
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New content (non-breaking change)
- [ ] Breaking change (a content change which would break existing functionality or processes)

## Checklist
- [ ] I have read the **CONTRIBUTING** document.
```

PR creation:

```
printf "%s" "<template above>" > pr_template.md
gh pr create \
  --title "<CHANGE_TYPE>: <JIRA_ID or topic> - <brief description>" \
  --body-file pr_template.md \
  --label "ai-assisted"
rm -f pr_template.md
```

* **Prompt:** **PR Created Successfully.** Next step: Update JIRA Ticket. Final step remaining: Update JIRA Ticket. Do you want to continue with updating JIRA?

### 6. Update JIRA Ticket (Mandatory when Jira is used)

* Mark AI-assisted using:

    * Tool: `mcp_atlassian-mcp_editJiraIssue`
    * Payload: `{"customfield_11170": {"value": "Yes"}}`
* Optionally comment with PR link using `mcp_atlassian-mcp_addCommentToJiraIssue`.
* **Final message:** **JIRA Ticket Updated Successfully.** All steps completed!

---

## Files and Areas to Avoid Modifying

* `VERSION` (if release-managed)
* CI/release automation files (Expeditor or GitHub Actions) unless explicitly required
* `Gemfile.lock` and any auto-generated files

---

## Maintenance Checklist (for PRs Touching Connectivity)

* [ ] Supported Options updated (this doc and README)
* [ ] README examples updated
* [ ] Unit tests added or updated (options, TLS, Kerberos, proxy, errors)
* [ ] Integration tests gated or documented for manual validation
* [ ] Secure defaults preserved (`ssl` verification unless explicitly disabled)
