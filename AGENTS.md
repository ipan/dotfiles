## CodeGraph

Before exploring or changing the repository:

- Verify `codegraph` is on `PATH`. If unavailable, report it; do not install packages or change MCP configuration without approval.
- If `.codegraph/` is absent, run `codegraph init .`; otherwise run `codegraph status .`. For a stale or failed index, run `codegraph sync .`, then `codegraph index .` only if sync fails.
- Use `codegraph_explore` before grep/find or broad reads when available; otherwise use `codegraph explore "<question>"`. Skip CodeGraph only when no `.codegraph/` directory exists.
