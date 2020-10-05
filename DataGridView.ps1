Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Maak het formulier
$frm_Toolkit = New-Object System.Windows.Forms.Form
$frm_Toolkit.Text = "ServiceDesk Toolkit 2.0"
$frm_Toolkit.Height = 920
$frm_Toolkit.Width = 900

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

# Maak een Tabcontrol voor de verschillende tabpagina's

$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Location = New-Object System.Drawing.Point(0,25)
$TabControl.Height = 900
$TabControl.Width = 900

# Maak de tabpagina voor Gebruikers

$TabPage_ADUser = New-Object System.Windows.Forms.TabPage
$TabPage_ADUser.Text = "User info"

<#
$ADProcess = Get-Process
$List = New-Object System.Collections.ArrayList
$List.AddRange($ADProcess)
#>

$ADUser = Get-ADUser BOOY3105 -Properties * | Out-File "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Setting_Files\UserInfo.txt"
$UserInfo = Get-Content "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Setting_Files\UserInfo.txt" | ForEach-Object { New-Object PSObject -Property @{"Property" = $_}}
$List = New-Object System.Collections.ArrayList
$List.AddRange($UserInfo)

<#
$ADComputer = Get-ADComputer PW3642 -Properties * | Out-File "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Setting_Files\ComputerInfo.txt"
$ComputerInfo = Get-Content  "C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Setting_Files\ComputerInfo.txt" | ForEach-Object { New-Object PSObject -Property @{"Property" = $_}}
$List = New-Object System.Collections.ArrayList
$List.AddRange($ComputerInfo)
#>

# ADUserDataGridView voor resultaten Get-AD-User
$dgv_ADComputer = New-Object System.Windows.Forms.DataGridView
$dgv_ADComputer.Location = New-Object System.Drawing.Point(10,50)
$dgv_ADComputer.Height = 750
$dgv_ADComputer.Width = 450
$dgv_ADComputer.ColumnHeadersVisible = $true
$dgv_ADComputer.DataSource = $List


$frm_Toolkit.Controls.AddRange(@($dgv_ADComputer))

$frm_Toolkit.ShowDialog()
