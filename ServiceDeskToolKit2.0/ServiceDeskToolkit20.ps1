Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Function Start-ServicDeskToolkit
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
    $dgv_ADUser.DataSource = $ADUserList

    # Voeg de verschillende controls toe aan de tab-pagina
    $TabPage_ADUser.controls.AddRange(@($lbl_ADUser, 
                                        $txt_ADUser, 
                                        $btn_ADUser,
                                        $dgv_ADUser
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
    $txt_ADComputerName = New-Object System.Windows.Forms.TextBox
    $txt_ADComputerName.Location = New-Object System.Drawing.Point(150,10)
    $txt_ADComputerName.Height = 10
    $txt_ADComputerName.Width = 300

    # Zorgt ervoor dat bij het indrukken van enter er ook gezocht wordt
    $txt_ADComputer.add_keydown({if ($_.Keycode -eq "Enter") {Get-ComputerInfo -Computername $txt_ADComputer.Text}})


    # ADComputer knop om de computer op te zoeken
    $btn_ADComputer = New-Object System.Windows.Forms.Button
    $btn_ADComputer.Location = New-Object System.Drawing.Point(600, 10)
    $btn_ADComputer.text = "Search"
    $btn_ADComputer.Height = 30
    $btn_ADComputer.Width = 100

    $btn_ADComputer.add_click({Get-ComputerInfo -Computername $txt_ADComputerName.Text})   
    
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
    $dgv_ADComputer.DataSource = $ADComputerList

    # Voeg de controls toe aan de tabpagina.
    $TabPage_ADComputer.controls.AddRange(@(
                                            $lbl_ADComputer, 
                                            $txt_ADComputerName, 
                                            $btn_ADComputer, 
                                            $dgv_ADComputer,
                                            $chk_ADComputerPing
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
    $txt_ADPrinter.add_keydown({if ($_.Keycode -eq "Enter") {Get-PrinterInfo -PrinterName $txt_ADPrinter.Text}})

    # ADPrinterName knop om de printer op te zoeken
    $btn_ADPrinter = New-Object System.Windows.Forms.Button
    $btn_ADPrinter.Location = New-Object System.Drawing.Point(600, 10)
    $btn_ADPrinter.text = "Search"
    $btn_ADPrinter.Height = 30
    $btn_ADPrinter.Width = 100

    $btn_ADPrinter.add_click({Get-PrinterInfo -PrinterName $txt_ADPrinter.Text})   
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
    $dgv_ADPrinter.DataSource = $ADPrinterList
        
    # Voeg de controls toe aan de tabpagina.
    $TabPage_ADPrinter.Controls.AddRange(@($lbl_ADPrinter, 
                                           $txt_ADPrinter
                                           $btn_ADPrinter
                                           $dgv_ADPrinter
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
    Param($Username)
    
    <# 
    Dit gedeelte moet verder worden uitgewerkt, en wel als volgt (als alles meezit). het liefst heb ik dit gedeelte in een apart bestand waarbij de properties op basis van de keuze in 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Setting_Files\ADUserSettings.txt worden ingeladen via 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Function_Files\Setting_Files\Get-ADUserSettings.ps1 en vervolgens getoond in de DataGridView.

    De reden dat hier een eerst een tekstbestand wordt aangelegd en deze vervolgens weer wordt ingelezen heeft te maken met dat Get-ADUser objecten oplevert en deze lijken niet direct te 
    splitsen te zijn in individuele entiteiten. Door te exporteren naar een tekst bestand en deze vervolgens te importeren is dit wel het geval. Er zal hier sowieso nog een tweede kolom bij 
    moeten komen en de waarden daarover verdeeld. Dit kan door de array $UserInfo te splitsen over twee kolommen of door hier een 2-dimensionale array van te maken. Dit moet allemaal nog 
    uitgezocht worden. Maar dit werkt in ieder geval!
    #>
    $ADUser = Get-ADUser $UserName  -Properties * | Out-File "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\UserInfo.txt"
    $UserInfo = Get-Content "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\UserInfo.txt" | ForEach-Object { New-Object PSObject -Property @{"Property" = $_}}
    $ADUserList = New-Object System.Collections.ArrayList
    $ADUserList.AddRange($UserInfo)
    
    $dgv_ADUser.DataBindings.DefaultDataSourceUpdateMode = 0
    $dgv_ADUser.DataSource = $null
    $dgv_ADUser.DataSource = $ADUserList
    $dgv_ADuser.Refresh()
}

Function Get-ComputerInfo
{
    [CmdletBinding()]
    Param($Computername)

     # Zoekt de informatie op van de gebruiker
    <# 
    Dit gedeelte moet verder worden uitgewerkt, en wel als volgt (als alles meezit). het liefst heb ik dit gedeelte in een apart bestand waarbij de properties op basis van de keuze in 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Setting_Files\ADComputerSettings.txt worden ingeladen via 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Function_Files\Setting_Files\Get-ADComputerSettings.ps1 en vervolgens getoond in de DataGridView.

    De reden dat hier een eerst een tekstbestand wordt aangelegd en deze vervolgens weer wordt ingelezen heeft te maken met dat Get-ADUser objecten oplevert en deze lijken niet direct te 
    splitsen te zijn in individuele entiteiten. Door te exporteren naar een tekst bestand en deze vervolgens te importeren is dit wel het geval. Er zal hier sowieso nog een tweede kolom bij 
    moeten komen en de waarden daarover verdeeld. Dit kan door de array $UserInfo te splitsen over twee kolommen of door hier een 2-dimensionale array van te maken. Dit moet allemaal nog 
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
    Param($PrinterName)

    # Zoekt de informatie op van de printer
    <# 
    Dit gedeelte moet verder worden uitgewerkt, en wel als volgt (als alles meezit). het liefst heb ik dit gedeelte in een apart bestand waarbij de properties op basis van de keuze in 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Setting_Files\ADGroupSettings.txt worden ingeladen via 
    C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolkit2.0\HelperFiles\Function_Files\Setting_Files\Get-ADGroupSettings.ps1 en vervolgens getoond in de DataGridView.

    De reden dat hier een eerst een tekstbestand wordt aangelegd en deze vervolgens weer wordt ingelezen heeft te maken met dat Get-ADUser objecten oplevert en deze lijken niet direct te 
    splitsen te zijn in individuele entiteiten. Door te exporteren naar een tekst bestand en deze vervolgens te importeren is dit wel het geval. Er zal hier sowieso nog een tweede kolom bij 
    moeten komen en de waarden daarover verdeeld. Dit kan door de array $UserInfo te splitsen over twee kolommen of door hier een 2-dimensionale array van te maken. Dit moet allemaal nog 
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

$UserName = "BOOY3105"
$ComputerName = "PW3905"
$PrinterName = "PRINT_NPX-ZW001"

If(-not ($ComputerName.Contains("PW")))
{
    $ComputerName = "PW" + $ComputerName
}
    
If(-not ($PrinterName.Contains("PRINT_")))
{
    $PrinterName = "PRINT_" + $PrinterName
}

Start-ServicDeskToolkit -UserName $UserName -ComputerName $ComputerName -PrinterName $PrinterName
