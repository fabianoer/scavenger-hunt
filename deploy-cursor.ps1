# ScavengerHunt Cursor Deployment Script
# PowerShell script specifically for Cursor deployment

Write-Host "🚀 Starting ScavengerHunt Cursor Deployment..." -ForegroundColor Green

# Check if Docker is running
try {
    docker version | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Check Docker platform
$platform = docker version --format "{{.Server.Os}}"
Write-Host "🔍 Docker platform: $platform" -ForegroundColor Cyan

# Function to build with different Dockerfile options
function Build-DockerImage {
    param(
        [string]$Dockerfile = "Dockerfile.cursor-simple"
    )
    
    Write-Host "🔨 Building Docker image with $Dockerfile..." -ForegroundColor Yellow
    
    if ($Dockerfile -eq "Dockerfile") {
        docker build -t scavengerhunt:latest .
    } else {
        docker build -f $Dockerfile -t scavengerhunt:latest .
    }
    
    return $LASTEXITCODE
}

# Try building with Cursor-optimized Dockerfiles first
$dockerfiles = @("Dockerfile.cursor-simple", "Dockerfile.cursor", "Dockerfile.simple", "Dockerfile")

foreach ($dockerfile in $dockerfiles) {
    Write-Host "🔄 Trying $dockerfile..." -ForegroundColor Cyan
    $buildResult = Build-DockerImage $dockerfile
    
    if ($buildResult -eq 0) {
        Write-Host "✅ Docker image built successfully with $dockerfile" -ForegroundColor Green
        break
    } else {
        Write-Host "❌ $dockerfile failed, trying next..." -ForegroundColor Red
    }
}

if ($buildResult -ne 0) {
    Write-Host "❌ All Docker build attempts failed" -ForegroundColor Red
    Write-Host "💡 Try these manual commands:" -ForegroundColor Yellow
    Write-Host "   docker build -f Dockerfile.cursor-simple -t scavengerhunt:latest ." -ForegroundColor Gray
    Write-Host "   docker build -f Dockerfile.cursor -t scavengerhunt:latest ." -ForegroundColor Gray
    Write-Host "   docker build -f Dockerfile.simple -t scavengerhunt:latest ." -ForegroundColor Gray
    Write-Host ""
    Write-Host "🔧 If you're on Linux, try:" -ForegroundColor Yellow
    Write-Host "   docker build -f Dockerfile.linux -t scavengerhunt:latest ." -ForegroundColor Gray
    exit 1
}

# Stop and remove existing containers
Write-Host "🛑 Stopping existing containers..." -ForegroundColor Yellow
docker-compose down

# Start the application with docker-compose
Write-Host "🚀 Starting application with docker-compose..." -ForegroundColor Yellow
docker-compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Application deployed successfully!" -ForegroundColor Green
    Write-Host "🌐 Application is running at: http://localhost:8080" -ForegroundColor Cyan
    Write-Host "🗄️  Database is running at: localhost:1433" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📋 Useful commands:" -ForegroundColor Yellow
    Write-Host "   docker-compose logs -f scavengerhunt-web" -ForegroundColor Gray
    Write-Host "   docker-compose down" -ForegroundColor Gray
    Write-Host "   docker-compose restart" -ForegroundColor Gray
} else {
    Write-Host "❌ Deployment failed" -ForegroundColor Red
    exit 1
} 