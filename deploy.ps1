# deploy.ps1
Write-Host "🚀 Deploying Swippe to GitHub..." -ForegroundColor Green

# Check if we're in the right directory
$expectedFiles = @("backend", "frontend", "database", "README.md")
$missingFiles = $expectedFiles | Where-Object { -not (Test-Path $_) }

if ($missingFiles) {
    Write-Host "❌ Error: Not in project root directory. Missing: $($missingFiles -join ', ')" -ForegroundColor Red
    Write-Host "💡 Make sure you're in: C:\D-Drive\Swippe_Project\Deepseek_Swippe" -ForegroundColor Yellow
    exit 1
}

# Initialize and push to GitHub
if (-not (Test-Path ".git")) {
    git init
    Write-Host "✅ Git initialized" -ForegroundColor Green
}

git add .
git commit -m "Initial commit: Swippe grocery delivery app"

git branch -M main

# Remove any existing remote and add correct one
git remote remove origin 2>$null
git remote add origin https://github.com/ProjectPresentation/swippe-marketplace.git

Write-Host "📤 Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host "🌐 Now connect to:" -ForegroundColor Cyan
    Write-Host "   - Vercel (Frontend): https://vercel.com" -ForegroundColor White
    Write-Host "   - Render (Backend): https://render.com" -ForegroundColor White
    Write-Host "   - Supabase (Database): https://supabase.com" -ForegroundColor White
} else {
    Write-Host "❌ Push failed. You may need to force push with:" -ForegroundColor Red
    Write-Host "   git push -u origin main --force" -ForegroundColor Yellow
}
