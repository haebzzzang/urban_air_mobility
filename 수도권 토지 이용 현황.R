## 수도권 토지 이용 현황 데이터 불러오기
dir <- "../data/토지데이터"
folder <- list.files(dir)
folder <- paste0(dir, "/", folder)

src_file <- list.files(folder)
src_file <- src_file[substr(src_file, 8, 10) == "shp"]
data_name <- paste0("land", "_", substr(src_file, 1, 6))

## 디렉토리에 파일이 존재하면 불러오고, 존재하지 않으면 건너뜀
for (i in 1:length(src_file)) {
  for (j in 1:length(folder)) {
    if (file.exists(paste(folder[j], "/", src_file[i], sep = ""))) {
      assign(data_name[i], st_read(paste(folder[j], "/", src_file[i], sep = "")))
    }
    else {
      next
    }
  }
}

# get() - 문자열이 이미 변수로 생성되어 있는 이름과 같다면 변수 내용 출력
## 수도권 토지 이용 데이터 하나로 합치기
sudo_land <- data.frame()
for (i in 1:length(data_name)) {
  sudo_land <- rbind(sudo_land, get(data_name[i]))
}

## 토지 이용 현황 코드 파일 불러오기
a <- read_excel("../data/토지이용현황도_분류항목(코드).xls", skip = 3)
## 대분류/중분류/코드 열만 추출
land_code <- a[2:4]
## 숫자 -> 문자 형변환
land_code$코드 <- as.character(land_code$코드)
## 중분류 결측값 채우기
land_jung <- c("논", "논", "밭", "밭", "초지", "초지", "임목지", "임목지", "임목지", "임지_기타", "임지_기타", "임지_기타", "임지_기타", "주거지 및 상업지", "주거지 및 상업지", "주거지 및 상업지", "주거지 및 상업지", "교통시설", "교통시설", "교통시설", "교통시설", "공업지", "공업지", "공공시설", "공공시설", "공공시설", "공공시설", "도시 및 주거지_기타시설", "도시 및 주거지_기타시설", "도시 및 주거지_기타시설", "도시 및 주거지_기타시설", "도시 및 주거지_기타시설", "습지", "습지", "하천", "호소", "호소", "수계_기타")
land_code$중분류 <- land_jung

sudo_land <- inner_join(sudo_land, land_code, by = c("UCB" = "코드"))

tm_shape(sudo_land) +
  tm_polygons("중분류") +
  tmap_options(check.and.fix = TRUE)
