## This is where I grab your list of users. 
Function Get-FileName($initialDirectory)
{   
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.filter = "TXT (*.txt) | *.txt"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}
$inputfile = Get-FileName ".\"
$inputdata = Get-Content $inputfile
$usrs = $inputdata

##This is my fancy way of getting your specific AD group Name, WITH VB YO!!!
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$group = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the AD Group Name", "Input AD Group Name to Verify", "SomeADGroupName")

## Setting the Comparizon Values, grabbing it from AD
$members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty Name 

##And this is just where we get the "Yay" or "Nay"
foreach($usr in $usrs) {
    If ($members -contains $user) {
        Write-Host "$usr exists in $group, Huzzah!, ... or nah."
    }
    Else {  
        Write-Host "$usr does not exist in $group, you may need to fix that, or nah."
    }
}
