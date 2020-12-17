#https://lazyadmin.nl/powershell/powershell-gui-howto-get-started/

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
#---------------------------------------------------------[Form]--------------------------------------------------------
[System.Windows.Forms.Application]::EnableVisualStyles()

#Determine Form parameters
$Form                    = New-Object system.Windows.Forms.Form
$Form.ClientSize         = '480,300'
$Form.text               = "Custom Form"
$Form.BackColor          = "#ffffff"
$Form.TopMost            = $false
$Form.

#Add Icons to Form
$Icon                                = New-Object system.drawing.icon ("")
$LocalPrinterForm.Icon               = $Icon

#Add Label parameters
$Label                           = New-Object system.Windows.Forms.Label
$Label.text                      = "Custom Text Goes Here"
$Label.AutoSize                  = $true
$Label.width                     = 25
$Label.height                    = 10

#Position of label on form
$Label.location                  = New-Object System.Drawing.Point(20,20)
$Label.Font                      = 'Microsoft Sans Serif,13'

#Add Textbox
$Textbox                     = New-Object system.Windows.Forms.TextBox
$Textbox.multiline           = $false
$Textbox.width               = 314
$Textbox.height              = 20

#Position of textbox on form
$Textbox.location            = New-Object System.Drawing.Point(100,180)
$Textbox.Font                = 'Microsoft Sans Serif,10'
$Textbox.Visible             = $false

#Add Combobox to form
$Combobox                     = New-Object system.Windows.Forms.ComboBox
$Combobox.text                = "Custom Text Goes Here"
$Combobox.width               = 170
$Combobox.height              = 20

#Fill combobox 
@('Canon','Hp') | ForEach-Object {[void] $PrinterType.Items.Add($_)}
$Combobox.SelectedIndex       = 0

#Position combobox on form
$Combobox.location            = New-Object System.Drawing.Point(100,210)
$Combobox.Font                = 'Microsoft Sans Serif,10'
$Combobox.Visible             = $false


#Add Button to form
$Button                   = New-Object system.Windows.Forms.Button
$Button.BackColor         = "#ff7b00"
$Button.text              = "Custom Text Goes Here"
$Button.width             = 90
$Button.height            = 30

#Position button on form
$Button.location          = New-Object System.Drawing.Point(370,250)
$Button.Font              = 'Microsoft Sans Serif,10'
$Button.ForeColor         = "#ffffff"
$Button.Visible           = $false

#Add Picturebox to form
$Picturebox = New-Object System.Windows.Forms.PictureBox
$Picturebox.BackColor = "#ffffff"
$Picturebox.Text

$Form.controls.AddRange(@($label, $Textbox, $Combobox, $Button, $Picturebox, $Icon))
$form.ShowDialog()