## CodeGraph readiness

Before repository exploration or code changes:

1. Check whether `codegraph` is on `PATH`.
2. If unavailable, report that CodeGraph is unavailable; do not install global packages or modify MCP configuration without explicit user approval.
3. If the repository has no `.codegraph/` directory, initialize its index with `codegraph init .`. Do not initialize a home directory, filesystem root, or non-repository directory.
4. If `.codegraph/` exists, run `codegraph status .`. If it reports an out-of-date or failed index, run `codegraph sync .`; if sync cannot recover it, run `codegraph index .`.
5. Use the `codegraph_explore` MCP tool before grep, broad file searches, or exploratory reads.
