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
