library(data.table)
library(dplyr); library(tidyverse)

setwd("C:\\Users\\cmc\\Documents\\GitHub\\CDW-Colistin\\quarto")
### 1. 기초임상정보
coli_base <- read_csv("C:\\Users\\cmc\\Documents\\PIPET\\2. 연구\\9. CDW-Colistin\\Raw\\Colistin1_기초임상정보.csv",locale = locale("ko", encoding = "euc-kr"))
str(coli_base)

# data type
coli_base2<-data.frame(coli_base[,c(1:8)],lapply(coli_base[,-c(1:8),], factor))
str(coli_base2)

# colnames 
colnames(coli_base2) <- c("RID", "base_date", "record_date", "height", "weight", "dbp", "sbp", "record_type", "smok_yn" )
coli_base3 <- coli_base2 |>
  mutate(smok_yn = case_when(smok_yn == "비흡연" ~ 1,
                             smok_yn == "과거흡연" ~ 2,
                             smok_yn == "현재흡연" ~ 3, 
                             smok_yn == "확인불능" ~ 4)) 


### 2. 수진정보
coli_acpt <- read_csv("C:\\Users\\cmc\\Documents\\PIPET\\2. 연구\\9. CDW-Colistin\\Raw\\Colistin2_수진정보.csv",locale = locale("ko", encoding = "euc-kr"))
str(coli_class)

# data type
coli_acpt2<-data.frame(coli_acpt[,c(1:5)],lapply(coli_acpt[,-c(1:5),], factor))
str(coli_acpt2)

# colnames 
colnames(coli_acpt2) <- c("RID", "acpt_depart", "out_depart", "acpt_date", "out_date",
                          "acpt_treat_type", "recpt_type", "KBN_code", "KBN_name", "work_code", "work_name")


coli_acpt3 <- coli_acpt2 |> 
  mutate(acpt_treat_type = case_when(acpt_treat_type == "외래" ~ 1,
                                     acpt_treat_type == "입원" ~ 2, 
                                     acpt_treat_type == "응급" ~ 3, 
                                     acpt_treat_type == "DSC/CHEMO" ~ 4,
                                     acpt_treat_type == "건진" ~ 5),
         recpt_type = case_when(recpt_type == "병원초진" ~ 1, 
                                recpt_type == "재진" ~ 2, 
                                recpt_type == "과초진" ~ 3, 
                                recpt_type == "입원경유" ~ 4,
                                recpt_type == "상병초진" ~ 5, 
                                recpt_type == "응급실경유" ~ 6))



### 3. Lab 정보 
coli_lab <- read_csv("C:\\Users\\cmc\\Documents\\PIPET\\2. 연구\\9. CDW-Colistin\\Raw\\Colistin3_진단검사(Lab).csv",locale = locale("ko", encoding = "euc-kr"))
str(coli_lab)

# colnames 
colnames(coli_lab) <- c("RID", "lab_code", "lab_result", "lab_result_chr", "lab_result_num",
                          "lab_unit", "lab_date", "lab_rx_date", "sample_time")


### 4. 진단정보
coli_diag <- read_csv("C:\\Users\\cmc\\Documents\\PIPET\\2. 연구\\9. CDW-Colistin\\Raw\\Colistin4_진단정보.csv",locale = locale("ko", encoding = "euc-kr"))
str(coli_diag)

# colnames 
colnames(coli_diag) <- c("RID", "initial_dx_age", "dx_date", "initial_dx_date", "dx_depart",
                        "dx_code", "dx_name", "dx_name_k", "dx_treat_type", "initial_dx_date_nU", 
                        "initial_dx_date_s", "dx_CR", "dx_MS")

str(coli_diag)

coli_diag <- coli_diag |> mutate(dx_treat_type = case_when(dx_treat_type == "외래" ~ 1,
                                                           dx_treat_type == "입원" ~ 2, 
                                                           dx_treat_type == "응급" ~ 3, 
                                                           dx_treat_type == "DSC/CHEMO" ~ 4),
                                 dx_CR = ifelse(dx_CR == "C", 1, 2),
                                 dx_MS = ifelse(dx_MS == "M", 1, 2))



### 5. 코호트
coli_coht <- read_csv("C:\\Users\\cmc\\Documents\\PIPET\\2. 연구\\9. CDW-Colistin\\Raw\\Colistin5_코호트.csv",locale = locale("ko", encoding = "euc-kr"))
str(coli_coht)

colnames(coli_coht) <- c("RID", "birth", "sex", "death", "death_date",
                         "end_follow_date", "addr")

coli_coht <- coli_coht |> mutate(sex = ifelse(sex == "F", 0, 1),
                                 death = ifelse(death == "Y", 1, 0))

### 6. 투약정보 -> 대상군 정의에 사용
coli_drug <- read_csv("C:\\Users\\cmc\\Documents\\PIPET\\2. 연구\\9. CDW-Colistin\\Raw\\Colistin6_투약정보.csv",locale = locale("ko", encoding = "euc-kr"))
str(coli_drug)

colnames(coli_drug) <- c("RID", "drug_treat_date", "drug_treat_type", "durg_rx_date", "drug_depart",
                         "drug_rx_code", "comp_name", "rx_name", "rx_name_k", "self_yn", 
                         "drug_tcap_day", "drug_cap_unit", "drug_tquan_day", "drug_quan_unit", "drug_rs_freq",
                         "drug_rx_days", "drug_adm_date", "adm_quan_once", "adm_num_days", "adm_term")

coli_drug <- coli_drug |> mutate(drug_treat_type = case_when(drug_treat_type == "외래" ~ 1,
                                                             drug_treat_type == "입원" ~ 2, 
                                                             drug_treat_type == "응급" ~ 3, 
                                                           drug_treat_type == "DSC/CHEMO" ~ 4),
                                 self_yn = ifelse(self_yn == "Y", 1,0),
                                 drug_cap_unit = case_when(drug_cap_unit == "g" ~ 1,
                                                           drug_cap_unit == "mg" ~ 2, 
                                                           drug_cap_unit == "MIU" ~ 3, 
                                                           drug_cap_unit == "만IU" ~ 4))


table(coli_drug$drug_quan_unit)


   



### 7.혈액투석 간호기록 -> 보류
### 8.혈액투석 기록 -> 보류
### 9.혈액투석 도관관리 -> 보류
### 10.혈액투석 동정맥루관리 -> 보류
### 11.혈액투석 시술중재관리 -> 보류
### 12.혈액투석 예약환자 리스트 -> 보류 (중증도)
### 13.혈액투석 특이사항 -> 보류

