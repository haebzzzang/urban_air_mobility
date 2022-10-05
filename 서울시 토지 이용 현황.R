rm(list = ls())

library(tidyverse)
library(tmap)
tmap_mode("view")
library(sf)

## 서울시 토지 이용 현황 파일 불러오기
dir <- c("../data/NGII_LUM_11_서울")
src_file <- list.files(dir)
src_file <- src_file[substr(src_file, 8, 10) == "shp"]
data_name <- paste0("land", "_", substr(src_file, 1, 6))

for (i in 1:length(src_file)) {
  assign(data_name[i], st_read(paste(dir, "/", src_file[i], sep = "")))
}

## 서울시 토지 이용 현황 코드 파일 불러오기
a <- read_excel("../data/토지이용현황도_분류항목(코드).xls", skip = 3)
## 대분류/중분류/코드 열만 추출
land_code <- a[2:4]
## 숫자 -> 문자 형변환
land_code$코드 <- as.character(land_code$코드)
## 중분류 결측값 채우기
land_jung <- c("논", "논", "밭", "밭", "초지", "초지", "임목지", "임목지", "임목지", "임지_기타", "임지_기타", "임지_기타", "임지_기타", "주거지 및 상업지", "주거지 및 상업지", "주거지 및 상업지", "주거지 및 상업지", "교통시설", "교통시설", "교통시설", "교통시설", "공업지", "공업지", "공공시설", "공공시설", "공공시설", "공공시설", "도시 및 주거지_기타시설", "도시 및 주거지_기타시설", "도시 및 주거지_기타시설", "도시 및 주거지_기타시설", "도시 및 주거지_기타시설", "습지", "습지", "하천", "호소", "호소", "수계_기타")
land_code$중분류 <- land_jung

seoul_land <- rbind(land_376082, land_376083, land_376084, land_376121, land_376122, land_377051,
              land_377053, land_377054, land_377091, land_377092)
seoul_land <- inner_join(seoul_land, land_code, by = c("UCB" = "코드"))

## tmap 시각화
tm_shape(seoul_land) +
  tm_polygons("중분류") +
  tmap_options(check.and.fix = TRUE)

