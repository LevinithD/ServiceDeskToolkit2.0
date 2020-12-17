<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER

.EXAMPLE

.NOTES

.LINK
#>

#  Assemblies toevoegen. Dit geeft dit programma de mogelijkheid om gebruik te maken van functionaliteiten die ingebouwd zitten in het OS.
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Function Start-ServiceDeskToolkit
{

Auto-Update

Create-Form -UserName $UserName -ComputerName $ComputerName -PrinterName $PrinterName
}

Function Auto-Update
{
<# Het dollar teken in deze expressie geeft aan dat hier een om een sub-exrpessie betreft -> dat wil zeggen een functie in een functie.
Get-Item stelt je in staat om een bestand/map ergens vandaan te halen en deze te manipuleren. In dit geval wordt 

#>
if ($(Get-Item C:\temp\ServiceDeskToolkit20.ps1).CreationTimeUtc -gt $(Get-Item $PSCommandPath).CreationTimeUtc) 
    {
        # Copy-Item kopieert de nieuwe versie van de ServiceDeskToolkit naar de huidige locatie van je bestand. 
        Copy-Item C:\temp\ServiceDeskToolkit20.ps1 $PSCommandPath
        
        # Past de creatie-tijd van het bestand naar nu
        $(Get-Item $PSCommandPath).CreationTimeUtc = [DateTime]::UtcNow
        
        # Open het bestand
        &$PSCommandPath
        
        # Stap uit de script
        exit
    }
}

