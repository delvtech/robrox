#!/bin/zsh

# store compound cToken addresses
eth=0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5
btc=0xccF4429DB6322D5C611ee964527D42E5d685DD6a

# export all appearances
chifra list $eth --no_header | cut -f2 | sort -u -n -r >blocksETH.txt
chifra list $btc --no_header | cut -f2 | sort -u -n -r >blocksBTC.txt

# export all rates
chifra state --call "$eth | supplyRatePerBlock()(uint)" --file blocksETH.txt --no_header | awk '$5 ~ /^[1-9]/ { print (($5 / 10^18 * 7200 * 365)) }' >resultsETH.txt
chifra state --call "$btc | supplyRatePerBlock()(uint)" --file blocksBTC.txt --no_header | awk '$5 ~ /^[1-9]/ { print (($5 / 10^18 * 7200 * 365)) }' >resultsBTC.txt

# count the number of result lines
# this is less than the number of blocks
# because chifra ignores "unripe" blocks
# more than 28 blocks behind the head
result_lines_eth=$(wc -l resultsETH.txt | cut -f1 -d ' ')
result_lines_btc=$(wc -l resultsBTC.txt | cut -f1 -d ' ')

# concatenate the results
tail -n $result_lines_eth blocksETH.txt >blocksETHwithresults.txt
tail -n $result_lines_btc blocksBTC.txt >blocksBTCwithresults.txt
paste -d ',' blocksETHwithresults.txt resultsETH.txt >combinedETH.txt
paste -d ',' blocksBTCwithresults.txt resultsBTC.txt >combinedBTC.txt

# put on power glove and display in terminal
jp <combinedETH.txt --input csv -xy '[*][0,1]'
jp <combinedBTC.txt --input csv -xy '[*][0,1]'
