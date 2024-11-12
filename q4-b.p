set terminal pdf
set output 'age_vs_blood_pressure.pdf'

set title "Age vs Blood Pressure"
set xlabel "Age"
set ylabel "Blood Pressure (trestbps)"
set xrange [30:70]
set xtics 10
set yrange [100:150]
set ytics 5
set datafile separator ","

plot "heart.csv" using 4 with points title "Age vs Blood Pressure"
