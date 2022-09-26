library(tidyverse)
library(tmap)
tmap_mode("view")
library(sf)
library(raster)
library(readxl)

region <- st_read("../HangJeongDong_ver20220101.geojson")
seoul_region <- subset(region, substr(region$ADMI_CD, 1, 2) == "11") # 서울

dir <- c("../data/NGII_LUM_11_서울")
src_file <- list.files(dir)
src_file <- src_file[substr(src_file, 8, 10) == "shp"]
data_name <- paste0("land", "_", substr(src_file, 1, 6))

for (i in 1:length(src_file)) {
  assign(data_name[i], st_read(paste(dir, "/", src_file[i], sep = "")))
}

a <- read_excel("../data/토지이용현황도_분류항목(코드).xls", skip = 3)
land_code <- a[3:4]
land_code$코드 <- as.character(land_code$코드)

land <- rbind(land_376082, land_376083, land_376084, land_376121, land_376122, land_377051,
              land_377053, land_377054, land_377091, land_377092)

land <- inner_join(land, land_code, by = c("UCB" = "코드"))

land_c <- land %>%
  group_by(소분류) %>%
  drop_na() %>%
  st_as_sf()
st_set_crs(land_c, 4326)

tm_shape(seoul_region) +
  tm_borders() +
  tm_shape(land_c) +
  tm_polygons("소분류") +
  tmap_options(check.and.fix = TRUE)