Function Create-Form
{

    [cmdletbinding()]

    param($UserName,
          $ComputerName,
          $PrinterName)
    
    ####################################################################

    # Maak het formulier
    $frm_Toolkit = New-Object System.Windows.Forms.Form
    $frm_Toolkit.Text = "ServiceDesk Toolkit 2.0"
    $frm_Toolkit.Height = 920
    $frm_Toolkit.Width = 900

    ####################################################################
    
    # Maak het rechtermuisklik-menu voor het Tabblad ADUSer
    $contextMenuStrip_ADUser = New-Object System.Windows.Forms.ContextMenuStrip

    # Mogelijkheid om accounts te vergrendelen/ontgrendelen
    [System.Windows.Forms.ToolStripItem]$toolStripItemUnlockAccount = New-Object System.Windows.Forms.ToolStripMenuItem
    $toolStripItemUnlockAccount.Text = "Unlock Account"
    $toolStripItemUnlockAccount.add_Click({Unlock-Account -username $txt_ADUser.Text})
    
    [System.Windows.Forms.ToolStripItem]$toolStripItemResetPassword = New-Object System.Windows.Forms.ToolStripMenuItem
    $toolStripItemResetPassword.Text = "Reset Password"
    $toolStripItemResetPassword.add_Click({Set-Password -username $txt_ADUser.Text})

    [System.Windows.Forms.ToolStripItem]$toolStripItemEnableAccount = New-Object System.Windows.Forms.ToolStripMenuItem
    $toolStripItemEnableAccount.Text = "Enable Account"
    $toolStripItemEnableAccount.add_Click({EnableDisable-Account -username $txt_ADUser.Text -Enable 1})

    [System.Windows.Forms.ToolStripItem]$toolStripItemHomeDrive = New-Object System.Windows.Forms.ToolStripMenuItem
    $toolStripItemHomeDrive.Text = "Open HomeDrive"
    $toolStripItemHomeDrive.add_Click({Open-Homedrive -username $txt_ADUser.Text})

    [System.Windows.Forms.ToolStripItem]$toolStripItemCopy = New-Object System.Windows.Forms.ToolStripMenuItem
    $toolStripItemCopy.Text = "Copy"
    $toolStripItemCopy.add_Click({Copy-Screen})

    $contextMenuStrip_ADUser.Items.AddRange(@($toolStripItemUnlockAccount, $toolStripItemResetPassword, $toolStripItemEnableAccount, $toolStripItemHomeDrive, $toolStripItemCopy))
    
    ####################################################################

    # Maak de menubar
    $MenuStrip_Main = New-Object System.Windows.Forms.MenuStrip
    
    # Bepaal de eigenschappen van de menubar
    $MenuStrip_Main.Location = New-Object System.Drawing.Point(0,0)
    $MenuStrip_Main.Size = New-Object System.Drawing.Size(0,900)
    $MenuStrip_Main.Name  = "MenuStrip_Main"
    $MenuStrip_Main.Text = "menuStrip1"

    # Maak Opties voor Menustrip
    $ToolStripMenuItem_File = New-Object System.Windows.Forms.ToolStripMenuItem
        
    # Bepaal de eigenschappen van het menu File
    $Toolstripmenuitem_File.size = New-Object System.Drawing.Size(10,30)
    $Toolstripmenuitem_File.text = "&Bestand"

    $Toolstripmenuitem_OpenFile = New-Object System.Windows.Forms.ToolStripMenuItem

    # Bepaal de eigenschappen van het menu Open
    $ToolStripMenuItem_openFile.Size = New-Object System.Drawing.Size(10,30)
    $ToolStripMenuItem_OpenFile.Text = "&Open"

    ####################################################################

    # Maak een Tabcontrol voor de verschillende tabpagina's
    $TabControl = New-Object System.Windows.Forms.TabControl
    $TabControl.Location = New-Object System.Drawing.Point(0,25)
    $TabControl.Height = 900
    $TabControl.Width = 900

    ####################################################################
    
    # Maak de tabpagina voor Gebruikers
    $TabPage_ADUser = New-Object System.Windows.Forms.TabPage
    $TabPage_ADUser.Text = "Gebruiker info"
    $TabPage_ADUser.ContextMenuStrip = $contextMenuStrip_ADUser
    
    # Maken van controls voor de tabpagina
    # ADUser Label
    $lbl_ADUser = New-Object System.Windows.Forms.Label
    $lbl_ADUser.Location = New-Object System.Drawing.Point(10,10)
    $lbl_ADUser.Text = "Gebruikersnaam"

    # ADUserName Textbox voor het invullen van de op te zoeken gebruiker
    $txt_ADUser = New-Object System.Windows.Forms.TextBox
    $txt_ADUser.Location = New-Object System.Drawing.Point(150,10)
    $txt_ADUser.Height = 10
    $txt_ADUser.Width = 300
    
    # Zorgt ervoor dat bij het indrukken van enter er ook gezocht wordt
    $txt_ADUser.add_keydown({if ($_.Keycode -eq "Enter") {Get-UserInfo -Username $txt_ADUser.Text}})
        
    # ADUser knop om de gebruiker op te zoeken
    $btn_ADUser = New-Object System.Windows.Forms.Button
    $btn_ADUser.Location = New-Object System.Drawing.Point(600, 10)
    $btn_ADUser.text = "Search"
    $btn_ADUser.Height = 30
    $btn_ADUser.Width = 100
    
    # Zoek de bijbehorende gegevens op na indrukken van de knop
    $btn_ADUser.add_click({Get-UserInfo -Username $txt_ADUser.Text})   

    <# 
    Om de een of andere reden moet de informatie eerst worden opgezocht voordat de Datagridview wordt aangelegd. Er moet gekeken worden of hier een refresh mogelijkheid bestaat om de 
    Datagridview te verversen met nieuwe data. Als dit kan (en we weten hoe), dan maakt het niet meer uit wanneer de data wordt ingeladen
    #>

    # ADComputerDataGridView voor resultaten Get-ADUser
    $dgv_ADUser = New-Object System.Windows.Forms.DataGridView
    $dgv_ADUser.Location = New-Object System.Drawing.Point(10,50)
    $dgv_ADUser.Height = 750
    $dgv_ADUser.Width = 450
    $dgv_ADUser.ColumnHeadersVisible = $true
    $dgv_ADUser.AutoSizeColumnsMode = "AllCells"
    $dgv_ADUser.DataSource = $ADUserList
    
    $dgv_ADUser.add_MouseDown(
    {
        $sender = $args[0]
        [System.Windows.Forms.MouseEventArgs]$e= $args[1]

        if ($e.Button -eq  [System.Windows.Forms.MouseButtons]::Right)
        {
            [System.Windows.Forms.DataGridView+HitTestInfo] $hit = $DataGrid1.HitTest($e.X, $e.Y);
            if ($hit.Type -eq [System.Windows.Forms.DataGridViewHitTestType]::Cell)
            {
                $contextMenuStrip_Main.Show() 
            }
        }
    })
    
    # Datagridview voor sessies opgezochte gebruiker
    $dgv_ADUserSession = New-Object System.Windows.Forms.DataGridView
    $dgv_ADUserSession.Location = New-Object System.Drawing.Point(500,250)
    $dgv_ADUserSession.Height = 250
    $dgv_ADUserSession.Width = 350
    $dgv_ADUserSession.ColumnHeadersVisible = $true
    $dgv_ADUserSession.AutoSizeColumnsMode = "AllCells"
    $dgv_ADUserSession.DataSource = $ADUserSession

    # Voeg de verschillende controls toe aan de tab-pagina
    $TabPage_ADUser.controls.AddRange(@($lbl_ADUser, 
                                        $txt_ADUser, 
                                        $btn_ADUser,
                                        $dgv_ADUser,
                                        $dgv_ADUserSession,
                                        $contextMenuStrip_Main
                                     ))
   
    ####################################################################
    
    # Maak Tabpagina for Active Directory Computers
    $TabPage_ADComputer = New-Object System.Windows.Forms.TabPage
    $TabPage_ADComputer.Text = "Computer info"

    # Maak controls voor de Tabpagina
    # ADComputer Label
    $lbl_ADComputer = New-Object System.Windows.Forms.Label
    $lbl_ADComputer.Location = New-Object System.Drawing.Point(10,10)
    $lbl_ADComputer.Text = "Computernaam"
        
    # ADComputer Textbox voor de op te zoeken computer informatie
    $txt_ADComputer = New-Object System.Windows.Forms.TextBox
    $txt_ADComputer.Location = New-Object System.Drawing.Point(150,10)
    $txt_ADComputer.Height = 10
    $txt_ADComputer.Width = 300
    
    # Zorgt ervoor dat bij het indrukken van enter er ook gezocht wordt
    $txt_ADComputer.add_keydown({if ($_.Keycode -eq "Enter") {Get-ComputerInfo -Computername $txt_ADComputer.Text; Get-IP -Computername $txt_ADComputer.Text}})

    # ADComputer knop om de computer op te zoeken
    $btn_ADComputer = New-Object System.Windows.Forms.Button
    $btn_ADComputer.Location = New-Object System.Drawing.Point(600, 10)
    $btn_ADComputer.text = "Search"
    $btn_ADComputer.Height = 30
    $btn_ADComputer.Width = 100

    # Zoek de bijbehorende gegevens op na indrukken van de knop
    $btn_ADComputer.add_click({Get-ComputerInfo -Computername $txt_ADComputer.Text ; Get-IP -Computername $txt_ADComputer.Text})   
    
    # Label om te controleren of de computer online is
    $lbl_ADComputerOnline = New-Object System.Windows.Forms.Label
    $lbl_ADComputerOnline.Location = New-Object System.Drawing.Point(470, 10)
    $lbl_ADComputerOnline.Height = 20
    $lbl_ADComputerOnline.Width = 40
    $lbl_ADComputerOnline.BackColor = "Transparent"
    $lbl_ADComputerOnline.Text = ""
    $lbl_ADComputerOnline.TextAlign= "MiddleCenter"

    <# 
    Om de een of andere reden moet de informatie eerst worden opgezocht voordat de Datagridview wordt aangelegd. Er moet gekeken worden of hier een refresh mogelijkheid bestaat om de 
    Datagridview te verversen met nieuwe data. Als dit kan (en we weten hoe), dan maakt het niet meer uit wanneer de data wordt ingeladen
    #>

    # ADComputerDataGridView voor resultaten Get-ADComputer
    $dgv_ADComputer = New-Object System.Windows.Forms.DataGridView
    $dgv_ADComputer.Location = New-Object System.Drawing.Point(10,50)
    $dgv_ADComputer.Height = 750
    $dgv_ADComputer.Width = 450
    $dgv_ADComputer.ColumnHeadersVisible = $true
    $dgv_ADComputer.AutoSizeColumnsMode = "AllCells"
    $dgv_ADComputer.DataSource = $ADComputerList

    # Voegt een tekening toe om aan te geven dat de computer online is (groen) of niet (rood)
    $TabPageGraphics = $TabPage_ADComputer.CreateGraphics()

    # Voeg de controls toe aan de tabpagina.
    $TabPage_ADComputer.controls.AddRange(@(
                                            $lbl_ADComputer, 
                                            $txt_ADComputer, 
                                            $btn_ADComputer, 
                                            $dgv_ADComputer,
                                            $lbl_ADComputerOnline
                                         ))

    ####################################################################
    
    # Maak Tabpagina voor Active Directory Printers
    $TabPage_ADPrinter = New-Object System.Windows.Forms.TabPage
    $TabPage_ADPrinter.Text = "Printer info"

    ####################################################################

    # Create controls for TabPage
    # ADPrinter Label
    $lbl_ADPrinter = New-Object System.Windows.Forms.Label
    $lbl_ADPrinter.Location = New-Object System.Drawing.Point(10,10)
    $lbl_ADPrinter.Text = "Printernaam"

    # ADPrinter Textbox de op te zoeken printer informatie
    $txt_ADPrinter = New-Object System.Windows.Forms.TextBox
    $txt_ADPrinter.Location = New-Object System.Drawing.Point(150,10)
    $txt_ADPrinter.Height = 10
    $txt_ADPrinter.Width = 300
    
    # Zorgt ervoor dat bij het indrukken van enter er ook gezocht wordt
    $txt_ADPrinter.add_keydown({if ($_.Keycode -eq "Enter") {Get-PrinterInfo -PrinterName $txt_ADPrinter.Text;Get-IP -Computername $txt_ADPrinter.Text}})

    # ADPrinterName knop om de printer op te zoeken
    $btn_ADPrinter = New-Object System.Windows.Forms.Button
    $btn_ADPrinter.Location = New-Object System.Drawing.Point(600, 10)
    $btn_ADPrinter.text = "Search"
    $btn_ADPrinter.Height = 30
    $btn_ADPrinter.Width = 100
    
    # Zoek de bijbehorende gegevens op na indrukken van de knop
    $btn_ADPrinter.add_click({Get-PrinterInfo -PrinterName $txt_ADPrinter.Text;})   
    
    # Label om te controleren of de computer online is
    $lbl_ADPrinterOnline = New-Object System.Windows.Forms.Label
    $lbl_ADPrinterOnline.Location = New-Object System.Drawing.Point(470, 10)
    $lbl_ADPrinterOnline.Height = 20
    $lbl_ADPrinterOnline.Width = 20
    $lbl_ADPrinterOnline.BackColor = "Transparent"
    $lbl_ADPrinterOnline.Text = ""

    <# 
    Om de een of andere reden moet de informatie eerst worden opgezocht voordat de Datagridview wordt aangelegd. Er moet gekeken worden of hier een refresh mogelijkheid bestaat om de 
    Datagridview te verversen met nieuwe data. Als dit kan (en we weten hoe), dan maakt het niet meer uit wanneer de data wordt ingeladen
    #>

    # ADPrinterDataGridView voor resultaten Get-ADComputer/ADPrinter
    $dgv_ADPrinter = New-Object System.Windows.Forms.DataGridView
    $dgv_ADPrinter.Location = New-Object System.Drawing.Point(10,50)
    $dgv_ADPrinter.Height = 750
    $dgv_ADPrinter.Width = 450
    $dgv_ADPrinter.ColumnHeadersVisible = $true
    $dgv_ADPrinter.AutoSizeColumnsMode = "AllCells"
    $dgv_ADPrinter.DataSource = $ADPrinterList

    # Voeg de controls toe aan de tabpagina.
    $TabPage_ADPrinter.Controls.AddRange(@($lbl_ADPrinter, 
                                           $txt_ADPrinter,
                                           $btn_ADPrinter,
                                           $dgv_ADPrinter,
                                           $lbl_ADPrinterOnline
                                        ))

    ####################################################################
        
    # Voeg menu items toe aan Toolstrip
    $Toolstripmenuitem_File.DropDownItems.AddRange(@($ToolStripMenuItem_OpenFile
                                                  ))
    
    ####################################################################
    
    # Voeg Menu items toe aan menu
    $MenuStrip_Main.Items.AddRange(@($ToolStripMenuItem_File
                                  ))
    
    ####################################################################
    
    # Voeg de tabpagina's toe aan de tabcontrol
    $Tabcontrol.Controls.AddRange(@($TabPage_ADUser,
                                    $TabPage_ADComputer,
                                    $TabPage_ADPrinter
                                 ))
    
    ####################################################################

    # Voeg controls toe aan het formulier
    $frm_Toolkit.Controls.AddRange(@($MenuStrip_Main, 
                                     $TabControl   
                                  ))
    ####################################################################

    # Toon het formulier
    $frm_Toolkit.ShowDialog()
}

