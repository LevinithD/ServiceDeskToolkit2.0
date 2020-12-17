[void] [System.Reflection.Assembly]::LoadWithPartialName(“System.Windows.Forms”)
[void] [System.Reflection.Assembly]::LoadWithPartialName(“System.Drawing”)
$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(1040,518)
$form.KeyPreview = $true
$form.StartPosition = 'centerscreen'
$form.BackColor = 'MidnightBlue'
$form.Add_KeyDown({if($_.KeyCode -eq "Escape"){$form.Close()}})
$form.Text = "VIOC Toolkit 5.4" 
$form.Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell_ise.exe")
$form.MinimumSize = New-Object System.Drawing.Size(1040,525)

[System.Windows.Forms.DataGridView] $DataGrid1 = New-Object System.Windows.Forms.DataGridView
$DataGrid1.Location = New-Object System.Drawing.Size(298,29)
$DataGrid1.Dock = "Fill"
$DataGrid1.BorderStyle = 'FixedSingle'    
#$DataGrid1.DefaultCellStyle.Font = New-Object System.Drawing.Font $dgfont,$dgfontSize
$DataGrid1.AlternatingRowsDefaultCellStyle.BackColor = 'LightGray'
$DataGrid1.AllowUserToAddRows = $false
$DataGrid1.RowHeadersVisible = $false
$DataGrid1.BackgroundColor = "White"
$DataGrid1.Name="DataGrid1"
$DataGrid1.Text="DataGrid1"
$DataGrid1.ColumnCount = 3
$DataGrid1.Columns[0].Name = 'one'
$DataGrid1.Columns[1].Name = 'two'
$DataGrid1.Columns[2].Name = 'three'
$DataGrid1.Rows.add(@('a', 'b', 'c'))
$DataGrid1.Rows.add(@('d', 'e', 'f'))

#Creation of content click event
$ClickElementMenu=
{
    [System.Windows.Forms.ToolStripItem]$sender = $args[0]
    [System.EventArgs]$e= $args[1]

    $Contentcell=$DataGrid1.Rows[$DataGrid1.CurrentCell.RowIndex].Cells[$DataGrid1.CurrentCell.ColumnIndex].Value
    $ElementMenuClicked=$sender.Text
    $RowIndex=$DataGrid1.CurrentCell.RowIndex
    $ColIndex=$DataGrid1.CurrentCell.ColumnIndex


    $result="Click on element menu : '{0}' , in rowindex : {1} , column : {2}, content cell : {3}" -f $ElementMenuClicked,  $RowIndex, $ColIndex, $Contentcell;
    Write-Host $result
}

#creation menu
$contextMenuStrip1=New-Object System.Windows.Forms.ContextMenuStrip

#creation element1 of menu
[System.Windows.Forms.ToolStripItem]$toolStripItem1 = New-Object System.Windows.Forms.ToolStripMenuItem
$toolStripItem1.Text = "Element 1";
$toolStripItem1.add_Click($ClickElementMenu)
$contextMenuStrip1.Items.Add($toolStripItem1);

#creation element2 of menu
[System.Windows.Forms.ToolStripItem]$toolStripItem2 = New-Object System.Windows.Forms.ToolStripMenuItem
$toolStripItem2.Text = "Element 2";
$toolStripItem2.add_Click($ClickElementMenu)
$contextMenuStrip1.Items.Add($toolStripItem2);

#creation event of mouse down on datagrid and show menu when click
$DataGrid1.add_MouseDown({
    $sender = $args[0]
    [System.Windows.Forms.MouseEventArgs]$e= $args[1]

    if ($e.Button -eq  [System.Windows.Forms.MouseButtons]::Right)
    {
        [System.Windows.Forms.DataGridView+HitTestInfo] $hit = $DataGrid1.HitTest($e.X, $e.Y);
        if ($hit.Type -eq [System.Windows.Forms.DataGridViewHitTestType]::Cell)
        {
            $DataGrid1.CurrentCell = $DataGrid1[$hit.ColumnIndex, $hit.RowIndex];
            $contextMenuStrip1.Show($DataGrid1, $e.X, $e.Y);
        }

    }
})




#***************************************************************#
$form.Controls.Add($DataGrid1)
$form.ShowDialog() | out-null
