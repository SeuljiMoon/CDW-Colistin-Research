
# Install package
if(!require("tidyverse")) install.packages("tidyverse")
if(!require("data.table")) install.packages("data.table")
if(!require("dplyr")) install.packages("dplyr")
if(!require("dataMaid")) install.packages("dataMaid")
if(!require("fs")) install.packages("fs")
if(!require("stringr")) install.packages("stringr")



library(tidyverse)
library(data.table)
library(dplyr)
library(dataMaid)
library(fs)
library(stringr)

# Read raw dataset
dir <- ("C:\\Users\\cmc\\Documents\\PIPET\\2. 연구\\9. CDW-Colistin\\Raw")
file_list <- list.files(dir)[-14]
file_list <- file_list[c(1,6,7,8,9,10,11,12,13,2,3,4,5)]
file_cnt <- length(file_list)


for (i in 1:file_cnt) {
  assign(paste0("colistin_", i),
         read_csv(paste0(dir, "\\", file_list[i]),locale = locale("ko", encoding = "euc-kr")))
  print(i)
}




report.title <- c("1. 기초임상정보", "2. 수진정보", "3. 진단검사(Lab)", "4. 진단정보", "5. 코호트",
                  "6. 투약정보", "7. 혈액투석-간호기록", "8. 혈액투석-기록", "9. 혈액투석-도관관리", "10. 혈액투석-동정맥루관리",
                  "11.혈액투석-시술중재관리", "12. 혈액투석-예약환자 리스트", "13. 혈액투석-특이사항")

for (ii in 1:file_cnt) {
  a <- get(paste0("colistin_", ii))
  b <- as.data.frame(a)
  makeDataReport(b, output = "html", reportTitle = report.title[ii], file = paste0("colistin_", ii, ".Rmd"), 
                 replace = TRUE, render = FALSE)
}


rmd_names <- dir_ls(path = ".", glob = "*.Rmd")
qmd_names <- str_replace(string = rmd_names,
                         pattern = "Rmd",
                         replacement = "qmd")


file_move(path = rmd_names,
          new_path = qmd_names)