Function Get-UserInfo
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [String]$Username
    )
    
    <# 
    Dit gedeelte moet verder worden uitgewerkt, en wel als volgt (als alles meezit). het liefst heb ik dit gedeelte in een apart bestand waarbij de properties op basis van de keuze in 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Setting_Files\ADUserSettings.txt worden ingeladen via 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Function_Files\Setting_Files\Get-ADUserSettings.ps1 en vervolgens getoond in de DataGridView.

    De reden dat hier een eerst een tekstbestand wordt aangelegd en deze vervolgens weer wordt ingelezen heeft te maken met dat Get-ADUser objecten oplevert en deze lijken niet direct te 
    splitsen te zijn in individuele entiteiten. Door te exporteren naar een tekst bestand en deze vervolgens te importeren is dit wel het geval. Er zal hier sowieso nog een tweede kolom bij 
    moeten komen en de waarden daarover verdeeld. Dit kan door de array $UserInfo te splitsen over twee kolommen of door hier een 2-dimensionale array van te maken. Dit moet allemaal nog 
    uitgezocht worden. Maar dit werkt in ieder geval!
    #>

    # Onderstaande is een alternatieve manier om de DataGridView te voorzien van data, maar op dit moment werkt het nog niet.
    <#$dgv_ADUser.ColumnCount = 2
    $dgv_ADUSer.ColumnHeadersVisible = $true
    $dgv_ADUser.Columns[0].Name = "Property"
    $dgv_ADUser.Columns[1].Name = "Value"
    $dgv_ADUser.Columns[0].Width = 240

    Get-ADUser $Username -Properties * | foreach
    {
        $dgv_ADUser.rows.Add($_.samAccountName)
    }#>

    $ADUser = Get-ADUser -Filter "SamAccountName -like '*$UserName*'" -Properties * | Out-File "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\UserInfo.txt"
    $UserInfo = Get-Content "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\UserInfo.txt" | ForEach-Object { New-Object PSObject -Property @{"Property" = $_}}
    $ADUserList = New-Object System.Collections.ArrayList
    $ADUserList.AddRange($UserInfo)

    # Onderstaande is bedoeld om specifieke eigenschappen een andere achtergrond kleur te geven zodra de waarde hierin aangepast is. Dit dient nog verder uitgewerkt te worden.
    <#Foreach ($Row in $dgv_ADUser.Rows)
    {
        if($Row.Cells[0].Value -eq "PasswordExpired")
        {
            $Row.DefaultCellStyle.BackColor = "Red"
        }
    }#>
   
    $dgv_ADUser.DataBindings.DefaultDataSourceUpdateMode = 0
    $dgv_ADUser.DataSource = $null
    $dgv_ADUser.DataSource = $ADUserList
    $dgv_ADuser.Refresh()
}

