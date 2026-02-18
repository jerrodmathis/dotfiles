#!/bin/bash

# ============================================================
# Claude Code Statusline – Catppuccin Mocha
# ============================================================

input=$(cat)

# --- Catppuccin Mocha ---------------------------------------------------------

ROSEWATER=$'\033[38;2;245;224;220m'
FLAMINGO=$'\033[38;2;242;205;205m'
PINK=$'\033[38;2;245;194;231m'
MAUVE=$'\033[38;2;203;166;247m'
RED=$'\033[38;2;243;139;168m'
MAROON=$'\033[38;2;235;160;172m'
PEACH=$'\033[38;2;250;179;135m'
YELLOW=$'\033[38;2;249;226;175m'
GREEN=$'\033[38;2;166;227;161m'
TEAL=$'\033[38;2;148;226;213m'
SKY=$'\033[38;2;137;220;235m'
SAPPHIRE=$'\033[38;2;116;199;236m'
BLUE=$'\033[38;2;137;180;250m'
LAVENDER=$'\033[38;2;180;190;254m'

TEXT=$'\033[38;2;205;214;244m'
SUBTEXT1=$'\033[38;2;186;194;222m'
SUBTEXT0=$'\033[38;2;166;173;200m'

OVERLAY2=$'\033[38;2;147;153;178m'
OVERLAY1=$'\033[38;2;127;132;156m'
OVERLAY0=$'\033[38;2;108;112;134m'

SURFACE2=$'\033[38;2;88;91;112m'
SURFACE1=$'\033[38;2;69;71;90m'
SURFACE0=$'\033[38;2;49;50;68m'

BASE=$'\033[38;2;30;30;46m'
MANTLE=$'\033[38;2;24;24;37m'
CRUST=$'\033[38;2;17;17;27m'

RESET=$'\033[0m'

# --- Claude Code Data ---------------------------------------------------------

MODEL=$(echo "$input" | jq -r '.model.display_name')
CWD=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
USED_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# --- Git Info -----------------------------------------------------------------

GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [[ -n "$GIT_ROOT" ]]; then
  REPO_NAME=$(basename "$GIT_ROOT")
  if [[ "$CWD" == "$GIT_ROOT" ]]; then
    RPATH="$REPO_NAME"
  else
    RPATH="${REPO_NAME}/${CWD#"$GIT_ROOT/"}"
  fi
  BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")

  read -r STAGED MODIFIED UNTRACKED < <(
    git -C "$CWD" status --porcelain=v1 2>/dev/null |
      awk '
      /^[MADRC]/ { s++ }
      /^.[MD]/   { m++ }
      /^\?\?/    { u++ }
      END { print s+0, m+0, u+0 }
    '
  )

  STAGED="${GREEN}S:${STAGED:-0}${RESET}"
  MODIFIED="${YELLOW}M:${MODIFIED:-0}${RESET}"
  UNTRACKED="${PEACH}U:${UNTRACKED:-0}${RESET}"

  GIT_STATUS="${STAGED} ${MODIFIED} ${UNTRACKED}"
  GIT_INFO="${LAVENDER} ${BRANCH}${RESET} (${GIT_STATUS})"
fi

# --- Context Info -------------------------------------------------------------
CTX_INFO=""

if [[ -n $USED_PCT ]]; then
  USED_INT=${USED_PCT%.*}
  USED_INT=${USED_INT:-0}

  if ((USED_INT >= 80)); then
    CTX_COLOR=$RED
  elif ((USED_INT >= 50)); then
    CTX_COLOR=$YELLOW
  else
    CTX_COLOR=$GREEN
  fi

  COST_FMT=$(printf '$%.2f' "$COST")
  COST_INFO="💰: ${TEAL}${COST_FMT}${RESET}"
  USED_INFO="📚: ${CTX_COLOR}${USED_INT}%${RESET}"
  CTX_INFO="${USED_INFO} ${COST_INFO}"
fi

# --- Model Info ---------------------------------------------------------------
MODEL_INFO=""
[[ -n $MODEL ]] &&
  MODEL_INFO="${SUBTEXT0}[${BLUE}${MODEL}${SUBTEXT0}]${RESET}"

printf "%s\n" "${MODEL_INFO} ${SAPPHIRE} ${RPATH}${RESET} ${GIT_INFO} ${CTX_INFO}"
