<#
.SYNOPSIS
Dit script creeërd de Graphical User Interface (GUI) voor de ServiceDesk Toolkit 2.0 (SDT2)

.DESCRIPTION
Met dit script worden de basis blokken voor de GUI van de SDT2 opgebouwd

.PARAMETER
n.v.t

.EXAMPLE
n.v.t

.NOTES
n.v.t

.LINK
https://lazyadmin.nl/powershell/powershell-gui-howto-get-started/
https://stackoverflow.com/questions/10421003/powershell-gui-and-menustrips

#>


# Assemblies toevoegen
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# DOT source library: Hier worden andere bestanden ingeladen die nodig zijn voor de werking van de ServiceDesk Toolkit 2.0


function Create-Form
{
    
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
    $MenuStrip_Main.Size = New-Object System.Drawing.Size(0,20)
    $MenuStrip_Main.Name  = "MenuStrip_Main"
    $MenuStrip_Main.Text = "menuStrip1"
    
    ####################################################################
    
    # Maak Opties voor Menustrip
    $ToolStripMenuItem_File = New-Object System.Windows.Forms.ToolStripMenuItem
        
    # Bepaal de eigenschappen van het menu File
    $Toolstripmenuitem_File.size = New-Object System.Drawing.Size(35,20)
    $Toolstripmenuitem_File.text = "&Bestand"

    $Toolstripmenuitem_OpenFile = New-Object System.Windows.Forms.ToolStripMenuItem

    # Bepaal de eigenschappen van het menu Open
    $ToolStripMenuItem_openFile.Size = New-Object System.Drawing.Size(152,22)
    $ToolStripMenuItem_OpenFile.Text = "&Open"

    ####################################################################
        
    # Maak een Tabcontrol voor de verschillende tabpagina's

    $TabControl = New-Object System.Windows.Forms.TabControl
    $TabControl.Location = New-Object System.Drawing.Point(0,100)
    $TabControl.Height = 900
    $TabControl.Width = 900

    ####################################################################
    
    # Maak de tabpagina voor Gebruikers

    $TabPage_ADUser = New-Object System.Windows.Forms.TabPage
    $TabPage_ADUser.Text = "User info"

    #Create controls for TabPage
    #ADUser Label
        $lbl_ADUser = New-Object System.Windows.Forms.Label
        $lbl_ADUser.Location = New-Object System.Drawing.Point(10,10)
        $lbl_ADUser.Text = "Gebruikersnaam"

        #ADPrinter Textbox to hold computername to lookup
        $txt_ADUserName = New-Object System.Windows.Forms.TextBox
        $txt_ADUserName.Location = New-Object System.Drawing.Point(150,10)
        $txt_ADUserName.Height = 10
        $txt_ADUserName.Width = 300
        
    #Add controls to TabPage
    $TabPage_ADUser.controls.AddRange(@($lbl_ADUser, $txt_ADUserName))

    ####################################################################
    
    #Add controls to TabPage
    $TabPage_ADPrinter.Controls.AddRange(@($lbl_ADPrinter, $txt_ADPrinterName))
    
    #Create Tabpage for Active Directory Computers

    $TabPage_ADComputer = New-Object System.Windows.Forms.TabPage
    $TabPage_ADComputer.Text = "Computerinfo"

    #Create controls for TabPage
        #ADComputer Label
        $lbl_ADComputer = New-Object System.Windows.Forms.Label
        $lbl_ADComputer.Location = New-Object System.Drawing.Point(10,10)
        $lbl_ADComputer.Text = "Computernaam"
        

        #ADComputer Textbox to hold computername to lookup
        $txt_ADComputerName = New-Object System.Windows.Forms.TextBox
        $txt_ADComputerName.Location = New-Object System.Drawing.Point(150,10)
        $txt_ADComputerName.Height = 10
        $txt_ADComputerName.Width = 300
        

        #ADComputer button to start lookup
        $btn_ADComputer = New-Object System.Windows.Forms.Button
        $btn_ADComputer.Location = New-Object System.Drawing.Point(600, 10)
        $btn_ADComputer.text = "Search"
        $btn_ADComputer.Height = 30
        $btn_ADComputer.Width = 100
        
        $btn_ADComputer.Add_Click({Get-ComputerInfo($txt_ADComputerName.Text) ; Get-MacAddress($txt_ADComputerName.Text)})

        #ADComputer Label to hold the MAC-Address of the computer
        $lbl_ADComputerMAC = New-Object System.Windows.Forms.Label
        $lbl_ADComputerMAC.Location = New-Object System.Drawing.Point(10, 50)
        $lbl_ADComputerMAC.text = "MAC-Address : " + $PWInfo
        $lbl_ADComputerMAC.AutoSize = $true

        #ADComputerLabel to hold LastLogonDate
        $lbl_ADComputerLastLogonDate = New-Object System.Windows.Forms.Label
        $lbl_ADComputerLastLogonDate.Location = New-Object System.Drawing.Point (10, 80)
        $lbl_ADComputerLastLogonDate.Text = "Last logon date : " + $LastLogonDate
        $lbl_ADComputerLastLogonDate.AutoSize = $true
        
        #ADComputeLable to hold Fat/Terminal
        $lbl_ADComputerFatTerminal = New-Object System.Windows.Forms.Label
        $lbl_ADComputerFatTerminal.Location = New-Object System.Drawing.point (10, 110)
        $lbl_ADComputerFatTerminal.Text = "Fat or Terminal : "+ $FatOrTerminal
        $lbl_ADComputerFatTerminal.AutoSize = $true
        
        #ADComputeLable to hold Operating System
        $lbl_ADComputerOS = New-Object System.Windows.Forms.Label
        $lbl_ADComputerOS.Location = New-Object System.Drawing.point (10, 140)
        $lbl_ADComputerOS.Text = "Operating System : "+ $OperatingSystem
        $lbl_ADComputerOS.AutoSize = $true

    #Add controls to TabPage
    $TabPage_ADComputer.controls.AddRange(@($lbl_ADComputer, $txt_ADComputerName, $btn_ADComputer, $lbl_ADComputerMAC, $lbl_ADComputerLastLogonDate, $lbl_ADComputerFatTerminal, $lbl_ADComputerOS))

    ####################################################################
    #Create Tabpage for Active Directory Printers
    
    $TabPage_ADPrinter = New-Object System.Windows.Forms.TabPage
    $TabPage_ADPrinter.Text = "Printerinfo"

    #Create controls for TabPage
        #ADPrinter Label
        $lbl_ADPrinter = New-Object System.Windows.Forms.Label
        $lbl_ADPrinter.Location = New-Object System.Drawing.Point($LocationX,$LocationY)
        $lbl_ADPrinter.Text = "Printernaam"

        #ADPrinter Textbox to hold computername to lookup
        $txt_ADPrinterName = New-Object System.Windows.Forms.TextBox
        $txt_ADPrinterName.Location = New-Object System.Drawing.Point($LocationTxt,$LocationY)
        $txt_ADPrinterName.Height = 10
        $txt_ADPrinterName.Width = 300

    ####################################################################
        
    # Voeg menu items toe aan Toolstrip
    $Toolstripmenuitem_File.DropDownItems.AddRange(@($ToolStripMenuItem_OpenFile))
    
    ####################################################################
    
    # Voeg Menu items toe aan menu
    $MenuStrip_Main.Items.AddRange(@($ToolStripMenuItem_File))
    
    ####################################################################
    
    #Add tabpages to Tabcontrol
    $Tabcontrol.Controls.AddRange(@($TabPage_ADUser,$TabPage_ADComputer,$TabPage_ADPrinter))
    
    ####################################################################
    
    #Add Controls to Form
    $frm_Toolkit.Controls.AddRange(@($MenuStrip_Main, $TabControl))

    ####################################################################
    
    #Display Form
    $frm_Toolkit.ShowDialog()

}