Function Get-ComputerInfo
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$Computername
    )

     # Controleert of de computernaam begint met PW -> standaard voor de Tweede Kamer. Zo niet, voegt PW toe aan de $Computername
    If (!$Computername.startswith("PW"))
        {
            $Computername = "PW" + $Computername
        }


    # Zoekt de informatie op van de computer
    <# 
    Dit gedeelte moet verder worden uitgewerkt, en wel als volgt (als alles meezit). het liefst heb ik dit gedeelte in een apart bestand waarbij de properties op basis van de keuze in 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Setting_Files\ADComputerSettings.txt worden ingeladen via 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Function_Files\Setting_Files\Get-ADComputerSettings.ps1 en vervolgens getoond in de DataGridView.

    De reden dat hier een eerst een tekstbestand wordt aangelegd en deze vervolgens weer wordt ingelezen heeft te maken met dat Get-ADComputer objecten oplevert en deze lijken niet direct te 
    splitsen te zijn in individuele entiteiten. Door te exporteren naar een tekst bestand en deze vervolgens te importeren is dit wel het geval. Er zal hier sowieso nog een tweede kolom bij 
    moeten komen en de waarden daarover verdeeld. Dit kan door de array $ComputerInfo te splitsen over twee kolommen of door hier een 2-dimensionale array van te maken. Dit moet allemaal nog 
    uitgezocht worden. Maar dit werkt in ieder geval!
    #>
    $ADComputer = Get-ADComputer $ComputerName -Properties * | Out-File "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\ComputerInfo.txt"
    $ComputerInfo = Get-Content  "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\ComputerInfo.txt" | ForEach-Object { New-Object PSObject -Property @{"Property" = $_}}
    $ADComputerList = New-Object System.Collections.ArrayList
    $ADComputerList.AddRange($ComputerInfo)

    $dgv_ADComputer.DataBindings.DefaultDataSourceUpdateMode = 0
    $dgv_ADComputer.DataSource = $null
    $dgv_ADComputer.DataSource = $ADComputerList
    $dgv_ADComputer.Refresh()
}

