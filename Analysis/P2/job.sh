
# Instructions #

## Below is the job script can be run directly for any system with below parameters changed according to the requirement ##
# Parameter-1: Name of the atoms, here 'N11' and 'C0J'
# Parameter-2: Number of molecules, here '450'
# Parameter-3: Number of steps, here '1001'

## Please keep the 'eigen.py' in the same working folder ##

## Starting of the script ##

# Extraction of atoms of choice, here 'N11' and 'C0J'

echo '0' > input.txt
echo '0' >> input.txt
gmx trjconv -s prod_ferro.tpr -f prod_ferro.trr -o traj.pdb -pbc mol -center < input.txt
grep "N11" traj.pdb > N11.pdb
grep "C0J" traj.pdb > C0J.pdb
paste N11.pdb | awk '{n = 6; for (--n; n >= 0; n--){ printf "%s\t",$(NF-n)} print ""}' > test.txt
paste test.txt | awk '{print $1, $2, $3}' > N11.txt # file processing to get the coordinates from GROMACS generated .pdb file
paste C0J.pdb | awk '{n = 6; for (--n; n >= 0; n--){ printf "%s\t",$(NF-n)} print ""}' > test.txt
paste test.txt | awk '{print $1, $2, $3}' > C0J.txt # file processing to get the coordinates from GROMACS generated .pdb file
rm -rf test.txt N11.pdb C0J.pdb


# Calculation of the Unitvector

paste N11.txt C0J.txt | awk '{print $1-$4, $2-$5, $3-$6}' > vector.txt
paste vector.txt | awk '{print $1*$1, $2*$2, $3*$3}' > a.txt
paste a.txt | awk '{print $1+$2+$3}' > a1.txt
paste a1.txt | awk '{print sqrt($1)}' > a2.txt
paste vector.txt a2.txt | awk '{print $1/$4, $2/$4, $3/$4}' > unitvector.txt
rm -rf a*.txt vector.txt


# Calculation of univector for individual molecules

for m in {1..450..1} # 450 is the total number of molecules
do
	sed -n "$m"~450p unitvector.txt > unitvector_"$m".txt		
done


# Calculation of the 3*3 order matrix

for m in {1..450..1}
do
        paste unitvector_"$m".txt | awk '{print ($1*$1), ($1*$2), ($1*$3), ($2*$1), ($2*$2), ($2*$3), ($3*$1), ($3*$2), ($3*$3)}' > ele_"$m".txt
        paste ele_"$m".txt | awk '{print ((1.5*$1)-0.5), (1.5*$2), (1.5*$3), (1.5*$4), ((1.5*$5)-0.5), (1.5*$6), (1.5*$7), (1.5*$8), ((1.5*$9)-0.5)}' > mat_ele_"$m".txt
        rm -rf ele_"$m".txt
done

awk '{a[FNR]+=$1;b[FNR]+=$2;c[FNR]+=$3;d[FNR]+=$4;e[FNR]+=$5;f[FNR]+=$6;g[FNR]+=$7;h[FNR]+=$8;j[FNR]+=$9} END{for (i=1;i<=FNR;i++) print a[i], b[i], c[i], d[i], e[i], f[i], g[i], h[i], j[i]}' mat_ele_*.txt > total_mat_ele.txt
paste total_mat_ele.txt | awk '{print ($1)/450, ($2)/450, ($3)/450, ($4)/450, ($5)/450, ($6)/450, ($7)/450, ($8)/450, ($9)/450}' > ord_tensor.txt
rm -rf mat_ele_*.txt


# Calculation of the max and mid eigen function for 1001 steps

for m in {1..1001..1}
do
        cat ord_tensor.txt | sed -n "$m"p > t_"$m".txt
        paste t_"$m".txt | awk '{print $1, $2, $3}' > a_"$m".txt
        paste t_"$m".txt | awk '{print $4, $5, $6}' >> a_"$m".txt
        paste t_"$m".txt | awk '{print $7, $8, $9}' >> a_"$m".txt
        cp a_"$m".txt matrix.txt
        python3 eigen.py > o_"$m".txt
        sed -i 's/\[/\{/g' o_"$m".txt
        sed -i 's/\]/\}/g' o_"$m".txt
        sed 's/[{}]//g' o_"$m".txt > out_"$m".txt
        cat out_"$m".txt | sed -n 1p > a1.txt
        paste a1.txt | awk '{print $1}' > a11.txt
        paste a1.txt | awk '{print $2}' > a12.txt
        paste a1.txt | awk '{print $3}' > a13.txt
        cat out_"$m".txt | sed -n 2p > a2.txt
        cat out_"$m".txt | sed -n 3p > a3.txt
        cat out_"$m".txt | sed -n 4p > a4.txt
        paste a11.txt a2.txt | awk '{print $1, $2, $3, $4}' > eig_"$m".txt
        paste a12.txt a3.txt | awk '{print $1, $2, $3, $4}' >> eig_"$m".txt
        paste a13.txt a4.txt | awk '{print $1, $2, $3, $4}' >> eig_"$m".txt
        sort -nu -k 1 eig_"$m".txt > e_"$m".txt
        cat e_"$m".txt | sed -n 2p > c1.txt
        cat e_"$m".txt | sed -n 3p > c2.txt
        paste c1.txt | awk '{print $1}' >> mid_eigenvalue.txt
        paste c2.txt | awk '{print $1}' >> max_eigenvalue.txt
        rm -rf t_"$m".txt eig_"$m".txt e_"$m".txt c* a_"$m".txt out_"$m".txt o_"$m".txt a1.txt a11.txt a12.txt a13.txt a2.txt a3.txt a4.txt matrix.txt
done

## End of the script ##