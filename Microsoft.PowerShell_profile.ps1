# ============================================================
#  PowerShell Profil Dosyam (Talip Çakır)
#  Bu dosyayı kendi makinenize eklemek için:
#      notepad $PROFILE
#  açılan dosyaya bu içeriği yapıştırmanız yeterli.
#
#  Bu profili kullanmadan önce aşağıdaki modülleri kurmalısınız:
#
#  PSReadLine (genelde yüklü gelir ama güncellemek isterseniz)
#      Install-Module PSReadLine -Scope CurrentUser -Force
#
#  Gelişmiş otomatik tamamlama için TabExpansionPlusPlus:
#      Install-Module TabExpansionPlusPlus -Scope CurrentUser
#
#  (İsteğe bağlı) Predictor modülleri:
#      Install-Module CompletionPredictor -Scope CurrentUser
#      Install-Module Az.Tools.Predictor -Scope CurrentUser
#
#  Bu profil hızlı açılma + sorunsuz autocomplete + stabil PSReadLine
#  için optimize edilmiştir.
# ============================================================


# ============================================================
#  ETKİLEŞİMLİ OTURUM KONTROLÜ
#  Profile gereksiz yük bindirmemesi için sadece terminal/VSC'de çalıştırıyorum.
# ============================================================
if ($Host.Name -notmatch 'ConsoleHost|Visual Studio Code Host') { return }


# ============================================================
#  PSREADLINE AYARLARI
#  Hızlı olması için sadece geçmiş tabanlı prediction kullanıyorum.
#  (Plugin prediction açınca paste-yazım yavaşlıyor)
# ============================================================
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -MaximumHistoryCount 2500
Set-PSReadLineOption -HistorySaveStyle SaveAtExit

# Tab tuşu menü şeklinde tamamlama yapsın istiyorum
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Kendi renk düzenim
Set-PSReadLineOption -Colors @{
    InlinePrediction = '#6c6c6c'
    ListPrediction   = '#00ff00'
}

# Ctrl+V doğrudan yapıştırsın (bazı terminaller PSReadLine ile çakışabiliyor)
Set-PSReadLineKeyHandler -Chord 'Ctrl+v' -Function Paste -ErrorAction SilentlyContinue


# ============================================================
#  TABEXPANSIONPLUSPLUS
#  (php, node, git, docker vb. için gelişmiş otomatik tamamlama sağlar)
#  Modül kurulu değilse PowerShell hata vermesin diye -ErrorAction ekledim.
# ============================================================
Import-Module TabExpansionPlusPlus -ErrorAction SilentlyContinue


# ============================================================
#  İSTEĞE BAĞLI PREDICTOR MODÜLLERİ
#  Bu modüller iyi tamamlıyor ama PowerShell'i de yavaşlatıyor.
#  Bu yüzden otomatik yüklemiyorum; ihtiyaç duyarsam manuel açıyorum.
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
    try { Disable-AzPredictor } catch {}
    Remove-Module Az.Tools.Predictor -ErrorAction SilentlyContinue
    Set-PSReadLineOption -PredictionSource History
    Write-Host "Az.Tools.Predictor kapatıldı." -ForegroundColor Yellow
}


# ============================================================
#  POWERSHELL GÜNCELLEME KONTROLÜNÜ KAPATIYORUM
#  Açılışı gereksiz yere yavaşlatmasın.
# ============================================================
$env:POWERSHELL_UPDATECHECK = 'Off'

# ============================================================
#  PROFİL SONU
# ============================================================
