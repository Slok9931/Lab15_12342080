#!/bin/bash

echo "Age Group,Heart Disease Count,Total Count" > age_groups.txt

awk -F, 'BEGIN { OFS="," }
{
    if ($1 >= 40 && $1 < 50) { age_group = "40-50" }
    else if ($1 >= 50 && $1 < 60) { age_group = "50-60" }
    else if ($1 >= 60 && $1 < 70) { age_group = "60-70" }
    else if ($1 >= 70 && $1 < 80) { age_group = "70-80" }
    else if ($1 >= 80 && $1 < 90) { age_group = "80-90" }
    else if ($1 >= 90 && $1 <= 100) { age_group = "90-100" }
    else { next }

    if ($8 == 1) {
        heart_disease[age_group]++
    }
    total[age_group]++
} 
END {
    for (age_group in heart_disease) {
        print age_group, heart_disease[age_group], total[age_group] > "age_groups.txt"
    }
}' heart.csv

awk -F, 'BEGIN { OFS="," }
{
    heart_disease_percent = ($2 / $3) * 360
    print $1, heart_disease_percent
}' age_groups.txt > age_groups_percent.txt

echo "Data processed successfully, saved to age_groups_percent.txt."

gnuplot <<EOF
set terminal pdf
set output 'age_group_heart_disease_pie_chart.pdf'

set title "Percentage of Heart Disease in Age Groups"
datafile = "age_groups_percent.txt"
set datafile separator ","
set angles degree
start_angle = 0
do for [i=1:6] {
    plot datafile using (start_angle + (i-1)*60):(column(2)) every ::i::i with labels offset 0,1
    start_angle = start_angle + 60
}
EOF
rm age_groups.txt age_groups_percent.txt
