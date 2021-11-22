<#
 .Synopsis
  Creates Prototype Decks for Tabletop Simulator via a CSV File

 .Description
  Creates a 

 .Parameter Start
  The first month to display.

 .Parameter End
  The last month to display.

 .Parameter FirstDayOfWeek
  The day of the month on which the week begins.

 .Parameter HighlightDay
  Specific days (numbered) to highlight. Used for date ranges like (25..31).
  Date ranges are specified by the Windows PowerShell range syntax. These dates are
  enclosed in square brackets.

 .Parameter HighlightDate
  Specific days (named) to highlight. These dates are surrounded by asterisks.

 .Example
   # Show a default display of this month.
   Show-Calendar

 .Example
   # Display a date range.
   Show-Calendar -Start "March, 2010" -End "May, 2010"

 .Example
   # Highlight a range of days.
   Show-Calendar -HighlightDay (1..10 + 22) -HighlightDate "December 25, 2008"
#>
function New-Deck {
    [CmdletBinding()]
    Param(
    )
    DynamicParam{
        $ParamAttrib = New-Object System.Management.Automation.ParameterAttribute
        $ParamAttrib.Position = 0
        $AttribColl = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $AttribColl.Add($ParamAttrib)
        $AttribColl.Add((New-Object System.Management.Automation.ValidateSetAttribute(Get-ChildItem "$PSScriptRoot\input").BaseName))
        $RuntimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Deck', [string], $AttribColl)
        $RuntimeParamDic = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $RuntimeParamDic.Add('Deck', $RuntimeParam)
        return $RuntimeParamDic
    }
    process{
        . "$PSScriptRoot\main.ps1" $PSBoundParameters.Deck
    }
}