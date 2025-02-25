#!/bin/bash

report_dir=reports
result_csv="$report_dir/baseline_model_results.csv"
report_md="$report_dir/baseline_model_report.md"
branch_name=compare-result

if [ ! -f "$result_csv" ]; then
    echo  Error: $result_csv not found!
    exit 1
fi


best_model=$(awk -F, 'NR==1{next} {if($3 > max) {max=$3; line=$0}} END{print line}' "$result_csv")


data_version=$(echo "$best_model" | awk -F, '{print $1}')
model_name=$(echo "$best_model" | awk -F, '{print $2}' | tr -d '[:space:]')
f1_score=$(echo "$best_model" | awk -F, '{print $3}')
accuracy=$(echo "$best_model" | awk -F, '{print $4}')


confusion_matrix_file="$report_dir/confusion_matrix_${data_version}_${model_name}.png"


cat <<EOF > "$report_md"
### Best Baseline Model Report

**Data Version:** $data_version
**Model Name:** $model_name
**F1 Score:** $f1_score
**Accuracy:** $accuracy

![Confusion Matrix]($confusion_matrix_file)
EOF

# Output result
echo  Report generated at $report_md

