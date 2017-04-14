# load packages
library(dplyr)
library(readxl) # for reading xlsx file to R
library(ggplot2)
library(xtable)


# read data into R do little bit tidy up
monthly_sale <- read_excel(path="./Data/Ford_US_2015_monthly_vehicle_sales.xlsx", 
                          sheet = 1, col_names = FALSE, col_types = NULL, 
                          na = "", skip = 2) %>% 
               rename(month = X0, sale = X1) %>% 
               na.omit()   # remove the rows with NA's
               

# -----------------------------------------------------
# create a plot and save as PDF file
the_months_in_order <- month.abb # month.abb is an R "constant"

p1 <- ggplot(monthly_sale, aes(x = month, y=sale)) +
      geom_point(col="red") +
      geom_line() +
      scale_x_discrete(limits = the_months_in_order) + 
      scale_y_continuous(labels = scales::comma) +
      labs(x = "", title = "") +
      theme(plot.title = element_text(hjust = 0.5)) # make the title in center


pdf("./Figures/Ford_monthly_sale.pdf")
print(p1)
dev.off()      


# -----------------------------------------------------
# create a table and save it into a latex file
the_table <- 
  monthly_sale %>% 
  mutate(quarter_no = ceiling(month/3)) %>% 
  group_by(quarter_no) %>% 
  summarise(total = sum(sale),  average = mean(sale)) %>% 
  rename(QuarterNumber = quarter_no)

output_table <- print(xtable(the_table, digits = 0,
                             caption = "Ford US quarterly sales in 2015",
                             label = "table1",
                             align = c("l", "c", "l", "l")), 
                      include.rownames = FALSE,
                      include.colnames = TRUE,
                      caption.placement = "top",
                      table.placement = "h",
                      scalebox = 1,
                      latex.environments = "center",
                      file = "Tables/Table1.tex")

# -----------------------------------------------------
# create summary numbers and save Rdata file
total <- monthly_sale  %>% 
         summarise(tot = sum(sale)) %>% 
         as.numeric()

average <- total/12

my_list <- list("Total" = total,
                "Average" = average)

## Create folder "R/cache" if it does not exist
if (!file.exists("R/cache")){
  dir.create("R/cache")
}
save(my_list, file = "./R/cache/list-of-numbers.RData")

 
  
