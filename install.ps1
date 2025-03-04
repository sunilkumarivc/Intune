# Define the folder path
$folderPath = "C:\ProgramData\CameraDriver\"
$filePath = Join-Path -Path $folderPath -ChildPath "installstatus.txt"


function Scan-ForHardwareChange {
    param (
        [string]$driverName = "Intel(R) AVStream Camera",
        [int]$maxAttempts = 10,
        [int]$scanDelay = 5
    )


    Write-Host "Scanning for driver: $driverName"
    
    for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
        Write-Host "Scan attempt $attempt of $maxAttempts..."
        
        pnputil /scan-devices | Out-Null
        Start-Sleep -Seconds $scanDelay

        $driverDetected = Get-PnpDevice | Where-Object { $_.FriendlyName -like "*$driverName*" }

        if ($driverDetected) {
            Write-Host "Driver detected: $driverName"
            return

            
        } else {
            Write-Host "Driver not detected. Retrying..."
        }
    }

   
}

# Install driver

Start-Process -FilePath ".\driverApp.exe" -ArgumentList "/s" -PassThru -Wait

if (!(Test-Path -Path $folderPath)) {
        New-Item -Path $folderPath -ItemType Directory -Force -ErrorAction Stop
        Write-Output "Folder created successfully: $folderPath"
         New-Item -Path $filePath -ItemType File -Force -ErrorAction Stop
    }
    else {
    Write-Output "Folder already exists: $folderPath"
    }


Scan-ForHardwareChange


