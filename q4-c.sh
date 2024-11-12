awk -F, '{if ($8 == 0) print $1, $5}' heart.csv > temp.txt
gnuplot <<EOF
set terminal pdf
set output 'age_vs_cholesterol_correlation.pdf'
set title "Correlation between Age and Cholesterol (No Heart Disease)"
set xlabel "Age"
set ylabel "Cholesterol"
set xrange [30:70]
set xtics 5
plot "temp.txt" using 2 with linespoints title "No Heart Disease"
EOF
rm temp.txt