Function Get-PrinterInfo
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]$PrinterName
    )

    # Controleert of de printernaam begint met PRINT_, zo nee, zet dit ervoor. Namen in ADGroup beginnen met PRINT en dit is niet altijd duidelijk voor de gebruiker van ServiceDesk Toolkit 2.0
    If (!$PrinterName.StartsWith("PRINT_"))
        {
            $PrinterName = "PRINT_" + $PrinterName
        }

    # Zoekt de informatie op van de printer
    <# 
    Dit gedeelte moet verder worden uitgewerkt, en wel als volgt (als alles meezit). het liefst heb ik dit gedeelte in een apart bestand waarbij de properties op basis van de keuze in 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Setting_Files\ADGroupSettings.txt worden ingeladen via 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Function_Files\Setting_Files\Get-ADGroupSettings.ps1 en vervolgens getoond in de DataGridView.

    De reden dat hier een eerst een tekstbestand wordt aangelegd en deze vervolgens weer wordt ingelezen heeft te maken met dat Get-ADGroup objecten oplevert en deze lijken niet direct te 
    splitsen te zijn in individuele entiteiten. Door te exporteren naar een tekst bestand en deze vervolgens te importeren is dit wel het geval. Er zal hier sowieso nog een tweede kolom bij 
    moeten komen en de waarden daarover verdeeld. Dit kan door de array $PrintInfo te splitsen over twee kolommen of door hier een 2-dimensionale array van te maken. Dit moet allemaal nog 
    uitgezocht worden. Maar dit werkt in ieder geval!
    #>
    $ADPrinter = Get-ADGroup $PrinterName -Properties * | Out-File "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\PrinterInfo.txt"
    $PrinterInfo = Get-Content  "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\PrinterInfo.txt" | ForEach-Object { New-Object PSObject -Property @{"Property" = $_}}
    $ADPrinterList = New-Object System.Collections.ArrayList
    $ADPrinterList.AddRange($PrinterInfo)

    $dgv_ADPrinter.DataBindings.DefaultDataSourceUpdateMode = 0
    $dgv_ADPrinter.DataSource = $null
    $dgv_ADPrinter.DataSource = $ADPrinterList
    $dgv_ADPrinter.Refresh()
}

