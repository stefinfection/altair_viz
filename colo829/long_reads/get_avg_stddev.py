import pandas as pd
import numpy as np

# Load per-sample depth TSV
# /scratch/ucgd/lustre-labs/marth/scratch/u0746015/COLO829/intersections/rufus_exclusive_long_read_isecs/five_way/per_sample_depth.tsv

# Add headers
num_samples = 16
sample_columns = [f"Sample{i+1}_DP" for i in range(num_samples)]

# Read data without a header and assign column names
column_names = ['CHROM', 'POS'] + sample_columns
depth_df = pd.read_csv('/Users/genetics/Documents/code/altair/colo829/long_reads/5way_5perc_sample_depth.tsv', sep='\t', header=None, names=column_names)

# Create a unique variant ID (could also combine CHROM_POS)
depth_df['variant_id'] = depth_df['CHROM'].astype(str) + ':' + depth_df['POS'].astype(str)

# Extract sample DP columns (assuming they start at 3rd column)
dp_columns = depth_df.columns[2:-1]  # or simply 2: if variant_id is not yet present
if 'variant_id' in depth_df.columns:
    dp_columns = depth_df.columns[2:-1]  # CHROM, POS, ..., variant_id
else:
    dp_columns = depth_df.columns[2:]

# Compute summary metrics
depth_df['avg_coverage'] = depth_df[dp_columns].mean(axis=1)
depth_df['stddev_coverage'] = depth_df[dp_columns].std(axis=1)
depth_df['num_samples_found'] = (depth_df[dp_columns] > 0).sum(axis=1)

# Select output columns
summary_df = depth_df[['variant_id', 'avg_coverage', 'stddev_coverage', 'num_samples_found']]

# Save to TSV
summary_df.to_csv('variants_summary.tsv', sep='\t', index=False)

print("Summary saved to 'variants_summary.tsv'")
