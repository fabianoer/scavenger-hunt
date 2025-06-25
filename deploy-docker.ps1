# ScavengerHunt Docker Deployment Script
# PowerShell script to build and deploy the application

Write-Host "🚀 Starting ScavengerHunt Docker Deployment..." -ForegroundColor Green

# Check if Docker is running
try {
    docker version | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Function to build with different Dockerfile options
function Build-DockerImage {
    param(
        [string]$Dockerfile = "Dockerfile"
    )
    
    Write-Host "🔨 Building Docker image with $Dockerfile..." -ForegroundColor Yellow
    
    if ($Dockerfile -eq "Dockerfile") {
        docker build -t scavengerhunt:latest .
    } else {
        docker build -f $Dockerfile -t scavengerhunt:latest .
    }
    
    return $LASTEXITCODE
}

# Try building with different Dockerfile variants
$dockerfiles = @("Dockerfile", "Dockerfile.simple", "Dockerfile.windows", "Dockerfile.nuget", "Dockerfile.alternative")

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
    Write-Host "💡 Try running manually with one of these commands:" -ForegroundColor Yellow
    Write-Host "   docker build -f Dockerfile.simple -t scavengerhunt:latest ." -ForegroundColor Gray
    Write-Host "   docker build -f Dockerfile.windows -t scavengerhunt:latest ." -ForegroundColor Gray
    Write-Host "   docker build -f Dockerfile.nuget -t scavengerhunt:latest ." -ForegroundColor Gray
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