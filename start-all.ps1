# Start All Services Script
# This script starts all perps-v2 services in separate windows

Write-Host "Starting Perps V2 Services..." -ForegroundColor Cyan

# Check if MySQL is running
$mysqlService = Get-Service MySQL* -ErrorAction SilentlyContinue | Select-Object -First 1
if ($mysqlService) {
    if ($mysqlService.Status -ne 'Running') {
        Write-Host "Starting MySQL service..." -ForegroundColor Yellow
        Start-Service $mysqlService.Name
        Start-Sleep -Seconds 2
    }
    Write-Host "✓ MySQL is running" -ForegroundColor Green
} else {
    Write-Host "⚠ MySQL service not found. Make sure MySQL is installed." -ForegroundColor Yellow
}

# Start Redis (WSL2)
Write-Host "Starting Redis..." -ForegroundColor Yellow
Start-Process wsl -ArgumentList "sudo service redis-server start" -WindowStyle Hidden
Start-Sleep -Seconds 2

# Check if Redis is running
$redisPing = wsl redis-cli ping 2>$null
if ($redisPing -eq "PONG") {
    Write-Host "✓ Redis is running" -ForegroundColor Green
} else {
    Write-Host "⚠ Redis might not be running. Check manually: wsl redis-cli ping" -ForegroundColor Yellow
}

Write-Host "`nStarting services..." -ForegroundColor Cyan

# Define services to start
$services = @(
    @{Name="API"; Path="apps\api"},
    @{Name="Engine"; Path="apps\engine"},
    @{Name="DB Worker"; Path="apps\db-worker"},
    @{Name="WebSocket"; Path="apps\ws"},
    @{Name="Price Service"; Path="apps\price-service"},
    @{Name="Liquidator"; Path="apps\liquidator"},
    @{Name="Web Frontend"; Path="apps\web"}
)

foreach ($service in $services) {
    Start-Process pwsh -ArgumentList "-NoExit", "-Command", "cd $($service.Path); Write-Host 'Starting $($service.Name)...' -ForegroundColor Cyan; bun run dev"
    Write-Host "✓ Started $($service.Name)" -ForegroundColor Green
    Start-Sleep -Milliseconds 500
}

Write-Host "`n" -NoNewline
Write-Host "========================================" -ForegroundColor Green
Write-Host "All services started successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host "`nAccess Points:" -ForegroundColor Yellow
Write-Host "  Frontend:  " -NoNewline -ForegroundColor White
Write-Host "http://localhost:3000" -ForegroundColor Cyan
Write-Host "  API:       " -NoNewline -ForegroundColor White
Write-Host "http://localhost:3001" -ForegroundColor Cyan
Write-Host "  WebSocket: " -NoNewline -ForegroundColor White
Write-Host "ws://localhost:8080" -ForegroundColor Cyan

Write-Host "`nDatabase:" -ForegroundColor Yellow
Write-Host "  Name: perpsv2"
Write-Host "  User: root"
Write-Host "  Password: root"

Write-Host "`nPress Ctrl+C in each window to stop services." -ForegroundColor Gray
