# Fonction pour afficher l'aide
function Show-Help {
    Write-Host "Utilisation :"
    Write-Host "  .\MonScript.ps1 -resetPwd"
    Write-Host "  .\MonScript.ps1 -fichierSrc <chemin_fichier_source> -fichierDst <chemin_dossier_destination>"
    Write-Host
    Write-Host "Description :"
    Write-Host "  Ce script permet de soit réinitialiser un mot de passe, soit de copier un fichier d'un emplacement à un autre."
    Write-Host
    Write-Host "Paramètres :"
    Write-Host "  -resetPwd            : Réinitialise le mot de passe de l'utilisateur."
    Write-Host "  -fichierSrc <chemin> : Chemin du fichier source à copier."
    Write-Host "  -fichierDst <chemin> : Chemin de destination où copier le fichier."
    Write-Host "  -h ou --help         : Affiche cette aide."
    exit
}

# Initialisation des variables
$resetPwd = $false
$fichierSrc = $null
$fichierDst = $null

# Parcourir les arguments fournis
for ($i = 0; $i -lt $args.Length; $i++) {
    switch ($args[$i]) {
        "-resetPwd" {
            $resetPwd = $true
        }
        "-fichierSrc" {
            $i++
            if ($i -lt $args.Length) { $fichierSrc = $args[$i] }
        }
        "-fichierDst" {
            $i++
            if ($i -lt $args.Length) { $fichierDst = $args[$i] }
        }
        "-h" { Show-Help }
        "--help" { Show-Help }
        default {
            Write-Host "Paramètre inconnu : $($args[$i])"
            Show-Help
        }
    }
}

# Vérifier si les paramètres requis sont présents
if ($resetPwd) {
    Write-Host "Réinitialisation du mot de passe de l'utilisateur..."
    # Logique de réinitialisation ici
    Write-Host "Mot de passe réinitialisé avec succès."
} elseif ($fichierSrc -and $fichierDst) {
    if (Test-Path $fichierSrc) {
        Write-Host "Le fichier '$fichierSrc' existe. Copie en cours vers '$fichierDst'..."
        Copy-Item -Path $fichierSrc -Destination $fichierDst -Force
        Write-Host "Fichier copié avec succès."
    } else {
        Write-Host "Erreur : Le fichier source '$fichierSrc' n'existe pas."
    }
} else {
    Show-Help  # Affiche l'aide si les paramètres sont incorrects
}

# Fonction pour afficher l'aide du script
function Show-Help {
    Write-Host "Utilisation :"
    Write-Host "  .\MonScript.ps1 -resetPwd"
    Write-Host "  .\MonScript.ps1 -fichierSrc <chemin_fichier_source> -fichierDst <chemin_dossier_destination>"
    Write-Host
    Write-Host "Description :"
    Write-Host "  Ce script permet de soit réinitialiser un mot de passe, soit de copier un fichier d'un emplacement à un autre."
    Write-Host
    Write-Host "Paramètres :"
    Write-Host "  -resetPwd            : Réinitialise le mot de passe de l'utilisateur."
    Write-Host "  -fichierSrc <chemin> : Chemin du fichier source à copier."
    Write-Host "  -fichierDst <chemin> : Chemin de destination où copier le fichier."
    Write-Host "  -h ou --help         : Affiche cette aide."
    Write-Host
    Write-Host "Exemples :"
    Write-Host "  .\MonScript.ps1 -resetPwd"
    Write-Host "  .\MonScript.ps1 -fichierSrc 'C:\source\monFichier.txt' -fichierDst 'C:\dossier_destination'"
    exit
}

# Définition des paramètres
param (
    [switch]$resetPwd,
    [string]$fichierSrc,
    [string]$fichierDst,
    [switch]$Help
)

# Affiche l'aide si aucun paramètre n'est fourni, ou si -h / --help est utilisé
if ($Help -or (-not $resetPwd -and -not ($fichierSrc -and $fichierDst))) {
    Show-Help
}

# Cas 1 : Exécution de l'option -resetPwd
if ($resetPwd) {
    Write-Host "Réinitialisation du mot de passe de l'utilisateur..."
    # Ajoutez ici la logique de réinitialisation de mot de passe
    Write-Host "Mot de passe réinitialisé avec succès."
}

