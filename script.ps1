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
