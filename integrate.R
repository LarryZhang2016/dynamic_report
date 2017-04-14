# do the data analysis
source("./R/data_analysis.R")

## compile Rnw file to produce PDF file (final output)
library(knitr)

project_dir <- getwd()
setwd("Knitr")
knit2pdf("Report.Rnw", quiet = TRUE, clean = TRUE)
setwd(project_dir)

# copy to Output folder
file.copy(from = "./Knitr/Report.pdf", 
          to = "./Output/Report.pdf", overwrite = TRUE)


