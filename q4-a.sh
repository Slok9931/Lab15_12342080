#!/bin/bash

awk -F, '{if ($8 == 1 && $2 == 1) print "Male with Heart Disease"; if ($8 == 0 && $2 == 1) print "Female with Heart Disease";}' heart.csv | \
sort | uniq -c > gender_vs_heart_disease.txt

echo "Data processed successfully, saved to gender_vs_heart_disease.txt."

gnuplot <<EOF
set terminal pdf
set output 'gender_vs_heart_disease_histogram.pdf'

set title "Gender vs Heart Disease"
set xlabel "Category"
set ylabel "Number of People"
set style data histogram
set style fill solid border -1
set boxwidth 1 
set xtics rotate by -45

plot "gender_vs_heart_disease.txt" using 1:xtic(2) title "With Heart Disease" linecolor rgb "blue"
EOF

rm gender_vs_heart_disease.txt
