#!/bin/bash
#!/bin/sh
# time: 9/1/2017
# author: zhihui.luo@ingenic.com
#
#
####################################################

bit_width=32
fl=23
approximate_type=('SIGMOID PLAN SONF INTERPOLATION AREAS PLAN_LUT LUT_BIT_LEVEL_004 LUT_BIT_LEVEL_001 DCT_LUT_6 DCT_LUT_6_PLUS' 'TANH PLAN AREAS PLAN_LUT LUT_BIT_LEVEL_004 LUT_BIT_LEVEL_001 DCT_LUT_6 DCT_LUT_6_PLUS' 'ORIGIN AREAS PLAN PLAN_LUT LUT_BIT_LEVEL_004 LUT_BIT_LEVEL_001 DCT_LUT_6 DCT_LUT_6_PLUS')
lstm_type=(sigmoid_diy tanh_diy sigmoid_tanh_diy)

lstm_length=${#lstm_type[@]}
lstm_index=0
app_index=0
bit_index=0

accuracy=100

function LookResult()
{
    grep "out of 647 correct, precision :" log
    BINGO=$?
    if [ $BINGO -eq 0 ]
    then
	var=$(ps -ef | grep "out of 647 correct, precision :" log)
	accuracy=${var##*:}
    else
	accuracy=NAN
    fi
    
    if [ $(echo "$accuracy == 100" | bc) -eq 1 ]
    then
	lstm_index=100
	app_index=100
	bit_index=100
	echo "ERROR: Please check your program."
    fi
}

rm -i result.txt
printf "%-20s %-25s %10s\n" LSTM_DIY_TYPE APPROXIMATE_TYPE ACCURACY >> result.txt

for row in "${approximate_type[@]}"
do
    row_value=($row)
    for app_type in "${row_value[@]}"
    do
	./run.sh ${lstm_type[$lstm_index]} $app_type 32 23
	LookResult
	printf "%-20s %-25s %10s\n" ${lstm_type[$lstm_index]} $app_type $accuracy >> result.txt
    done
    let "lstm_index++"
done