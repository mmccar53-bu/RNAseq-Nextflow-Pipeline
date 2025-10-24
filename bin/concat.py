#!/usr/bin/env python3

import argparse
import pandas as pd
import os
import sys

def main():
    parser = argparse.ArgumentParser(
        description="Concatenate VERSE exon count files into a single counts matrix."
    )
    parser.add_argument(
        "-i", "--input_dir",
        required=True,
        help="Directory containing *.exon.txt files."
    )
    parser.add_argument(
        "-o", "--output_file",
        required=True,
        help="Path to output CSV file."
    )
    args = parser.parse_args()

    # Collect exon count files
    files = [f for f in os.listdir(args.input_dir) if f.endswith(".exon.txt")]
    if not files:
        print(f"No .exon.txt files found in {args.input_dir}", file=sys.stderr)
        sys.exit(1)

    counts_list = []
    sample_names = []

    for file in files:
        file_path = os.path.join(args.input_dir, file)
        # Sample name from filename (strip extension)
        sample_name = os.path.splitext(os.path.splitext(file)[0])[0]

        # Read VERSE exon counts file
        # Typically: first column = GeneID, second column = counts
        df = pd.read_csv(file_path, sep="\t", header=None)
        df.columns = ["GeneID", sample_name]
        df.set_index("GeneID", inplace=True)

        counts_list.append(df)
        sample_names.append(sample_name)

    # Merge all dataframes on GeneID
    merged_df = pd.concat(counts_list, axis=1)
    merged_df.fillna(0, inplace=True)

    # Write final counts matrix
    merged_df.to_csv(args.output_file)
    print(f"Counts matrix written to {args.output_file}")
    print(f"   Rows (genes): {merged_df.shape[0]}")
    print(f"   Columns (samples): {merged_df.shape[1]}")

if __name__ == "__main__":
    main()
