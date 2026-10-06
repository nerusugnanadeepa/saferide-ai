# PowerShell Script to Initialize SafeRide AI Git Repository and 4 Agent Branches
# GitHub Repository: https://github.com/nerusugnanadeepa/saferide-ai

Write-Host "🚀 Initializing SafeRide AI Multi-Agent Git Setup..." -ForegroundColor Cyan

if (-not (Test-Path ".git")) {
    git init
    git branch -M main
    Write-Host "✅ Git repository initialized on branch 'main'." -ForegroundColor Green
}

$remoteUrl = "https://github.com/nerusugnanadeepa/saferide-ai.git"
git remote remove origin 2>$null
git remote add origin $remoteUrl
Write-Host "🔗 Configured git remote origin to: $remoteUrl" -ForegroundColor Green

git add .
git commit -m "feat(lead): initial commit with multi-agent architecture and blueprint"

$branches = @(
    "feature/agent-1-backend-db",
    "feature/agent-2-driver-geofence-vision",
    "feature/agent-3-parent-fcm-location",
    "feature/agent-4-school-admin-dashboard"
)

foreach ($b in $branches) {
    git branch -f $b main
    Write-Host "🌿 Created branch: $b" -ForegroundColor Cyan
}

git checkout main

Write-Host "🎉 Setup Complete! To push all branches to GitHub run:" -ForegroundColor Green
Write-Host "   git push -u origin main"
Write-Host "   git push -u origin --all"
