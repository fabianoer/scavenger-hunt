# Docker Command Overrides für ScavengerHunt

## 🎯 Standard-Start (ohne Override)
```bash
docker run scavengerhunt:latest
# Startet: C:\ServiceMonitor.exe w3svc
```

## 🔧 Nützliche Command-Overrides

### 1. **Debug-Modus mit PowerShell**
```bash
docker run scavengerhunt:latest powershell
# Startet PowerShell statt IIS für Debugging
```

### 2. **Direkter IIS-Start ohne ServiceMonitor**
```bash
docker run scavengerhunt:latest C:\Windows\System32\inetsrv\w3svc.exe
# Startet IIS direkt ohne ServiceMonitor
```

### 3. **Command Prompt für Troubleshooting**
```bash
docker run scavengerhunt:latest cmd
# Startet Command Prompt für manuelle Untersuchung
```

### 4. **Custom Web.config Test**
```bash
docker run scavengerhunt:latest powershell -Command "Get-Content C:\inetpub\wwwroot\Web.config"
# Zeigt Web.config Inhalt
```

### 5. **Database Connection Test**
```bash
docker run scavengerhunt:latest powershell -Command "Test-NetConnection -ComputerName scavengerhunt-db -Port 1433"
# Testet Datenbankverbindung
```

### 6. **Application Pool Status**
```bash
docker run scavengerhunt:latest powershell -Command "Get-IISAppPool"
# Zeigt IIS Application Pool Status
```

### 7. **Custom Port Binding**
```bash
docker run -p 8080:80 scavengerhunt:latest C:\ServiceMonitor.exe w3svc
# Startet mit explizitem Port Mapping
```

### 8. **Environment Variable Override**
```bash
docker run -e ASPNETCORE_ENVIRONMENT=Development scavengerhunt:latest
# Startet mit Development-Umgebung
```

## 🚀 Docker Compose Overrides

### **docker-compose.override.yml**
```yaml
version: '3.8'
services:
  scavengerhunt-web:
    command: powershell -Command "Write-Host 'Custom startup'; C:\ServiceMonitor.exe w3svc"
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
```

### **Debug-Modus**
```yaml
version: '3.8'
services:
  scavengerhunt-web:
    command: powershell
    stdin_open: true
    tty: true
```

## 🔍 Troubleshooting Commands

### **Container-Logs anzeigen**
```bash
docker logs <container-id>
```

### **Container betreten**
```bash
docker exec -it <container-id> powershell
```

### **Dateien im Container prüfen**
```bash
docker exec <container-id> dir C:\inetpub\wwwroot
```

### **IIS-Status prüfen**
```bash
docker exec <container-id> powershell -Command "Get-Service w3svc"
```

## 💡 Praktische Anwendungen

### **1. Development vs Production**
```bash
# Development
docker run -e ASPNETCORE_ENVIRONMENT=Development scavengerhunt:latest

# Production
docker run -e ASPNETCORE_ENVIRONMENT=Production scavengerhunt:latest
```

### **2. Custom Configuration**
```bash
docker run -v C:\custom-config\Web.config:C:\inetpub\wwwroot\Web.config scavengerhunt:latest
```

### **3. Health Check Override**
```bash
docker run scavengerhunt:latest powershell -Command "while($true) { Test-NetConnection -ComputerName localhost -Port 80; Start-Sleep 30 }"
``` 