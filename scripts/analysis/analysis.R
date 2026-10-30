# analysis.R
#
# Final statistical analysis. Writes outputs to `outdir`,
# which is reproducible from code + data and therefore excluded from Git.

library(tidyverse)

# output directory
outdir = "output/analysis"
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

# Import cleaned data
source("scripts/data/import/import_data.R")

# Do some analysis
model = lm(value ~ category, data = data_clean)
summary_table = summary(model)

# Write output to file
capture.output(summary_table, file = file.path(outdir, "model_summary.txt"))
