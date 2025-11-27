<#
.SYNOPSIS
  Remove WhatsApp Desktop (Oficial e Beta) da Microsoft Store
  Pacotes:
    - 5319275A.WhatsAppDesktop
    - 5319275A.WhatsAppDesktopBeta
#>

Write-Host "=== Remoção do WhatsApp Desktop (Store) em $env:COMPUTERNAME ===`n"

# Ambas variantes
$pacotesAlvo = @(
    "5319275A.WhatsAppDesktop",
    "5319275A.WhatsAppDesktopBeta"
)

########## 1) REMOVER APPX INSTALADO PARA TODOS OS USUÁRIOS ##########

$pacotes = Get-AppxPackage -AllUsers |
           Where-Object {
               foreach ($p in $pacotesAlvo) {
                   if ($_.Name -eq $p -or $_.PackageFamilyName -like "$p*") { return $true }
               }
           }

if ($pacotes) {
    Write-Host "[STORE] Pacotes WhatsApp encontrados:" -ForegroundColor Yellow
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
    Write-Host "[STORE] Nenhum pacote WhatsApp encontrado."
}

Write-Host ""

########## 2) REMOVER PACOTES PROVISIONADOS ##########

$prov = Get-AppxProvisionedPackage -Online |
        Where-Object {
            foreach ($p in $pacotesAlvo) {
                if ($_.DisplayName -eq $p -or $_.PackageName -like "$p*") { return $true }
            }
        }

if ($prov) {
    Write-Host "[STORE] Pacotes provisionados do WhatsApp encontrados:" -ForegroundColor Yellow
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
    Write-Host "[STORE] Nenhum pacote provisionado do WhatsApp encontrado."
}

Write-Host ""

########## 3) LIMPAR PASTAS DE DADOS (Ambas versões) ##########

$userFolders = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -notin @("Public","Default","Default User","All Users")
}

foreach ($u in $userFolders) {
    $packagesDir = Join-Path $u.FullName "AppData\Local\Packages"
    if (Test-Path $packagesDir) {
        $waDirs = Get-ChildItem $packagesDir -Directory -ErrorAction SilentlyContinue |
                  Where-Object {
                      foreach ($p in $pacotesAlvo) {
                          if ($_.Name -like "$p*") { return $true }
                      }
                  }

        foreach ($dir in $waDirs) {
            Write-Host "Removendo pasta de dados: $($dir.FullName)" -ForegroundColor Cyan
            Remove-Item $dir.FullName -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "`nConcluído. WhatsApp Desktop (Oficial e Beta) removido."