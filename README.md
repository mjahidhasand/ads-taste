# ads-taste

A Claude Code skill for making ad creative: social feed and story ads, carousels, display and promo banners, product and app-install ads, posters, billboards, flyers and magazine ads. It distils composition, headline formulas, palettes, type and CTA patterns from thousands of Pinterest ad pins, and a bot keeps it refreshed.

It holds **patterns, not copies.** The repo stores pin links and Pinterest's alt-text only. No images are stored, and every pin belongs to its creator. The skill writes fresh copy for your brand and never recreates a specific ad.

Sister project: [pinterest-taste](https://github.com/mjahidhasand/pinterest-taste), the same approach for UI/UX.

## Use the skill

```sh
git clone https://github.com/mjahidhasand/ads-taste.git
cd ads-taste
./install.sh            # macOS/Linux: links skill/ads-taste into ~/.claude/skills
# Windows: powershell -ExecutionPolicy Bypass -File install.ps1
```

Run `git pull` any time to get the latest patterns. Claude Code loads the skill automatically when you ask for an ad, banner or poster. You can also say "use ads-taste".

To browse, open `skill/ads-taste/catalog.html` to see the pins by category, and `skill/ads-taste/references/` for the pattern files.

## How the bot works

```
collector ──pins.json + previews──▶ analyst ──references/*.md──▶ publisher ──git push──▶ GitHub
(browser, paced)                    (Claude Code, Read/Edit/Write only)   (validates, deploy key)
```

- **collector**: a real Chromium on a virtual display. It rotates through the searches in `skill/ads-taste/data/topics.json`, with a 15–40 minute random gap between searches and at most 60 a day. It backs off for up to 12 h if Pinterest pushes back. Previews stay on the VM and are deleted once analyzed.
- **analyst**: when a category has 40 or more new pins, headless Claude Code studies them and rewrites `references/<category>.md`. Every 6 category runs it re-synthesises `_foundations.md`. Claude gets no shell or web tools, and its output is validated.
- **publisher**: every 15 minutes it rebuilds the catalog and index, re-checks everything for secrets and stray links, then commits and pushes. It is the only container with the deploy key.

## Run the bot (on the VM)

```sh
cp .env.example .env    # fill CLAUDE_CODE_OAUTH_TOKEN (from `claude setup-token`) and DEPLOY_KEY_PATH
docker compose up -d --build
```

**Log in once** with a spare Pinterest account (ideally a different one from pinterest-taste's). From your PC:

```sh
ssh -N -L 6081:localhost:6081 adv-devpc-002@10.20.1.41
```

Then open <http://localhost:6081/vnc.html>, click Connect, and log in.

| Task | Command |
|---|---|
| Status | `docker compose exec collector cat /state/collector_status.json` |
| Logs | `docker compose logs --tail 20` |
| Tests | `docker run --rm -v "$PWD":/r -w /r python:3.12-slim python -m unittest discover -s bot/tests -v` |
| Add a topic | edit `skill/ads-taste/data/topics.json`, then `docker compose restart collector` |

## Respect

Pinterest's terms restrict automated collection. The bot runs slowly with one account, stores no images, and only publishes links back to the original pins. If you're a creator and want a pin removed from the references, open an issue.
