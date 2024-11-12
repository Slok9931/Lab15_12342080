set terminal pdf
set output 'age_vs_blood_pressure.pdf'

set title "Age vs Blood Pressure"
set xlabel "Age"
set ylabel "Blood Pressure (trestbps)"
set datafile separator ","

plot "heart.csv" using 1:4 with points title "Age vs Blood Pressure"
