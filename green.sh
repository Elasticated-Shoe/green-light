#!/bin/bash
# Script to backdate commits for a green GitHub profile
# Commits 1-3 times per day for the last 30 days
# More commits on weekends, mostly evenings on weekdays

set -e

today=$(date +%s)
dummy_file="greenlight_dummy.txt"
commit_messages=(
  "Update progress"
  "Refactor code"
  "Fix typo"
  "Improve docs"
  "Tweak config"
  "Update README"
  "Minor changes"
  "Polish UI"
  "Add tests"
  "Cleanup"
  "Update dependencies"
  "Enhance UX"
  "Bugfix"
  "Optimize logic"
  "Update script"
)

today=$(date +%s)
for i in $(seq 600 -1 1)
do
  day=$((today - i * 86400))
  dow=$(date -d @${day} +%u) # 6=Sat, 7=Sun
  if [ "$dow" -ge 6 ]; then
    commits=$(( (RANDOM % 2) + 2 )) # 2-3 commits on weekends
  else
    commits=$(( (RANDOM % 3) + 1 )) # 1-3 commits on weekdays
  fi
  for j in $(seq 1 $commits)
  do
    if [ "$dow" -ge 6 ]; then
      hour=$(( (RANDOM % 12) + 10 )) # 10:00-21:00 weekends
    else
      hour=$(( (RANDOM % 6) + 18 )) # 18:00-23:00 weekdays
    fi
    min=$(( RANDOM % 60 ))
    sec=$(( RANDOM % 60 ))
    commit_time=$(date -d @${day} +"%Y-%m-%d")" $hour:$(printf '%02d' $min):$(printf '%02d' $sec)"
    msg_idx=$(( RANDOM % ${#commit_messages[@]} ))
    msg=${commit_messages[$msg_idx]}
    echo "$commit_time $msg" >> $dummy_file
    GIT_AUTHOR_DATE="$commit_time" GIT_COMMITTER_DATE="$commit_time" git add $dummy_file
    GIT_AUTHOR_DATE="$commit_time" GIT_COMMITTER_DATE="$commit_time" git commit -m "$msg"
  done
done
