# AGENTS.md

`node-cn` — Docker base images that wrap official `node:<ver>-<debian>-slim` images with China-mainland mirrors (Aliyun for apt, `registry.npmmirror.com` for npm/pnpm + prebuilt-binary mirrors) and a pre-installed `pnpm`. Published as `ONBUILD` base images: any child `FROM node-cn:NN` prints node/npm version info on build via the trailing `ONBUILD RUN cat .../.node-cn-info`.

No JS toolchain, tests, lint, or typecheck here — this is a Dockerfile/make repo. Verification = building images.

## Build & push

`makefile` discovers every top-level **purely-numeric** directory (`find . -type d -regex "./[0-9]*"`), builds each `<N>/Dockerfile`, and **pushes** to `$REGISTRY/node-cn:<N>`. Then `make latest` re-tags the **numerically highest** version dir as `:latest` and pushes it.

- `make` builds **and pushes everything** — there is no local-only target. Without `docker login` to the target registry it fails at push.
- `REGISTRY` defaults to `docker.io/wakefun`. `make.conf` (gitignored, holds a private registry) overrides it locally via `-include make.conf`. CI does a fresh checkout with no `make.conf`, so **CI pushes to `docker.io/wakefun` while a local `make` pushes to the private registry** — don't "fix" this divergence.
- `make.conf.example` is the public template; never commit `make.conf`.

## Build a single version locally (no push)

Mirror the makefile recipe exactly — note the build context is repo root (`.`), not the version dir:

```sh
docker build -t node-cn:<N> -f ./<N>/Dockerfile .
```

## Smoke test

`test/16/` is a Vue 2 app (multi-stage: `FROM node-cn:16` → `npm ci && npm run build` → nginx). Use it to verify a freshly built `node-cn:16`:

```sh
docker build -t node-cn:16 -f ./16/Dockerfile .
docker build -f ./test/16/Dockerfile ./test/16/
```

There is one `test/` harness (for node 16); it is a consumer demo, not part of the published images.

## Adding / editing a Node version — the per-version matrix

Each `<N>/Dockerfile` differs by Debian suite, apt source-list format, copy destination, pnpm pin, and an optional apt-key step. **Match all of these when adding a version:**

| Node | Debian base              | apt file        | apt format | copy dest                          | pnpm      | extra apt-key step |
|------|--------------------------|-----------------|-----------|-------------------------------------|-----------|--------------------|
| 8    | `node:8-buster-slim`     | `apt/buster`    | one-line  | `/etc/apt/sources.list`             | (none)    | yes                |
| 10   | `node:10-buster-slim`    | `apt/buster`    | one-line  | `/etc/apt/sources.list`             | (none)    | yes                |
| 12   | `node:12-bullseye-slim`  | `apt/bullseye`  | one-line  | `/etc/apt/sources.list`             | `pnpm@6`  | no                 |
| 14   | `node:14-bullseye-slim`  | `apt/bullseye`  | one-line  | `/etc/apt/sources.list`             | `pnpm@7`  | no                 |
| 16   | `node:16-bookworm-slim`  | `apt/bookworm`  | deb822    | `/etc/apt/sources.list.d/debian.sources` | `pnpm` (latest) | no |
| 18   | `node:18-bookworm-slim`  | `apt/bookworm`  | deb822    | `/etc/apt/sources.list.d/debian.sources` | `pnpm` (latest) | no |
| 20   | `node:20-slim`           | `apt/bookworm`  | deb822    | `/etc/apt/sources.list.d/debian.sources` | `pnpm` (latest) | no |
| 22   | `node:22-slim`           | `apt/bookworm`  | deb822    | `/etc/apt/sources.list.d/debian.sources` | `pnpm` (latest) | no |
| 24   | `node:24-slim`           | `apt/bookworm`  | deb822    | `/etc/apt/sources.list.d/debian.sources` | `pnpm` (latest) | no |
| 26   | `node:26-slim`           | `apt/trixie`    | deb822    | `/etc/apt/sources.list.d/debian.sources` | `pnpm` (latest) | no |

- EOL Debian releases (stretch, buster) use the archived mirror path `mirrors.aliyun.com/debian-archive/`; current releases (bullseye, bookworm) use `mirrors.aliyun.com/debian/`.
- The apt-key step on buster is required because Debian dropped those signing keys after EOL — `apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9 6ED0E7B82643E131`. Do not remove it for node 8/10.

## Invariants to preserve when editing a Dockerfile

1. **Two-step apt source swap.** Copy the `*.http` (plain HTTP) source list first, `apt-get install -y apt-transport-https ca-certificates` (and `gnupg` where keys are needed), THEN copy the HTTPS `apt/<release>` file. Reversing this breaks `apt-get update` before TLS support exists.
2. **`USER root` for apt setup, then `USER node`.** Keep this ordering — everything after the apt block runs as the non-root `node` user.
3. **`.npmrc` is installed twice.** `COPY` to `/home/node/.npmrc` (user config) AND appended to `/home/node/.npm-global/etc/npmrc` (global config). `ENV NPM_CONFIG_PREFIX=/home/node/.npm-global` + the PATH append is what lets global bins run as non-root — this is the whole point of the repo (see `README.MD` for the npm `unsafe-perm` rationale).
4. **`ONBUILD RUN cat /home/node/node-cn/.node-cn-info`** is the last line of every version Dockerfile. It is intentional — child images print build info. Don't drop it.
5. pnpm is installed via `npm i -g pnpm[...]` into the non-root global prefix; do not run it as root or change the prefix.

## `.npmrc` (root)

Single source of truth for all mirror config: npm registry, `disturl`, and prebuilt-binary hosts for node-sass, sharp, electron, canvas, sqlite3, better-sqlite3, puppeteer (chrome-for-testing), phantomjs, python. Any new binary-mirror need goes here, and it propagates into both user and global npm config via invariant #3 above.

## CI

`.github/workflows/makefile.yml` runs `make` on push to `main` and on `workflow_dispatch`, logging into Docker Hub via `DOCKER_HUB_USER` / `DOCKER_HUB_SECRET` secrets. Because CI has no `make.conf`, it always targets `docker.io/wakefun`.
