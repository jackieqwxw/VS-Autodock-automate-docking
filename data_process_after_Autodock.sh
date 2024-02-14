#!/bin/bash

# This script used for producing the probability distribution fuction (PDF) for 
# all the compounds obtained after Autodock docking.
# Generally, choose 10,000 hits with top-ranked Autodock score.
# Here, we took 5,000 as an example. Change the $num to the current selection numbers.
#
#
#----------------------------------------
# Usage: ./data_process_after_Autodock.sh
#----------------------------------------
# AD_select.sdf is used for Glide docking
#----------------------------------------
#
#
output="AD.out"
num=5000

mkdir output outsdf
mv addock-*.out output/
cat output/addock-*.out > $output
awk '{print$1}' $output > 0	# smiles
awk '{print$2}' $output > 1	# name
awk '{print$3}' $output > 2	# AD_score
paste 2 1 0 | sort -rn > 3
awk '{print$1}' 3 > 2
awk '{print$2}' 3 > 1
awk '{print$3}' 3 > 0
paste  0 1 2 > ADscore_sort.smi
echo '# Counts ADscore' > PDF.adscore
sort -rn 2 | uniq -c >> PDF.adscore
rm 0 1 2 3

tail -n $num ADscore_sort.smi > AD_select.smi

awk '{print$2}' AD_select.smi > id
sed -i 's/^/cat outsdf\//g' id
sed -i 's/$/.sdf >> AD_select.sdf /g' id
chmod +x id
./id

rm id $output
