#!/bin/bash

input=$(cat)

# Get project directory (basename of current directory)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // "~"')
project=$(basename "$current_dir")

# Cache file for git information
CACHE_FILE="/tmp/statusline-git-cache"
CACHE_TTL=60  # seconds

# Function to get git branch with caching
get_git_branch() {
    local dir="$1"
    local cache_key="${dir}"
    local current_time=$(date +%s)

    # Check if cache file exists and is recent
    if [ -f "$CACHE_FILE" ]; then
        local cache_data=$(grep "^${cache_key}|" "$CACHE_FILE" 2>/dev/null)
        if [ -n "$cache_data" ]; then
            local cached_time=$(echo "$cache_data" | cut -d'|' -f2)
            local cached_branch=$(echo "$cache_data" | cut -d'|' -f3)
            local age=$((current_time - cached_time))

            # If cache is fresh, use it
            if [ "$age" -lt "$CACHE_TTL" ]; then
                echo "$cached_branch"
                return
            fi
        fi
    fi

    # Cache miss or expired - fetch fresh git branch
    local branch=$(cd "$dir" 2>/dev/null && git --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

    # Update cache: remove old entry for this directory and add new one
    if [ -f "$CACHE_FILE" ]; then
        grep -v "^${cache_key}|" "$CACHE_FILE" > "${CACHE_FILE}.tmp" 2>/dev/null || true
        mv "${CACHE_FILE}.tmp" "$CACHE_FILE"
    fi

    echo "${cache_key}|${current_time}|${branch}" >> "$CACHE_FILE"

    echo "$branch"
}

# Get git branch (with caching)
git_branch=$(get_git_branch "$current_dir")

model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
context_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
context_remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

total_tokens=$((input_tokens + output_tokens))

# Pricing for claude-opus-4-6
# Input: $15 per million tokens, Output: $75 per million tokens
input_cost=$(echo "scale=4; $input_tokens * 15 / 1000000" | bc)
output_cost=$(echo "scale=4; $output_tokens * 75 / 1000000" | bc)
total_cost=$(echo "scale=4; $input_cost + $output_cost" | bc)

# Create progress bar for context usage with color
create_progress_bar() {
    local percentage=$1
    local width=20
    local filled=$(printf "%.0f" $(echo "scale=2; $percentage * $width / 100" | bc))
    local empty=$((width - filled))

    # Determine color based on percentage
    local color_code=""
    local reset_code="\033[0m"

    if (( $(echo "$percentage >= 60" | bc -l) )); then
        color_code="\033[31m"  # Red
    elif (( $(echo "$percentage >= 50" | bc -l) )); then
        color_code="\033[38;5;208m"  # Orange
    elif (( $(echo "$percentage >= 40" | bc -l) )); then
        color_code="\033[33m"  # Yellow
    fi

    # Build the bar
    local bar=""
    for ((i=0; i<filled; i++)); do
        bar+="█"
    done
    for ((i=0; i<empty; i++)); do
        bar+="░"
    done

    if [ -n "$color_code" ]; then
        printf "${color_code}%s${reset_code}" "$bar"
    else
        echo "$bar"
    fi
}

# Build first line: project + git branch
if [ -n "$git_branch" ]; then
    printf "📁 %s  %s\n" "$project" "🌿 $git_branch"
else
    printf "📁 %s\n" "$project"
fi

# Build second line: model, tokens, cost, and context
if [ -n "$context_used" ]; then
    progress_bar=$(create_progress_bar "$context_used")
    printf "🤖 %s | 🪙 %'d | 💰 \$%.2f | 📊 [%b] %.0f%%" "$model" "$total_tokens" "$total_cost" "$progress_bar" "$context_used"
else
    printf "🤖 %s | 🪙 %'d | 💰 \$%.2f" "$model" "$total_tokens" "$total_cost"
fi
