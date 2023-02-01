#!/bin/zsh
last_month_block=$(chifra when 2022-12-13 --no_header | cut -f1)

chifra list 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5 --no_header --first_block $last_month_block | cut -f2 | sort -u -n -r >last_month_blocks.txt

chifra state --call "0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5 | supplyRatePerBlock()(uint)" --file last_month_blocks.txt --no_header | awk '$5 ~ /^[1-9]/ { print $1","(($5 / 10^18 * 7200 * 365 * 100)) }' >month_results.txt

jp <month_results.txt -input csv -xy '[*][0,1]'
