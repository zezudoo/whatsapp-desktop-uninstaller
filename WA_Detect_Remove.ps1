<#
.SYNOPSIS
  Remove WhatsApp Desktop oficial da Microsoft Store
  Pacote: 5319275A.WhatsAppDesktop
#>

Write-Host "=== Remoção do WhatsApp Desktop (Store) em $env:COMPUTERNAME ===`n"

$pacoteNome = "5319275A.WhatsAppDesktop"

########## 1) REMOVER APPX INSTALADO PARA TODOS OS USUÁRIOS ##########

$pacotes = Get-AppxPackage -AllUsers |
           Where-Object {
               $_.Name -eq $pacoteNome -or
               $_.PackageFamilyName -like "$pacoteNome*"
           }

if ($pacotes) {
    Write-Host "[STORE] Pacotes WhatsApp Desktop encontrados:" -ForegroundColor Yellow
    $pacotes | Select-Object Name, PackageFullName, PackageFamilyName, UserSid | Format-Table -AutoSize

    foreach ($pkg in $pacotes) {
        Write-Host "Removendo pacote $($pkg.PackageFullName)..." -ForegroundColor Cyan
        try {
            Remove-AppxPackage -Package $pkg.PackageFullName -AllUsers -ErrorAction Stop
        } catch {
            Write-Warning "Falha ao remover $($pkg.PackageFullName): $($_.Exception.Message)"
        }
    }
} else {
    Write-Host "[STORE] Nenhum pacote 5319275A.WhatsAppDesktop encontrado."
}

Write-Host ""

########## 2) REMOVER PACOTES PROVISIONADOS (PARA NOVOS PERFIS) ##########

$prov = Get-AppxProvisionedPackage -Online |
        Where-Object {
            $_.DisplayName -eq $pacoteNome -or
            $_.PackageName  -like "$pacoteNome*"
        }

if ($prov) {
    Write-Host "[STORE] Pacotes provisionados do WhatsApp Desktop encontrados:" -ForegroundColor Yellow
    $prov | Select-Object DisplayName, PackageName | Format-Table -AutoSize

    foreach ($p in $prov) {
        Write-Host "Removendo provisionado $($p.PackageName)..." -ForegroundColor Cyan
        try {
            Remove-AppxProvisionedPackage -Online -PackageName $p.PackageName -ErrorAction Stop
        } catch {
            Write-Warning "Falha ao remover provisionado $($p.PackageName): $($_.Exception.Message)"
        }
    }
} else {
    Write-Host "[STORE] Nenhum pacote provisionado do WhatsApp Desktop encontrado."
}

Write-Host ""

########## 3) LIMPAR PASTAS DE DADOS DO USUÁRIO ##########
# Apenas a pasta do Appx da Store: %LOCALAPPDATA%\Packages\5319275A.WhatsAppDesktop_*

$userFolders = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -notin @("Public","Default","Default User","All Users")
}

foreach ($u in $userFolders) {
    $packagesDir = Join-Path $u.FullName "AppData\Local\Packages"
    if (Test-Path $packagesDir) {
        $waDirs = Get-ChildItem $packagesDir -Directory -ErrorAction SilentlyContinue |
                  Where-Object { $_.Name -like "$pacoteNome*" }

        foreach ($dir in $waDirs) {
            Write-Host "Removendo pasta de dados do WhatsApp Desktop: $($dir.FullName)" -ForegroundColor Cyan
            Remove-Item $dir.FullName -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "`nConcluído. WhatsApp Desktop da Store foi removido."
