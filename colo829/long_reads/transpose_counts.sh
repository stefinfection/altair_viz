#!/bin/bash

# Script to transpose variant count data
# Usage: ./transpose_variants.sh input_file.txt

input_file="$1"

if [ -z "$input_file" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Initialize arrays
declare -A rufus_pos_1plus rufus_pos_2plus rufus_pos_5plus rufus_pos_8plus rufus_pos_10plus
declare -A rufus_neg_1plus rufus_neg_2plus rufus_neg_5plus rufus_neg_8plus rufus_neg_10plus
declare -A rufus_homog_neg_1plus rufus_homog_neg_2plus rufus_homog_neg_5plus rufus_homog_neg_8plus rufus_homog_neg_10plus
declare -A mutect_pos_1plus mutect_pos_2plus mutect_pos_5plus mutect_pos_8plus mutect_pos_10plus
declare -A mutect_neg_1plus mutect_neg_2plus mutect_neg_5plus mutect_neg_8plus mutect_neg_10plus
declare -A mutect_homog_neg_1plus mutect_homog_neg_2plus mutect_homog_neg_5plus mutect_homog_neg_8plus mutect_homog_neg_10plus

# Parse the file
while IFS= read -r line; do
    # Skip empty lines
    [[ -z "$line" ]] && continue
    
    # Extract tool, degree, and control type
    if [[ $line =~ COUNTS\ FOR\ ([a-z]+)\ ([0-9]+)\ DEGREE: ]]; then
        tool="${BASH_REMATCH[1]}"
        degree="${BASH_REMATCH[2]}"
        continue
    fi
    
    if [[ $line =~ ^[0-9]+\ degree\ ([a-z_]+)\ with\ coverage: ]]; then
        control_type="${BASH_REMATCH[1]}"
        continue
    fi
    
    # Extract variant counts
    if [[ $line =~ Variants\ validated\ by\ at\ least\ ([0-9]+)\ reads:\ ([0-9]+) ]]; then
        min_reads="${BASH_REMATCH[1]}"
        count="${BASH_REMATCH[2]}"
        
        # Build array name
        array_name="${tool}_${control_type}_${min_reads}plus"
        
        # Store the count with degree as index
        case $array_name in
            rufus_pos_ctrl_1plus) rufus_pos_1plus[$degree]=$count ;;
            rufus_pos_ctrl_2plus) rufus_pos_2plus[$degree]=$count ;;
            rufus_pos_ctrl_5plus) rufus_pos_5plus[$degree]=$count ;;
            rufus_pos_ctrl_8plus) rufus_pos_8plus[$degree]=$count ;;
            rufus_pos_ctrl_10plus) rufus_pos_10plus[$degree]=$count ;;
            rufus_neg_ctrl_1plus) rufus_neg_1plus[$degree]=$count ;;
            rufus_neg_ctrl_2plus) rufus_neg_2plus[$degree]=$count ;;
            rufus_neg_ctrl_5plus) rufus_neg_5plus[$degree]=$count ;;
            rufus_neg_ctrl_8plus) rufus_neg_8plus[$degree]=$count ;;
            rufus_neg_ctrl_10plus) rufus_neg_10plus[$degree]=$count ;;
            rufus_homog_neg_ctrl_1plus) rufus_homog_neg_1plus[$degree]=$count ;;
            rufus_homog_neg_ctrl_2plus) rufus_homog_neg_2plus[$degree]=$count ;;
            rufus_homog_neg_ctrl_5plus) rufus_homog_neg_5plus[$degree]=$count ;;
            rufus_homog_neg_ctrl_8plus) rufus_homog_neg_8plus[$degree]=$count ;;
            rufus_homog_neg_ctrl_10plus) rufus_homog_neg_10plus[$degree]=$count ;;
            mutect_pos_ctrl_1plus) mutect_pos_1plus[$degree]=$count ;;
            mutect_pos_ctrl_2plus) mutect_pos_2plus[$degree]=$count ;;
            mutect_pos_ctrl_5plus) mutect_pos_5plus[$degree]=$count ;;
            mutect_pos_ctrl_8plus) mutect_pos_8plus[$degree]=$count ;;
            mutect_pos_ctrl_10plus) mutect_pos_10plus[$degree]=$count ;;
            mutect_neg_ctrl_1plus) mutect_neg_1plus[$degree]=$count ;;
            mutect_neg_ctrl_2plus) mutect_neg_2plus[$degree]=$count ;;
            mutect_neg_ctrl_5plus) mutect_neg_5plus[$degree]=$count ;;
            mutect_neg_ctrl_8plus) mutect_neg_8plus[$degree]=$count ;;
            mutect_neg_ctrl_10plus) mutect_neg_10plus[$degree]=$count ;;
            mutect_homog_neg_ctrl_1plus) mutect_homog_neg_1plus[$degree]=$count ;;
            mutect_homog_neg_ctrl_2plus) mutect_homog_neg_2plus[$degree]=$count ;;
            mutect_homog_neg_ctrl_5plus) mutect_homog_neg_5plus[$degree]=$count ;;
            mutect_homog_neg_ctrl_8plus) mutect_homog_neg_8plus[$degree]=$count ;;
            mutect_homog_neg_ctrl_10plus) mutect_homog_neg_10plus[$degree]=$count ;;
        esac
    fi
