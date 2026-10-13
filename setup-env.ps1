# Setup Environment Files
# This script copies all .env.example files to .env

Write-Host "Setting up environment files..." -ForegroundColor Cyan

$envFiles = @(
    "packages\db\.env",
    "apps\api\.env",
    "apps\engine\.env",
    "apps\db-worker\.env",
    "apps\ws\.env",
    "apps\price-service\.env",
    "apps\liquidator\.env",
    "apps\funding-service\.env"
)

foreach ($file in $envFiles) {
    $source = "$file.example"
    if (Test-Path $source) {
        Copy-Item $source $file -Force
        Write-Host "✓ Created $file" -ForegroundColor Green
    } else {
        Write-Host "✗ Source not found: $source" -ForegroundColor Red
    }
}

Write-Host "`nAll environment files created!" -ForegroundColor Green
Write-Host "`nDatabase Configuration:" -ForegroundColor Yellow
Write-Host "  Name: perpsv2"
Write-Host "  User: root"
Write-Host "  Password: root"
Write-Host "  Port: 3306"
Write-Host "`nConnection String:" -ForegroundColor Yellow
Write-Host "  mysql://root:root@localhost:3306/perpsv2" -ForegroundColor White

Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "  1. Create MySQL database: mysql -u root -p -e 'CREATE DATABASE perpsv2;'"
Write-Host "  2. Run migrations: cd packages\db && bun run prisma migrate dev"
Write-Host "  3. Start services: .\start-all.ps1"
