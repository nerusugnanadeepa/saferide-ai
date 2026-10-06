#!/usr/bin/env bash
# Shell Script to Initialize SafeRide AI Git Repository and 4 Agent Branches
# GitHub Repository: https://github.com/nerusugnanadeepa/saferide-ai

echo -e "\033[36m🚀 Initializing SafeRide AI Multi-Agent Git Setup...\033[0m"

# Initialize Git Repository
if [ ! -d ".git" ]; then
    git init
    git branch -M main
    echo -e "\033[32m✅ Git repository initialized on branch 'main'.\033[0m"
fi

# Set Remote URL
REMOTE_URL="https://github.com/nerusugnanadeepa/saferide-ai.git"
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE_URL"
echo -e "\033[32m🔗 Configured git remote origin to: $REMOTE_URL\033[0m"

# Commit Base Files
git add .
git commit -m "feat(lead): initial commit with multi-agent architecture and blueprint" || true
echo -e "\033[32m📦 Base commit created on main branch.\033[0m"

# Create Feature Branches
BRANCHES=(
    "feature/agent-1-backend-db"
    "feature/agent-2-driver-geofence-vision"
    "feature/agent-3-parent-fcm-location"
    "feature/agent-4-school-admin-dashboard"
)

for b in "${BRANCHES[@]}"; do
    git branch -f "$b" main
    echo -e "\033[36m🌿 Created branch: $b\033[0m"
done

git checkout main

echo -e "\n\033[32m🎉 Setup Complete! To push all branches to GitHub run:\033[0m"
echo -e "   git push -u origin main"
echo -e "   git push -u origin --all\n"
