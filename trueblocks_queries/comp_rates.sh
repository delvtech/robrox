#!/bin/zsh
function get_data() {
    [[ -z $3 ]] && data_dir=$(pwd) || data_dir=$3 # if no data dir is passed, use the pwd
    if [[ ! -n $data_dir/blocks$2.txt ]]; then    # check if we've started
        blocks$2.txt does not exist, starting from scratch
        chifra list $1 --no_header | cut -f2 | sort -u -n -r >blocks$2.txt # export all appearances
        chifra state --call "$1 | supplyRatePerBlock()(uint)" --file blocks$2.txt --no_header >results$2.txt
    else
        last_block=$(head -n 1 $data_dir/blocks$2.txt)
        echo "blocks$2.txt exists, appending after block number $last_block"
        first_block=$(($last_block + 1))
        chifra list $1 --no_header --first_block $first_block | cut -f2 | sort -u -n -r >$data_dir/tmpfile_blocks.txt
        cp $data_dir/blocks$2.txt $data_dir/blocks$2.txt.bak
        cat $data_dir/tmpfile_blocks.txt $data_dir/blocks$2.txt.bak >$data_dir/blocks$2.txt
        chifra state --call "$1 | supplyRatePerBlock()(uint)" --file $data_dir/tmpfile_blocks.txt --no_header | awk {'print $1","$5'} >$data_dir/tmpfile_results.txt
        cp $data_dir/results$2.txt $data_dir/results$2.txt.bak
        cat $data_dir/tmpfile_results.txt $data_dir/results$2.txt.bak >$data_dir/results$2.txt
        rm $data_dir/tmpfile_blocks.txt $data_dir/tmpfile_results.txt
        echo "finished successfully, blocks: $(wc -l $data_dir/blocks$2.txt | cut -d' ' -f1), results: $(wc -l $data_dir/results$2.txt | cut -d' ' -f1), latest block: $(head -n 1 $data_dir/blocks$2.txt)"
    fi
}
function power_glove {
    [[ -z $3 ]] && data_dir=$(pwd) || data_dir=$3 # if no data dir is passed, use the pwd
    [[ -z $2 ]] && num_lines=100 || num_lines=$2  # if no num lines is passed, use 100
    echo $1
    head -n -$num_lines $data_dir/results$1.txt >$data_dir/plot$1.txt
    jp <$data_dir/plot$1.txt --input csv -xy '[*][0,1]'
    # rm $data_dir/plot$1.txt
}

# call the function
get_data 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5 ETH /code/robrox/data
get_data 0xccF4429DB6322D5C611ee964527D42E5d685DD6a BTC /code/robrox/data

# put on power glove and display in terminal
power_glove ETH 500 /code/robrox/data
power_glove BTC 1500 /code/robrox/data
