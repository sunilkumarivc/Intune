# Add required assemblies for GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to show reboot prompt with company logo and enhanced UI
function Show-RebootPrompt {
    # Define the path to the logo image
    $logoPath = ".\logo.png"  # Replace this with your actual logo file path

    # Create the main form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Quick Admin"
    $form.Size = New-Object System.Drawing.Size(1000, 800)  # Increased height
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::White
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    # Set the form to always appear on top
    $form.TopMost = $true

    # Add company logo
    if (Test-Path $logoPath) {
        $logo = New-Object System.Windows.Forms.PictureBox
        $logo.Image = [System.Drawing.Image]::FromFile($logoPath)
        $logo.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
        $logo.Width = 200  # Adjusted width
        $logo.Height = 100  # Adjusted height
        $logo.Location = New-Object System.Drawing.Point(375, 50)  # Centered horizontally
        $form.Controls.Add($logo)
    } else {
        Write-Host "Logo file not found at $logoPath. Please check the path."
    }

    # Header label
    $headerLabel = New-Object System.Windows.Forms.Label
    $headerLabel.Text = "System Reboot Required"
    $headerLabel.Font = New-Object System.Drawing.Font("Arial", 20, [System.Drawing.FontStyle]::Bold)
    $headerLabel.ForeColor = [System.Drawing.Color]::DarkBlue
    $headerLabel.AutoSize = $true
    $headerLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $headerLabel.Location = New-Object System.Drawing.Point(300, 200)
    $form.Controls.Add($headerLabel)

    # Reboot message
    $messageLabel = New-Object System.Windows.Forms.Label
    $messageLabel.Text = "The software drivers for the camera subsystem have been successfully updated. To ensure the proper application of the update and to restore optimal camera functionality, a system restart is required. Kindly initiate the restart of your device at your earliest convenience"
    $messageLabel.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Regular)
    $messageLabel.ForeColor = [System.Drawing.Color]::Black
    $messageLabel.AutoSize = $false  # Set AutoSize to false
    $messageLabel.Size = New-Object System.Drawing.Size(800, 100)  # Adjust width and height as necessary
    $messageLabel.Location = New-Object System.Drawing.Point(150, 260)  # Adjusted position for better readability
    $messageLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter  # Align the text in the center
    $form.Controls.Add($messageLabel)

    # Yes button
    $yesButton = New-Object System.Windows.Forms.Button
    $yesButton.Text = "Yes, Reboot Now"
    $yesButton.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $yesButton.Size = New-Object System.Drawing.Size(200, 60)
    $yesButton.Location = New-Object System.Drawing.Point(300, 400)
    $yesButton.BackColor = [System.Drawing.Color]::Green
    $yesButton.ForeColor = [System.Drawing.Color]::White
    $yesButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $yesButton.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Yes
        $form.Close()
    })
    $form.Controls.Add($yesButton)

    # No button
    $noButton = New-Object System.Windows.Forms.Button
    $noButton.Text = "No, Postpone"
    $noButton.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $noButton.Size = New-Object System.Drawing.Size(200, 60)
    $noButton.Location = New-Object System.Drawing.Point(520, 400)
    $noButton.BackColor = [System.Drawing.Color]::Red
    $noButton.ForeColor = [System.Drawing.Color]::White
    $noButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $noButton.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::No
        $form.Close()
    })
    $form.Controls.Add($noButton)

    # Admin privileges info label
    $infoLabel = New-Object System.Windows.Forms.Label
    $infoLabel.Text = "Note:The Teams camera functionality will only be available after a reboot of your device"
    $infoLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Italic)
    $infoLabel.ForeColor = [System.Drawing.Color]::DarkRed
    $infoLabel.AutoSize = $false
    $infoLabel.Size = New-Object System.Drawing.Size(800, 50)  # Adjusted size
    $infoLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $infoLabel.Location = New-Object System.Drawing.Point(100, 550)  # Positioned below buttons
    $form.Controls.Add($infoLabel)

    # Show the form and return the result
    return $form.ShowDialog()
}

# Show the reboot prompt with company logo and get user response
$response = Show-RebootPrompt

if ($response -eq [System.Windows.Forms.DialogResult]::Yes) {
    Write-Host "User consented to reboot. Rebooting now..."
    Restart-Computer -Force
} else {
    Write-Host "User declined to reboot. No action will be taken."
    exit 0;
}
