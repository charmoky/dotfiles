#!/bin/bash

max_char_cnt=200

char_cnt=$((max_char_cnt+1))

file_tmp=/tmp/conkytest

while [[ $char_cnt -gt $max_char_cnt ]]; do
    fortune > $file_tmp

    char_cnt=$(wc -m $file_tmp | cut -f 1 -d ' ')
done

cat $file_tmp
rm $file_tmp

