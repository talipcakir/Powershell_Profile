# ============================================================
#  PowerShell Profil Dosyası (Talip Çakır)
#  Amaç:
#   - Hızlı açılış
#   - Stabil autocomplete
#   - Paste / yazım gecikmesi olmaması
#   - Predictor'ları isteğe bağlı çalıştırmak
# ============================================================


# ============================================================
#  SADECE ETKİLEŞİMLİ OTURUMLARDA ÇALIŞSIN
# ============================================================
if ($Host.Name -notmatch 'ConsoleHost|Visual Studio Code Host') { return }


# ============================================================
#  PSREADLINE (NET VE KONTROLLÜ YÜKLEME)
# ============================================================
Import-Module PSReadLine -ErrorAction SilentlyContinue


# ============================================================
#  PSREADLINE PERFORMANS ODAKLI AYARLAR
# ============================================================

# En hızlı prediction modu
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView   # ListView YAVAŞ
Set-PSReadLineOption -EditMode Windows

# History performansı
Set-PSReadLineOption -MaximumHistoryCount 1000
Set-PSReadLineOption -HistorySaveStyle SaveAtExit

# Varsayılan Tab davranışı (TEPP gelene kadar)
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete


# ============================================================
#  RENKLER (Performansa etkisi yok)
# ============================================================
Set-PSReadLineOption -Colors @{
    InlinePrediction = '#6c6c6c'
    ListPrediction   = '#00ff00'
}


# ============================================================
#  CTRL+V SAFE BIND (ÇAKIŞMA OLMASIN DİYE)
# ============================================================
if (-not (Get-PSReadLineKeyHandler | Where-Object Key -eq 'Ctrl+v')) {
    Set-PSReadLineKeyHandler -Chord 'Ctrl+v' -Function Paste
}


# ============================================================
#  TABEXPANSIONPLUSPLUS (LAZY LOAD – GERÇEK HIZ KAZANCI)
# ============================================================
$script:TEPPLoaded = $false

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock {
    if (-not $script:TEPPLoaded) {
        Import-Module TabExpansionPlusPlus -ErrorAction SilentlyContinue
        $script:TEPPLoaded = $true
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::MenuComplete()
}


# ============================================================
#  PREDICTOR MODÜLLERİ (MANUEL KONTROL)
# ============================================================

function Enable-CompletionPredictor {
    Import-Module CompletionPredictor -ErrorAction SilentlyContinue
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Write-Host "CompletionPredictor aktif." -ForegroundColor Yellow
}

function Disable-CompletionPredictor {
    Remove-Module CompletionPredictor -ErrorAction SilentlyContinue
    Set-PSReadLineOption -PredictionSource History
    Write-Host "CompletionPredictor kapatıldı." -ForegroundColor Yellow
}

function Enable-AzPredictor {
    Import-Module Az.Tools.Predictor -ErrorAction SilentlyContinue
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Write-Host "Az.Tools.Predictor aktif." -ForegroundColor Yellow
}

function Disable-AzPredictor {
    Remove-Module Az.Tools.Predictor -ErrorAction SilentlyContinue
    Set-PSReadLineOption -PredictionSource History
    Write-Host "Az.Tools.Predictor kapatıldı." -ForegroundColor Yellow
}


# ============================================================
#  POWERSHELL UPDATE CHECK KAPALI (AÇILIŞ HIZI)
# ============================================================
$env:POWERSHELL_UPDATECHECK = 'Off'


# ============================================================
#  PROFİL SONU
# ============================================================
