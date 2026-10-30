# main.R
# Single entry point for this project. Run this file top to bottom (or
# source it) to reproduce the full analysis from raw data to final output.
#
# Before running this for the first time:
#   1. renv::restore()                                  (Week 3)
#   2. Place or symlink your real data at ./data/        (see README.md)
#   3. source("scripts/data/import/verify_data_hash.R")  (confirms your
#      local data matches data_manifest.csv before proceeding)


# 1. Process / clean
source("scripts/data/process/process_data.R")

# 2. Explore
source("scripts/data/explore/explore_data.R")

# 3. Analysis
source("scripts/analysis/analysis.R")


message("Pipeline complete. See scripts/analysis/output/ for results.")
