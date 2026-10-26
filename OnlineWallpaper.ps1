
# Online Wallpaper Changer

$imageUrl = "https://static.webx.pk/files/53836/Images/0-53836-2253728-141124105959276.jpg"
$wallpaperPath = "$env:USERPROFILE\Pictures\OnlineWallpaper.jpg"

# Download the image
try {
    Invoke-WebRequest -Uri $imageUrl -OutFile $wallpaperPath

    if (-not (Test-Path $wallpaperPath)) {
        throw "Image download failed."
    }

    # Set desktop wallpaper
    Add-Type @"
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(
        int action, int param, string image, int flags
    );
}
"@

    $result = [Wallpaper]::SystemParametersInfo(
        20, 0, $wallpaperPath, 3
    )

    if ($result -eq 1) {
        Write-Host "Wallpaper changed successfully!" -ForegroundColor Green
    }
    else {
        Write-Host "Wallpaper could not be applied." -ForegroundColor Red
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
