library(tercen)
library(dplyr)
library(readr)
library(stringr)

ctx <- tercenCtx()

folder <- ctx$cselect()[[1]][[1]]

parts =  unlist(strsplit(folder, '/'))
volume = parts[[1]]
input_folder <- paste(parts[-1], collapse="/")

# Define input and output paths
input_path <- paste0("/var/lib/tercen/share/", volume, "/", input_folder)

if( dir.exists(input_path) == FALSE) {
  stop(paste("ERROR:", input_folder, "folder does not exist in project volume ", volume ))
}

if (length(dir(input_path)) == 0) {
  stop(paste("ERROR:", input_folder, "folder is empty  in project volume ", volume))
}

# run the TraCeR summarise command

cmd = '/tracer/tracer'

args <- paste('summarise',
              '--ncores', parallel::detectCores(),
              '--config_file /tercen_tracer.conf',
              '-s Hsap',
              input_path,
              sep = ' ')

exitCode = system2(cmd, args)

if (exitCode != 0) {
  stop("tracer summarise failed")
}
# run the collect script

cmd <- paste0("python /collect_TRA_TRB_in_fasta.py ", input_path, "/*/filtered_TCR_seqs/*.fa > ", input_path, "/summarise_output.tsv")

exitCode = system(cmd)

if (exitCode != 0) {
  stop("collect_TRA_TRB_in_fasta failed")
}

collected_summary <- read_tsv(paste0(input_path, "/summarise_output.tsv"))

recombinants <- read_tsv(paste0(input_path, "/filtered_TCRAB_summary/recombinants.txt"))

collected_summary <- left_join(collected_summary,
                               recombinants,
                               by = c(sample = "cell_name"))

cols <- sapply(collected_summary, is.logical)
collected_summary[,cols] <- lapply(collected_summary[,cols], as.numeric)


(collected_summary %>%
    mutate(.ci = 0) %>%
    ctx$addNamespace() %>%
    ctx$save())
