# Load the required datasets

BS2_hom_het <- read.table("C:/Users/peron/Documents/TFM/VaRpp/databases/BS2_hom_het.hg19", quote="\"", comment.char="", fileEncoding ="latin1", header = FALSE)
gwas.clean <- read.csv("C:/Users/peron/Documents/TFM/VaRpp/databases/gwas.clean.csv", sep="", stringsAsFactors = F, encoding="UTF-8")
PM1_domains_with_benigns.hg19 <- read.delim("C:/Users/peron/Documents/TFM/VaRpp/databases/PM1_domains_with_benigns.hg19.txt", stringsAsFactors = F, encoding="UTF-8")
rmsk <- read.csv("C:/Users/peron/Documents/TFM/VaRpp/databases/rmsk.csv", stringsAsFactors = FALSE, encoding="UTF-8")
PP2_BP1_TAPES <- read.csv("C:/Users/peron/Documents/TFM/VaRpp/databases/PP2_BP1_TAPES.csv", stringsAsFactors = FALSE, encoding="UTF-8")
genes_GnomAD <- read.delim("C:/Users/peron/Documents/TFM/VaRpp/databases/gnomad.v2.1.1.lof_metrics.by_gene.txt", encoding="UTF-8")
PVS1.lof <- read.csv("C:/Users/peron/Documents/TFM/VaRpp/databases/PVS1.lof.csv", encoding="UTF-8")
# Archivo con variantes para comprobar el script
validation <- read.csv("C:/Users/peron/Documents/TFM/VaRpp/databases/validation.csv", encoding="UTF-8", sep=";")
ensembl = useEnsembl(biomart='ensembl', 
                     dataset="hsapiens_gene_ensembl",GRCh=37) 
cadd.pvs<-c("CANONICAL_SPLICE","STOP_GAINED","STOP_LOST")
review<-c("practice guideline",
          "reviewed by expert panel",
          "criteria provided, multiple submitters, no conflicts",
          "criteria provided, conflicting interpretations",
          "criteria provided, single submitter",
          "no assertion for the individual variant",
          "no assertion criteria provided",
          "no assertion provided")
