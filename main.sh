#!/bin/bash

while read smi id  ; do
	echo "$smi" | obabel -ismi --gen3D  -O $id.pdb
	obabel -ipdb $id.pdb -p -O $id.pdb
	python2.5 ./prepare_ligand4.py -A 'hydrogens' -l $id.pdb -o $id.pdbqt
	./smina.static --config config.txt --scoring vinardo --ligand $id.pdbqt --out /dev/null --log $id.log --cpu 2
	value=$(sed -n '/---/ {N; s/.*\n//;p}' $id.log | awk '{print $2}')
	printf "%s\t%s\t%.2f\n" $smi $id $value >> `basename -s .smi $1`.out 
	obabel -ipdb $id.pdb -O $id.sdf
        sed -i 's/.pdb//g' $id.sdf 
        sed -i '/$$$$/i\>  <AutodockScore>\n'$value'\n' $id.sdf
        sed -i 's/UNNAMED/'$id'/g' $id.sdf
        #cat $id.sdf >> `basename -s .smi $1`.sdf
	rm $id.pdb $id.pdbqt $id.log
done < $1
	
