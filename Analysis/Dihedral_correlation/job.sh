
# Instructions #

## Below is the job script can be run directly for any system with below parameters changed according to the requirement ##
# Parameter-1: Number of blocks, here '18'
# Parameter-2: Number of molecules, here '450'
# Parameter-3: Number of steps, here '50001'

## Please keep the 'clarke_correlation.py' & 'okazaki_correlation.py'in the same working folder ##

## Starting of the script ##

# Separation of trajectory and calculation of Dihedral angle of each trajectory

for m in $(seq 1 450)
do
	echo "$m" | gmx angle -f ../nopbc.xtc -b 50000 -e 150000 -n dh_1.ndx -type dihedral -ov dihangle_1_1_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 100000 -e 200000 -n dh_1.ndx -type dihedral -ov dihangle_1_2_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 150000 -e 250000 -n dh_1.ndx -type dihedral -ov dihangle_1_3_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 200000 -e 300000 -n dh_1.ndx -type dihedral -ov dihangle_1_4_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 250000 -e 350000 -n dh_1.ndx -type dihedral -ov dihangle_1_5_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 300000 -e 400000 -n dh_1.ndx -type dihedral -ov dihangle_1_6_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 350000 -e 450000 -n dh_1.ndx -type dihedral -ov dihangle_1_7_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 400000 -e 500000 -n dh_1.ndx -type dihedral -ov dihangle_1_8_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 450000 -e 550000 -n dh_1.ndx -type dihedral -ov dihangle_1_9_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 500000 -e 600000 -n dh_1.ndx -type dihedral -ov dihangle_1_10_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 550000 -e 650000 -n dh_1.ndx -type dihedral -ov dihangle_1_11_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 600000 -e 700000 -n dh_1.ndx -type dihedral -ov dihangle_1_12_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 650000 -e 750000 -n dh_1.ndx -type dihedral -ov dihangle_1_13_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 700000 -e 800000 -n dh_1.ndx -type dihedral -ov dihangle_1_14_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 750000 -e 850000 -n dh_1.ndx -type dihedral -ov dihangle_1_15_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 800000 -e 900000 -n dh_1.ndx -type dihedral -ov dihangle_1_16_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 850000 -e 950000 -n dh_1.ndx -type dihedral -ov dihangle_1_17_"$m".xvg
	echo "$m" | gmx angle -f ../nopbc.xtc -b 900000 -e 1000000 -n dh_1.ndx -type dihedral -ov dihangle_1_18_"$m".xvg
done


# '.xvg' format to '.txt' format

for m in {1..450}
do
    for n in {1..18}
    do
        if [[ -f dihangle_1_"$n"_"$m".xvg ]]; then
            tail -n 50001 dihangle_1_"$n"_"$m".xvg > dihangle_1_"$n"_"$m".txt
        else
            echo "File dihangle_1_${n}_${m}.xvg does not exist."
        fi
    done
done


# Calculation of angle auto-corrleation function or Okazaki correlation

for m in {1..450}
do
    for n in {1..18}
    do
		awk '{print 0.0174533*$2}' dihangle_1_"$n"_"$m".txt > data.txt
		python3 okazaki_correlation.py
		mv autocorrelation.txt autocorr_1_"$n"_"$m".txt
    done
done
rm -rf data.txt


# Calculation of state auto/cross-corrleation function or Clarke correlation

for m in {1..450}; do
    for n in {1..18}; do
        awk '{print $2}' dihangle_1_"$n"_"$m".txt > data.txt
        python3 clarke_correlation.py

        # Process correlation_results.txt and generate f.txt in one step
        tail -n5001 correlation_results.txt | awk '
        {
            print $2 > "11_'$n'_'$m'.txt"
            print ($3 + $5) / 2 > "12_'$n'_'$m'.txt"
            print ($4 + $8) / 2 > "31_'$n'_'$m'.txt"
            print $6 > "22_'$n'_'$m'.txt"
            print ($7 + $9) / 2 > "23_'$n'_'$m'.txt"
            print $10 > "33_'$n'_'$m'.txt"
        }'

        # Clean up temporary files
        rm -rf data.txt correlation_results.txt
    done
done

## End of script ##