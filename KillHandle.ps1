<#
   Copyright 2014 Dave Hull
   Copyright 2018 Jens Willemsens
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
#>

<#
.SYNOPSIS
This script takes the output of handle.exe (Sysinternals tool) and kills the related processes.

Use following script call:
handle64.exe -u [-p <Process name>] | KillHandle.ps1 [-Kill] [PathFilter]

Filtering of the handles is based on https://github.com/davehull/Mal-Seine

.PARAMETER PathFilter
Optional - Regex to filter the file paths. If left empty, it will use a wildcard and take all paths.

.PARAMETER Kill
Optional - In case this flag is provided, the script will kill the found processes. Otherwise, it will only display.

.NOTES
  Version:        1.0
  Author:         Jens Willemsens <j.willemsens@accenture.com>
  Creation Date:  23/10/2018
  Purpose/Change: Initial script development
  
.EXAMPLE
  handle64.exe -u -p SAS | KillHandle.ps1 -Kill sasdump
  
#>

[CmdletBinding()]
Param(
[Parameter(Mandatory=$False, Position=0)] [string]$PathFilter=".*",
[Parameter(Mandatory=$False)] [switch]$Kill,
[parameter(Mandatory = $true, ValueFromPipeline = $true, Position=1)] $pipelineInput
)

process {
    $buffer += ,$_
}

end {
    function Convert {
        $Delimiter = "`t"
        $data = $Input | select -skip 0
        foreach($line in $data) {
            $line = $line.Trim()
            if ($line -match " pid: ") {
                $HandleId = $Type = $Perms = $Name = $null
                $pattern = "(?<ProcessName>^[-a-zA-Z0-9_.]+) pid: (?<PId>\d+) (?<Owner>.+$)"
                if ($line -match $pattern) {
                    $ProcessName,$ProcId,$Owner = ($matches['ProcessName'],$matches['PId'],$matches['Owner'])
                }
                } else {
                $pattern = "(?<HandleId>^[a-f0-9]+): (?<Type>\w+)"
                if ($line -match $pattern) {
                    $HandleId,$Type = ($matches['HandleId'],$matches['Type'])
                    $Perms = $Name = $null
                    switch ($Type) {
                        "File" {
                            $pattern = "(?<HandleId>^[a-f0-9]+):\s+(?<Type>\w+)\s+(?<Perms>\([-RWD]+\))\s+(?<Name>.*)"
                            if ($line -match $pattern) {
                                $Perms,$Name = ($matches['Perms'],$matches['Name'])
                            }
                        }
                        default {
                            $pattern = "(?<HandleId>^[a-f0-9]+):\s+(?<Type>\w+)\s+(?<Name>.*)"
                            if ($line -match $pattern) {
                                $Name = ($matches['Name'])
                            }
                        }
                    }
                    if ($Name -ne $null) {
                        # ($ProcessName,$ProcId,$Owner,$HandleId,$Type,$Perms,$Name) -join $Delimiter
                        #($ProcessName,$ProcId,$Owner,$Type,$Perms,$Name) -join $Delimiter
                        New-Object PSObject -Property @{
                            ProcessName = $ProcessName;
                            ProcessID = $ProcId;
                            Owner = $Owner;
                            Type = $Type;
                            Perms = $Perms;
                            Path = $Name
                        }
                    }
                }
            }
        }
    }
    
    
    $result = $buffer | Convert | Where {$_.Path -match $PathFilter -and {$_.ProcessName -ne "System"}
    
    # Output result to STDOUT (for logging)
    Write $result
    
    # Kill processes
    if($Kill) {
        foreach($proc in ($result | Select -Unique ProcessID)) {
            Stop-Process -Id $proc.ProcessID -Force
        }
    }
}