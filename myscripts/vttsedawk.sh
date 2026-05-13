sed '1,/^$/d' "$1"| # remove the part at the top
sed 's/<[^>]*>//g'| # remove tags
awk -F. 'NR%8==1{printf"%s ",$1}NR%8==3' > "$1.txt"  # print each new subtitle text and its start time without milliseconds
