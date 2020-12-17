# Dit script zoekt op basis van een lijst met namen (voor- en achternamen of initialen en achternamen) de bijbehorende accountnaam op

# Vul of de lijst met namen rechtstreeks in de array of laad een .txt bestand in. LET OP: Pas wel de locatie achter -path aan naar de locatie van het bestand (inclusief bestandnaam)
# Verwijder het # voor de optie die je wenst te gebruiken

# $FullNameArray = @("L.J. Wijnands", "Yargo Bool", "M.R.A. Ammerlaan")
# $FullNameArray = Get-Content -Path C:\Users\loc.BOOY3105\Desktop\FullNames.txt

#Loop die door alle namen heen loopt
ForEach($FullName in $FullNameArray){
    
    # Pakt de achternaam uit de string
    [String]$SurName = $FullName.Split(" ")[1]

    # Zoekt uit of het voorste gedeelte initialen zijn of volledige voornaam
    If($Fullname -like '*.*'){
        [String]$Initials = $FullName.Split(" ")[0]
    }
    Else {
        [String]$GivenName = $FullName.Split(" ")[0]
        }
  
  # Haalt de inlognaam op
    Get-ADUser -Filter{(Initials -eq $Initials) -and (Surname -eq $SurName) -or (GivenName -eq $GivenName) -and (Surname -eq $SurName)} | Select-Object SamAccountName
    }