$files = Get-ChildItem  "E:\Corsica2019\TEMP\set04_2019.06.13_cohort07" -Recurse *.mp4

foreach ($f in $files){

Write-Host $f.Name

}