done < "$input_file"

# Function to print array in the desired format
print_array() {
    local -n arr=$1
    local name=$2
    local values=""
    
    # Build values string for degrees 1-5
    for degree in 1 2 3 4 5; do
        if [[ -n "${arr[$degree]}" ]]; then
            if [[ -z "$values" ]]; then
                values="${arr[$degree]}"
            else
                values="$values, ${arr[$degree]}"
            fi
        fi
    done
    
    echo "${name}=[$values]"
}

# Print all arrays
print_array rufus_pos_1plus "rufus_pos_1plus"
print_array rufus_neg_1plus "rufus_neg_1plus"
print_array rufus_homog_neg_1plus "rufus_homog_neg_1plus"
print_array rufus_pos_2plus "rufus_pos_2plus"
print_array rufus_neg_2plus "rufus_neg_2plus"
print_array rufus_homog_neg_2plus "rufus_homog_neg_2plus"
print_array rufus_pos_5plus "rufus_pos_5plus"
print_array rufus_neg_5plus "rufus_neg_5plus"
print_array rufus_homog_neg_5plus "rufus_homog_neg_5plus"
print_array rufus_pos_8plus "rufus_pos_8plus"
print_array rufus_neg_8plus "rufus_neg_8plus"
print_array rufus_homog_neg_8plus "rufus_homog_neg_8plus"
print_array rufus_pos_10plus "rufus_pos_10plus"
print_array rufus_neg_10plus "rufus_neg_10plus"
print_array rufus_homog_neg_10plus "rufus_homog_neg_10plus"
print_array mutect_pos_1plus "mutect_pos_1plus"
print_array mutect_neg_1plus "mutect_neg_1plus"
print_array mutect_homog_neg_1plus "mutect_homog_neg_1plus"
print_array mutect_pos_2plus "mutect_pos_2plus"
print_array mutect_neg_2plus "mutect_neg_2plus"
print_array mutect_homog_neg_2plus "mutect_homog_neg_2plus"
print_array mutect_pos_5plus "mutect_pos_5plus"
print_array mutect_neg_5plus "mutect_neg_5plus"
print_array mutect_homog_neg_5plus "mutect_homog_neg_5plus"
print_array mutect_pos_8plus "mutect_pos_8plus"
print_array mutect_neg_8plus "mutect_neg_8plus"
print_array mutect_homog_neg_8plus "mutect_homog_neg_8plus"
print_array mutect_pos_10plus "mutect_pos_10plus"
print_array mutect_neg_10plus "mutect_neg_10plus"
print_array mutect_homog_neg_10plus "mutect_homog_neg_10plus"
