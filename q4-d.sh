#!/bin/bash

# Create a temporary file to store the age group data with heart disease count
echo "Age Group,Heart Disease Count,Total Count" > age_groups.txt

# Process the CSV to categorize age groups and count heart disease cases
awk -F, 'BEGIN { OFS="," }
{
    # Categorize age into age groups
    if ($1 >= 40 && $1 < 50) { age_group = "40-50" }
    else if ($1 >= 50 && $1 < 60) { age_group = "50-60" }
    else if ($1 >= 60 && $1 < 70) { age_group = "60-70" }
    else if ($1 >= 70 && $1 < 80) { age_group = "70-80" }
    else if ($1 >= 80 && $1 < 90) { age_group = "80-90" }
    else if ($1 >= 90 && $1 <= 100) { age_group = "90-100" }
    else { next }

    # Count the number of people with heart disease in each age group
    if ($8 == 1) {
        heart_disease[age_group]++
    }
    total[age_group]++
} 
END {
    # Output the results to the file
    for (age_group in heart_disease) {
        print age_group, heart_disease[age_group], total[age_group] > "age_groups.txt"
    }
}' heart.csv

# Process the age_groups.txt to calculate the percentage of heart disease in each group
awk -F, 'BEGIN { OFS="," }
{
    heart_disease_percent = ($2 / $3) * 100
    print $1, heart_disease_percent
}' age_groups.txt > age_groups_percent.txt

# Check if the file was created successfully
echo "Data processed successfully, saved to age_groups_percent.txt."

# Generate the pie chart using gnuplot
gnuplot <<EOF
set terminal png size 800,600
set output 'age_group_heart_disease_pie_chart.png'

# Set title
set title "Percentage of Heart Disease in Age Groups"

# Prepare data for the pie chart
# Read data from age_groups_percent.txt
datafile = "age_groups_percent.txt"
set datafile separator ","
set angles degree

# Define start angle for pie chart
start_angle = 0
# Draw the pie chart using 'set object' to create slices
do for [i=1:6] {
    plot datafile using (start_angle + (i-1)*60):(column(2)) every ::i::i with labels offset 0,1
    start_angle = start_angle + 60
}

EOF

# Clean up the temporary files
rm age_groups.txt age_groups_percent.txt

