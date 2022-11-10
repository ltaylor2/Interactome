# Clean up the characters dataset
chars_ESF_EL <- read_csv(CHARACTERS_FILE) |>
             mutate(State=as.character(as.numeric(cpm_threshold))) |>
             unite("L_R", ligand, receptor, sep="_") |>
             select(Species=species, "L_R", State) |>
             pivot_wider(id_cols=L_R, names_from=Species, 
                         values_from=State, values_fill="X") |>
             filter_all(all_vars(. != "X")) |>
             as.data.frame()

rownames(chars_ESF_EL) <- chars_ESF_EL$L_R
chars_ESF_EL <- chars_ESF_EL[, -1]

write.nexus.data(chars_ESF_EL, "Data/chars_ESF_EL.nex", 
                 datablock=FALSE, format="standard")

nex <- readLines("Data/chars_ESF_EL.nex")
targetLine <- grep("DIMENSIONS NCHAR", nex) 

charLabelLine <- paste(paste("CHARLABELS", paste(rownames(chars_ESF_EL), collapse=" ")), ";", sep="")

updatedNex <- append(nex, charLabelLine, after=targetLine)

writeLines(updatedNex, "Data/chars_ESF_EL.nex")

system("sed -i 's/symbols=\"0123456789\"/symbols=\"01\"/g' Data/chars_ESF_EL.nex")