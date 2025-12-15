#!/usr/bin/env nu

def main [input: int] {
    if $input < 0 or $input > 100 {
        print "Input must be between 0 and 100"
        exit 1
    }

    let serial_numbers = (
        ddcutil detect --brief
        | lines
        | where ($it | str contains "Monitor:")
        | each {|e| $e | split row ":" | last | str trim}
    )
    
    $serial_numbers | par-each {|e| ddcutil --sn $e setvcp 10 $input}
    
    print $"DDC input set to ($input) for both monitors."
}