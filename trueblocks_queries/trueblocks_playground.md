# team broblox

## trueblocks hackathon spec

1. historical rates (element + compound)
2. compare trueblocks to alchemy
3. eth/btc interest rate parity (do rates drive prices?)
4. python bot that spits out real-time txn's using --monitor
5. query gov contracts (governor bravo)
6. flash loans?
7. sushi vs. uniswap graphs?

## trueblocks PRs

- whatever this is: https://github.com/TrueBlocks/trueblocks-docs/issues/163
- cache for list
- rename fitler
- ETA estimator

## chifra commands

# function/event names
chifra state --call "0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5" | cut -f3

# list every appearance of given address, store only block number and txn id
chifra list 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5 --no_header | cut -f2 | sort -u -n -r > blocks.txt


# get most recent blocks
head -n 1 blocks.txt
16398877
block from half a year ago:
15084877 = 16398877 - 1314000

219000

# calculate APR and APY
output raw 
chifra state --call "0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5 | supplyRatePerBlock()(uint)" --file topblocks.txt --no_header | awk 'NR==1 {print "RAW","APR","APYattempt"}$5 ~ /^[1-9]/ { print $5" "(($5 / 10^18 * $blocks_per_day * 365))" "(((($5 / 10^18 * $blocks_per_day)+1)^1)) }' | column -t

# get all the events
chifra state --call "0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5"

days_per_year=365
export blocks_per_day=7200
blocks_per_year=$(($days_per_year * $blocks_per_day))
mantissa=$(echo '10^18' | bc)

head -n 100 blocks.txt > topblocks.txt

chifra state --call "0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5 | supplyRatePerBlock()(uint)" --file  blocks.txt --no_header | awk '$5 ~ /^[1-9]/ { print (($5 / 10^18 * $blocks_per_day * 365)) }' 1>/dev/null | > results.txt 


chifra state --call "0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5 | supplyRatePerBlock()(uint)" 16399135 --no_header | awk '$5 ~ /^[1-9]/ { print (($5 / 10^18 * 7200 * 365)) }'


# get last month block rates on compound

last_month_block=$(chifra when 2022-12-13 --no_header | cut -f1)

chifra list 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5 --no_header --first_block $last_month_block | cut -f2 | sort -u -n -r > last_month_blocks.txt

chifra state --call "0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5 | supplyRatePerBlock()(uint)" --file last_month_blocks.txt --no_header | awk '$5 ~ /^[1-9]/ { print $1","(($5 / 10^18 * 7200 * 365 * 100)) }' > month_results.txt

< month_results.txt jp -input csv -xy '[*][0,1]'

## chifra benchmarks
chifra state is slow: 1000 lines every 2 seconds
to speed it up, run export --cache first
then it's X faster
even faster 
what's a faster way? find an event that exposes the data we want