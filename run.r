# Packages
suppressPackageStartupMessages(library(tidyverse))
library(ape)
suppressPackageStartupMessages(library(ggtree))
suppressPackageStartupMessages(library(treeio))
library(rstudioapi)

# SET ME
WD <- "/mnt/c/Users/Liam/Desktop/Interactome"

IN_TREE_FILE <- "Data/species.nwk"
CHARACTERS_FILE <- "Data/binary_ESF_to_LE.csv"

OUT_TREE_FILE <- "Output/test_ase.tre"
ASE_FILE <- "Output/test_ase.txt"

BURN_IN = 0.5

# Run
setwd(WD)

source("Scripts/1_prep_data.r")
source("Scripts/2_run_model.r")
source("Scripts/3_parse_output.r")