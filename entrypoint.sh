#!/bin/bash
set -e

HERMES_HOME="/root/.hermes"
mkdir -p "$HERMES_HOME"

ENV_FILE="$HERMES_HOME/.env"

write_if_set() {
  local key="$1"
  local val="${!key}"
  if [ -n "$val" ]; then
    grep -v "^${key}=" "$ENV_FILE" 2>/dev/null > "$ENV_FILE.tmp" || true
    mv "$ENV_FILE.tmp" "$ENV_FILE"
    echo "${key}=${val}" >> "$ENV_FILE"
  fi
}

touch "$ENV_FILE"
chmod 600 "$ENV_FILE"

write_if_set ANTHROPIC_API_KEY
write_if_set OPENROUTER_API_KEY
write_if_set NOUS_API_KEY
write_if_set TELEGRAM_BOT_TOKEN
write_if_set TELEGRAM_ALLOWED_USERS
write_if_set TELEGRAM_HOME_CHANNEL
write_if_set TELEGRAM_HOME_CHANNEL_NAME
write_if_set DISCORD_BOT_TOKEN
write_if_set DISCORD_ALLOWED_USERS
write_if_set DISCORD_HOME_CHANNEL
write_if_set SLACK_BOT_TOKEN
write_if_set SLACK_APP_TOKEN
write_if_set SLACK_ALLOWED_USERS
write_if_set NOTION_TOKEN
write_if_set GITHUB_TOKEN
write_if_set HERMES_HUMAN_DELAY_MODE
write_if_set HERMES_ACCEPT_HOOKS

CONFIG_FILE="$HERMES_HOME/config.yaml"
if [ ! -f "$CONFIG_FILE" ]; then
  cat > "$CONFIG_FILE" << 'YAML'
model:
  provider: anthropic
  model: claude-sonnet-4-20250514

gateway:
  auto_start: true
YAML
fi

SOUL_SRC="/app/hermes/SOUL.md"
SOUL_DEST="$HERMES_HOME/SOUL.md"
if [ -f "$SOUL_SRC" ] && [ ! -f "$SOUL_DEST" ]; then
  cp "$SOUL_SRC" "$SOUL_DEST"
fi

echo "Hermes config ready. Starting gateway..."
exec hermes gateway run --replace