# Cas 2 : Copie de fichier avec -fichierSrc et -fichierDst
elseif ($fichierSrc -and $fichierDst) {
    if (Test-Path $fichierSrc) {
        Write-Host "Le fichier '$fichierSrc' existe. Copie en cours vers '$fichierDst'..."
        Copy-Item -Path $fichierSrc -Destination $fichierDst -Force
        Write-Host "Fichier copié avec succès."
    } else {
        Write-Host "Erreur : Le fichier source '$fichierSrc' n'existe pas."
    }
} else {
    Show-Help  # Si les paramètres sont incorrects, afficher l'aide
}

# Fonction pour afficher l'aide du script
function Show-Help {
    Write-Host "Utilisation :"
    Write-Host "  .\MonScript.ps1 -Param1 <valeur1> -Param2 <valeur2>"
    Write-Host
    Write-Host "Description :"
    Write-Host "  Ce script exécute une série d'actions en fonction des paramètres fournis."
    Write-Host
    Write-Host "Paramètres :"
    Write-Host "  -Param1 <valeur1> : Description du premier paramètre."
    Write-Host "  -Param2 <valeur2> : Description du second paramètre."
    Write-Host "  -h ou --help      : Affiche cette aide."
    Write-Host
    Write-Host "Exemple :"
    Write-Host "  .\MonScript.ps1 -Param1 'exemple' -Param2 'valeur'"
    exit
}

# Vérification des paramètres
param (
    [string]$Param1,
    [string]$Param2,
    [switch]$Help
)

# Affiche l'aide si aucun paramètre n'est fourni ou si -h / --help est utilisé
if (-not $Param1 -and -not $Param2 -or $Help) {
    Show-Help
}

# Code principal du script
Write-Host "Exécution du script avec les paramètres suivants :"
Write-Host "Param1 = $Param1"
Write-Host "Param2 = $Param2"

# Fonction pour crypter une chaîne de caractères
function Encrypt-String {
    param (
        [string]$PlainText,
        [string]$Passphrase,
        [string]$OutputFilePath
    )

    # Convertit la passphrase en clé pour l'algorithme de cryptage
    $Key = (New-Object Security.Cryptography.SHA256Managed).ComputeHash([Text.Encoding]::UTF8.GetBytes($Passphrase))

    # Initialise le vecteur d'initialisation (IV)
    $AES = New-Object System.Security.Cryptography.AesManaged
    $AES.Key = $Key
    $AES.GenerateIV()
    $IV = $AES.IV

    # Crypte la chaîne de caractères
    $Encryptor = $AES.CreateEncryptor()
    $PlainBytes = [Text.Encoding]::UTF8.GetBytes($PlainText)
    $CipherBytes = $Encryptor.TransformFinalBlock($PlainBytes, 0, $PlainBytes.Length)

    # Combine le IV et le texte chiffré
    $DataToSave = [byte[]]@($IV + $CipherBytes)

    # Sauvegarde dans le fichier
    Set-Content -Path $OutputFilePath -Value ([Convert]::ToBase64String($DataToSave))
    Write-Output "La chaîne a été cryptée et enregistrée dans $OutputFilePath"
}

# Fonction pour décrypter une chaîne de caractères
function Decrypt-String {
    param (
        [string]$Passphrase,
        [string]$InputFilePath
    )

    # Récupère la clé de la passphrase
    $Key = (New-Object Security.Cryptography.SHA256Managed).ComputeHash([Text.Encoding]::UTF8.GetBytes($Passphrase))

    # Récupère les données chiffrées
    $EncryptedData = [Convert]::FromBase64String((Get-Content -Path $InputFilePath -Raw))

    # Sépare le IV et le texte chiffré
    $AES = New-Object System.Security.Cryptography.AesManaged
    $AES.Key = $Key
    $AES.IV = $EncryptedData[0..15]
    $CipherBytes = $EncryptedData[16..($EncryptedData.Length - 1)]

    # Déchiffre la chaîne de caractères
    $Decryptor = $AES.CreateDecryptor()
    $PlainBytes = $Decryptor.TransformFinalBlock($CipherBytes, 0, $CipherBytes.Length)
    $PlainText = [Text.Encoding]::UTF8.GetString($PlainBytes)

    Write-Output "La chaîne décryptée est : $PlainText"
    return $PlainText
}

# Exemples d'utilisation
# Encrypt-String -PlainText "MonMotDePasse" -Passphrase "MaPassphrase" -OutputFilePath "chemin\vers\le\fichier.txt"
# Decrypt-String -Passphrase "MaPassphrase" -InputFilePath "chemin\vers\le\fichier.txt"