Function Get-IP
{
    [CmdletBinding()]
    Param
    (
        $Computername
    )

    $Online = Test-Connection $Computername -Count 1 -Quiet

    If($Online)
    {
        $Online
        $lbl_ADComputerOnline.BackColor = "Lime"
        $lbl_ADComputerOnline.Text = "ON"
    }
    Else
    {
        $Online
        $lbl_ADComputerOnline.BackColor = "Red"
        $lbl_ADComputerOnline.Text = "OFF"
    }

}#https://superuser.com/questions/123242/can-i-find-the-session-id-for-a-user-logged-on-to-another-machine

Function Get-UserNameSessionIDMap
{
    [CmdletBinding()]
    Param
    (
        $ADUserName
    )
    
    $ADListComputer = @()
    $ADListComputer = Get-Content C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\AllComputers.txt

    foreach($ADComputer in $ADListComputer)
    {        
        
        If(-Not $ADComputer.StartsWith("PW"))
        {
           Continue
        }

        $quserRes = quser /server:$ADComputer | select -skip 1
            
        if (!$quserRes) 
        { 
            Continue
        }
        
        $quCSV = @()
        
        $quCSVhead = "SessionID","UserName","LogonTime"
        
        foreach ($qur in $quserRes) 
        {
            $qurMap = $qur.Trim().Split(" ") | ? {$_}
            
            
            If ($qurMap[0] -eq $ADUserName)
            {
                if ($qur -notmatch " Disc   ") 
                { 
                    $quCSV += $qurMap[2] + "|" + $qurMap[0] + "|" + $qurMap[5] + " " + $qurMap[6] 
                }
                else 
                { 
                    $quCSV += $qurMap[1] + "|" + $qurMap[0] + "|" + $qurMap[4] + " " + $qurMap[5] 
                } #disconnected sessions have no SESSIONNAME, others have ica-tcp#x
            }
        }
        
        $ADComputer
        $quCSV | ConvertFrom-CSV -Delimiter "|" -Header $quCSVhead
    }  
} 
Get-UserNameSessionIDMap -ADUserName BOOY3105 -ErrorAction SilentlyContinue
#end function Get-UserNameSessionIDMap

Function Unlock-Account
{
    [CmdletBinding()]
    
    Param
    (
        $Username
    )

        Unlock-ADAccount -Identity $Username
}

Function Reset-Password
{
    $frm_ResetPassword = New-Object System.Windows.Forms.Form
    $frm_ResetPassword.Text = "Reset Password"
    $frm_ResetPassword.Height = 100
    $frm_ResetPassword.Width = 400

    $lbl_ResetPassword = New-Object System.Windows.Forms.Label

    $txt_ResetPassword = New-Object System.Windows.Forms.TextBox


}

Function DisableEnable-Account
{
    [CmdletBinding()]

    Param
    (
        $Username,
        $Enable
    )

    If($Enable -eq 1)
    {
        Enable-ADAccount -Identity $Username
    }
    Else
    {
        Disable-ADAccount -Identity $Username
    }

}

Start-ServiceDeskToolkit 