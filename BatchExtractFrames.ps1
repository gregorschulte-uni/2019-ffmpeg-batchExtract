rv * -ea SilentlyContinue; rmo *; $error.Clear(); cls                    # Clear all variables from prior runs of the script

Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
[void]$FolderBrowser.ShowDialog()
#$FolderBrowser.SelectedPath

$inputFolder = $FolderBrowser.SelectedPath        #specify INput folder








$files = Get-ChildItem -path $inputFolder -Recurse *.mp4                 # Generate Array with all *.mp4 Files in Folder
 
$samefolder = "samefolder"                                               # Variable needed to check wheter the loop is still in the same folder

$counter = 1                                                             # initiate counter for files in folder

<# 
Loop to convert all files in choosen folder
#>
foreach ($f in $files){  

    if ($samefolder -eq $f.DirectoryName) {
        write-host "Still in the same folder:" $f.DirectoryName
        $counter = $counter + 1
        }
    else {
        write-host "New Folder, now in:" $f.DirectoryName
        $counter=1
        
        if (-not ($samefolder -eq "samefolder")){
            $images = Get-ChildItem $samefolder\images *.jpg 

            for ($i=0;$i -le $images.Count -1;$i+=250){
                Copy-Item $images[$i].FullName -Destination $samefolder\stills
                }


            if ( Test-Path $samefolder\images ) {
                rmdir $samefolder\images -Recurse
                Write-Host "Deleted Images Path"
                }
            else {
                Write-Host "Images01 path did not exist"
                } 
            }       
        }
 

    $samefolder = $f.DirectoryName

    $counterString = "{0:000}" -f $counter

    $fullname = $f.FullName
    $filename = $f.Name
    $filepath = $f.Directory

    if (-not ( Test-Path $filepath\images )){
        mkdir $filepath\images
        Write-Host "Created Images Path"
        }
    else {
        Write-Host "Images path exsists"
        }

    E:\Corsica2019\TEMP\ffmpeg-20190818-1965161-win32-static\bin\ffmpeg.exe -loglevel panic -i "$fullname" -vf scale=1920:-1 -q:v 6 "$filepath\images\$filename-$counterstring-%08d.jpg"  # -t 3 (for 3 seconds only)

    if (-not ( Test-Path $filepath\stills )) {
        mkdir $filepath\stills
        Write-Host "Created stills Path"
        }
    else{
        Write-Host "stills path exsists"
        }

}

$images = Get-ChildItem $samefolder\images *.jpg 

for ($i=0;$i -le $images.Count -1;$i+=250){
    Copy-Item $images[$i].FullName -Destination $samefolder\stills
    }


if ( Test-Path $samefolder\images ) {
    rmdir $samefolder\images -Recurse
    Write-Host "Deleted Images Path"
    }
else {
    Write-Host "Images01 path did not exist"
    } 