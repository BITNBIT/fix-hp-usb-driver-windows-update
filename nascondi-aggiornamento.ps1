<#
 Hides a Windows Update driver update that keeps coming back
 (default: "Hewlett-Packard - USB - 6/1/2018 12:00:00 AM - 46.2.2631.18152").
 Nasconde un aggiornamento driver di Windows Update che ricompare sempre.
 Uso / Usage:
   .\nascondi-aggiornamento.ps1                 # nasconde l'aggiornamento HP USB 46.2.2631.18152
   .\nascondi-aggiornamento.ps1 -Elenca         # elenca i driver in attesa / list pending drivers
   .\nascondi-aggiornamento.ps1 -Titolo "*Realtek*"   # nasconde un altro aggiornamento
   .\nascondi-aggiornamento.ps1 -Mostra         # lo fa ricomparire / unhide it
#>
param(
  [string]$Titolo = 'Hewlett-Packard - USB*46.2.2631.18152*',
  [switch]$Elenca,
  [switch]$Mostra
)
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) { Write-Host 'Serve avviarlo come amministratore / Run as administrator.' -ForegroundColor Red; exit 1 }
Write-Host 'Cerco gli aggiornamenti driver... / Searching driver updates...'
$searcher = (New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher()
$updates = $searcher.Search("IsInstalled=0 and Type='Driver'").Updates
if ($Elenca) { $updates | ForEach-Object { '{0}  [nascosto/hidden={1}]' -f $_.Title, $_.IsHidden }; exit 0 }
$trovati = 0
foreach ($u in $updates) {
  if ($u.Title -like $Titolo) {
    $u.IsHidden = -not $Mostra
    $trovati++
    Write-Host ("{0}: {1}" -f ($(if ($Mostra) { 'Ripristinato / Unhidden' } else { 'Nascosto / Hidden' })), $u.Title) -ForegroundColor Green
  }
}
if ($trovati -eq 0) { Write-Host "Nessun aggiornamento trovato con: $Titolo  (prova -Elenca)" -ForegroundColor Yellow; exit 2 }
Write-Host 'Fatto. Apri Windows Update e premi "Controlla aggiornamenti": non ricompare piu''.'
