# Read pruned tree for annotating
# Must be read from RevBayes output to ensure node alignment,
#    even though we manually resummarize ancestral states directly
#    from the log file
tree <- read.beast(OUT_TREE_FILE)

# Read ASE output tree from raw (unsummarized) revbayes ancestral state vector
ases <- read_tsv(ASE_FILE, show_col_types=FALSE) |>
     filter(Iteration > max(Iteration)*BURN_IN) |> 
     rename_with(~ gsub("end_", "", .x, fixed=TRUE)) |>
     pivot_longer(-c(Iteration, Replicate_ID), 
                  names_to="Node", values_to="Characters") |>
     mutate(Node=as.numeric(Node)) %>%
     separate(Characters, into=as.character(1:length(strsplit(.$Characters[1], ",")[[1]])),
              sep=",") |>
     pivot_longer(-c(Iteration, Replicate_ID, Node), names_to="Character", values_to="State") |>
     mutate(Character=as.numeric(Character))

probASES <- ases |>
         group_by(Node, Character, State) |>
         tally() |>
         mutate(Total_n = sum(n)) |>
         mutate(Posterior = n / Total_n) |>
         select(Node, Character, State, Posterior) |>
         pivot_wider(id_cols=c(Node, Character), names_from=State, 
                     values_from=Posterior, values_fill=0) |>
         pivot_longer(-c(Node, Character), names_to="State", values_to="Posterior")

# WONKY BELOW HERE

# Manual node dictionary
nodeNames <- c("1" = "Monodelphis domestica",
               "2" = "Mus musculus",
               "3" = "Homo sapiens",
               "4" = "Tenrec ecaudatus",
               "5" = "Therian MRCA",
               "6" = "Shrewdinger",
               "7" = "Euarcantoglires MRCA")

nodeOrder <- c("3", "2", "7", "4", "6", "1", "5")

state1Probabilities <- probASES |>
                    filter(State == "1") |>
                    select(Node, Character, Posterior)

# ggplot(state1Probabilities) +
#      geom_tile(aes(x=Character, y=Node, fill=Posterior), colour="black") +
#      guides(fill="none") +
#      xlab("Character (L->R)") + 
#      theme(panel.grid=element_blank(),
#            axis.title.y=element_blank())


# ggtree(tree) +
# geom_nodelab(aes(label=node)) +
# geom_tiplab(aes(label=paste(label, node))) +
# xlim(0, 700)

# # plot <- gtree +
# #      geom_tiplab(aes(label=paste(gsub("_", " ", label), "[", gsub(",", "", States), "]"))) +
# #      geom_nodelab(geom="label", aes(label=paste("[", gsub(",", "", States), "]")), size=2, hjust=0.2) +
# #      xlim(-0.001, 0.025)

# # ggsave(plot, file="Figures/annotated_map_tree.png", width=8, height=10)