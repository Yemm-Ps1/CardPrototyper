<#
 .Synopsis
  Creates Prototype Decks for Tabletop Simulator via a CSV File

 .Description
  Creates a 

 .Parameter Deck
  Specify the Deck (CSV File) you want to create. 

 .Example
   # Create the default deck in the input folder
   New-Deck default

#>
function New-Deck {
    [CmdletBinding()]
    Param(
    )
    DynamicParam{
        $ParamAttrib = New-Object System.Management.Automation.ParameterAttribute
        $ParamAttrib.Position = 0
        $ParamAttrib.HelpMessage = "Test"
        $AttribColl = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $AttribColl.Add($ParamAttrib)
        $AttribColl.Add((New-Object System.Management.Automation.ValidateSetAttribute((Get-ChildItem "$PSScriptRoot\input").BaseName)))
        $RuntimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Deck', [string], $AttribColl)
        $RuntimeParamDic = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $RuntimeParamDic.Add('Deck', $RuntimeParam)
        return $RuntimeParamDic
    }
    process{
        . "$PSScriptRoot\main.ps1" $PSBoundParameters.Deck
    }
}