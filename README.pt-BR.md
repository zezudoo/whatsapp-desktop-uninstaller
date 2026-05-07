# WhatsAppDesktopUninstaller

Idioma: [English](README.md) | Português (Brasil)

Script PowerShell que detecta e remove as versões do WhatsApp Desktop para
Windows instaladas pela Microsoft Store.

## O Que Ele Remove

- Pacotes AppX instalados para todos os usuários:
  - `5319275A.WhatsAppDesktop`
  - `5319275A.WhatsAppDesktopBeta`
- Pacotes AppX provisionados na imagem do Windows.
- Pastas locais de dados dos pacotes nos perfis de usuário.

## Requisitos

- Windows 10/11.
- PowerShell executado como Administrador.
- Permissão para remover pacotes AppX de todos os usuários.

## Uso

```powershell
.\WA_Detect_Remove.ps1
```

O script mostra os pacotes encontrados, tenta removê-los e continua quando uma
etapa específica de limpeza de perfil ou pacote falha.

## Observações

- Revise o script antes de executá-lo em produção ou distribuí-lo por RMM,
  Intune, GPO ou outra ferramenta de gerenciamento de endpoints.
- Teste com um grupo pequeno antes de uma implantação ampla.
- Este script atua somente em pacotes da Microsoft Store.
