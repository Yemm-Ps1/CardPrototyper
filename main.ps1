Add-Type -AssemblyName System.Drawing
if($args){
    $File = $args
}else{
    $File = "default"
}
# Output
$cardDir = "$PSScriptRoot\Cards\$File\"

If(Test-Path $cardDir){
    Remove-Item $cardDir*
}else{
    New-Item -Type Directory -Path $cardDir | Out-Null
}


# Constant Font Definitions
$descriptionFont = [System.Drawing.Font]::new("Calibri", 24, [System.Drawing.FontStyle]::Bold)

$sf = [System.Drawing.StringFormat]::new()

$sf.LineAlignment = [System.Drawing.StringAlignment]::Center

$sf.Alignment = [System.Drawing.StringAlignment]::Center

# Card list
$Cards = Import-Csv -Path "$PSScriptRoot\input\$File.csv" -Header 'Name', 'Description', 'Type'

# Logic Loop

$nameRect = [System.Drawing.RectangleF]::new(0, -20, 400, 200)
$descriptionRect = [System.Drawing.RectangleF]::new(0, 250, 400, 300)

function Select-CardBGColor {
    Param(
        $Type
    )
    switch($Type){
        "Action" { return [System.Drawing.Brushes]::Black }
        "Spell" { return [System.Drawing.Brushes]::DarkGreen }
        "Manoeuver" { return [System.Drawing.Brushes]::Crimson }
        "Withdraw" { return [System.Drawing.Brushes]::SteelBlue }
        "Modifier" { return [System.Drawing.Brushes]::Purple }
        "Evolution" { return [System.Drawing.Brushes]::Gold }
        "Definition" { return [System.Drawing.Brushes]::White }
    }   
}

function Select-CardFontColor {
    Param(
        $Type
    )
    if($type -in "Evolution", "Definition"){
        return [System.Drawing.Brushes]::Black
    } else {
        return [System.Drawing.Brushes]::White
    }
    # switch($Type){
    #     "Action" { return [System.Drawing.Brushes]::White }
    #     "Manoeuver" { return [System.Drawing.Brushes]::White }
    #     "Withdraw" {return [System.Drawing.Brushes]::White }
    #     "Modifier" { return [System.Drawing.Brushes]::White }
    #     "Evolution" { return [System.Drawing.Brushes]::Black }
    #     "Description" { return [System.Drawing.Brushes]::White}
    # }   
}


foreach($card in $cards){
    # Dynamic Data
    $cardName = $card.Name
    $cardDescription = $card.description
    $filename = "$($cardDir)01x card $cardName.jpg"
    
    # Process
    $bmp = new-object System.Drawing.Bitmap 400, 600
    $nameFont = [System.Drawing.Font]::new("Calibri", 34, [System.Drawing.FontStyle]::Bold)

    $backgroundColor = Select-CardBGColor $card.type
    $fontColor = Select-CardFontColor $card.type

    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.FillRectangle($backgroundColor,0,0,$bmp.Width,$bmp.Height)
    # Draw Card Name
    $graphics.DrawString($cardName,$nameFont,$fontColor, $nameRect, $sf) 
    # Draw Card Description
    $graphics.DrawString($cardDescription,$descriptionFont,$fontColor, $descriptionRect, $sf) 

    # Clean up
    $graphics.Dispose()
    $bmp.Save($filename)
    
    #Invoke-Item $filename
}

$totalCards = (get-childitem $carddir | Measure-Object).Count+1

$square = [math]::Ceiling([math]::Sqrt($totalCards))
$outfile = "$PSScriptRoot\output\$File.jpg"
$tile = "$square`x$square"
$geometry = "+0+0"
.\magick\montage $cardDir\*.jpg .\cards\back.jpg -tile $tile -geometry $geometry $outfile

$genText = "Generated '$args'"
$createText = "Deck created at $outfile"
$totalText = "There are $totalCards cards."
$tileText = "It is $tile."


$result = @"
$genText
$createText
$totalText
$tileText
"@

Tee-Object -InputObject $result -FilePath "$PSScriptRoot\Output\$File.txt"
