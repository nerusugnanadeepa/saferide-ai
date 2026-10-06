# PowerShell Script to Initialize SafeRide AI Git Repository and 4 Agent Branches
# GitHub Repository: https://github.com/nerusugnanadeepa/saferide-ai

Write-Host "🚀 Initializing SafeRide AI Multi-Agent Git Setup..." -ForegroundColor Cyan

# Check if git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed or not in PATH."
    exit 1
}

# Initialize Git Repository
if (-not (Test-Path ".git")) {
    git init
    git branch -M main
    Write-Host "✅ Git repository initialized on branch 'main'." -ForegroundColor Green
} else {
    Write-Host "ℹ️ Git repository already exists." -ForegroundColor Yellow
}

# Set GitHub Remote URL
$remoteUrl = "https://github.com/nerusugnanadeepa/saferide-ai.git"
git remote remove origin 2>$null
git remote add origin $remoteUrl
Write-Host "🔗 Configured git remote origin to: $remoteUrl" -ForegroundColor Green

# Stage and Commit Base Files
git add .
git commit -m "feat(lead): initial commit with multi-agent architecture and blueprint"
Write-Host "📦 Base commit created on main branch." -ForegroundColor Green

# Create 4 Sub-Agent Feature Branches
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

# Return to main branch
git checkout main

Write-Host ""
Write-Host "🎉 Setup Complete! To push all branches to GitHub run:" -ForegroundColor Green
Write-Host "   git push -u origin main" -ForegroundColor White
Write-Host "   git push -u origin --all" -ForegroundColor White
Write-Host ""
