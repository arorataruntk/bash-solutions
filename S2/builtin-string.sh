#!/bin/bash

#####################################################
# File: testdata/garbage.csv
# Bob, Jane, Naz, Sue, Max, Tom$
# Zero, Aplha, Beta, Gama, Delta, Foxtrot#
#
# File: testdata/employees.csv
# 1000,Bob,Green,Dec,1,1967
# 2000,Ron,Brash,Jan,20,1987
# 3000,James,Fairview,Jul,15,1992
#####################################################

GB_CSV="testdata/garbage.csv"
EM_CSV="testdata/employees.csv"

#set IFS=,
#set oldIFS = $IFS
# readarrray -t option to remove any newline characters from line read.
readarray -t ARR < ${GB_CSV}

ARRY_ELEM=${#ARR[@]}
echo "We have ${ARRY_ELEM} rows in ${GB_CSV}"

INC=0
for i in "${ARR[@]}"
do
    # Get the total number of spaces
    res="${i//[^ ]}"
    TMP_CNT="${#res}"

    # Loop to remove the space
    while [ ${TMP_CNT} -gt 0 ]; do
        # This will remove only the first occurrence
        i=${i/, /,}
        TMP_CNT=$[$TMP_CNT-1]
    done

    # Update the array with the new values
    ARR[$INC]=$i

    # Increment the counter
    INC=$[$INC+1]
done

echo "${ARR[@]}"

# Loop to remove the last character from lines
INC=0
for i in "${ARR[@]}"
do
    # using substitution to remove the last character.
    ARR[$INC]=${i::-1}
    INC=$[$INC+1]
done

echo "${ARR[@]}"


# Loop to convert to uppercase
INC=0
for i in "${ARR[@]}"
do
    ARR[$INC]=${i^^}
    printf "%s" "${ARR[$INC]}"
    INC=$[$INC+1]
    # empty echo for newline output
    echo
done

readarray -t ARR < ${EM_CSV}

ARRY_ELEM=${#ARR[@]}
echo; echo "We have ${ARRY_ELEM} rown in ${EM_CSV}"

# Loop to insert character at beginning of each line
INC=0
for i in "${ARR[@]}"
do 
    ARR[$INC]="#${i}"
    printf "%s" "${ARR[$INC]}"
    INC=$[$INC+1]
    echo
done

echo 
echo "Let's make Bob, Robert!"

INC=0
for i in "${ARR[@]}"
do 
    ARR[$INC]=${i/Bob/Robert}
    printf "%s" "${ARR[$INC]}"
    INC=$[$INC+1]
    echo
done

echo; echo "Lets remove the column: birthday (1-31)"

INC=0
COLUMN_TO_REM=4
for i in "${ARR[@]}"
do
    TMP_CNT=0
    STR=""
    IFS=',' read -ra ELEM_ARR <<< "$i"
    for field in "${ELEM_ARR[@]}"
    do
        # Logic is to join the fields using the variable STR skipping the birthday column
        if [ $TMP_CNT -ne 0 ] && [ $TMP_CNT -ne $COLUMN_TO_REM ]; then
            STR="${STR},${field}"
        elif [ $TMP_CNT -eq 0 ]; then
            STR="${STR}${field}"
        fi
        TMP_CNT=$[$TMP_CNT+1]
    done

    ARR[$INC]=$STR
    echo "${ARR[$INC]}"
    INC=$[$INC+1]
done
