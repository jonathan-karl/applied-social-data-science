
###### This file prepares the data and runs the regressions of the paper
###### Author: Jonathan Karl

#Treatment implementation:
#  - Tanzania - October 2014
#- Zambia - July 2015
#- Guinea - May 2015
#- Liberia - October 2015
#- South Africa - July 2015
#- Kenya - November 2014
#
#Pair I (Tanzania-Uganda): Pre (2014) - Post (2015)
#Pair II (Zambia-Zimbabwe): Pre (2015) - Post (2016)
#Pair III (Guinea-Mali): Pre (2015) - Post (2016)
#Pair IV (Liberia-Sierra Leone): Pre (2015) - Post (2016)
#Pair V (South Africa-Namibia): Pre (2015) - Post (2016)
#Pair VI (Kenya-Ethiopia): Pre (2014) - Post (2015)


#######################################################
# Libraries

# Load necessary packages
library(ggmap)
library(ggthemes)
library(tidyverse)
library(foreign)
library(countrycode)
library(ggpubr)
library(rgdal)
library(sp)
library(stargazer)
library(lmtest)
library(sandwich)
library(clubSandwich)
library(fwildclusterboot)
library(modelsummary)



########################################################
# Data Prep

MLI_2012 <- read.csv("../Data Exports/Mali/MLI_06-2012_lum.csv")[,-1]
MLI_2013 <- read.csv("../Data Exports/Mali/MLI_06-2013_lum.csv")[,-1]
MLI_2014 <- read.csv("../Data Exports/Mali/MLI_06-2014_lum.csv")[,-1]
MLI_2015 <- read.csv("../Data Exports/Mali/MLI_06-2015_lum.csv")[,-1]
MLI_2016 <- read.csv("../Data Exports/Mali/MLI_06-2016_lum.csv")[,-1]
MLI_2017 <- read.csv("../Data Exports/Mali/MLI_06-2017_lum.csv")[,-1]
GIN_2012 <- read.csv("../Data Exports/Guinea/GIN_06-2012_lum.csv")[,-1]
GIN_2013 <- read.csv("../Data Exports/Guinea/GIN_06-2013_lum.csv")[,-1]
GIN_2014 <- read.csv("../Data Exports/Guinea/GIN_06-2014_lum.csv")[,-1]
GIN_2015 <- read.csv("../Data Exports/Guinea/GIN_06-2015_lum.csv")[,-1]
GIN_2016 <- read.csv("../Data Exports/Guinea/GIN_06-2016_lum.csv")[,-1]
GIN_2017 <- read.csv("../Data Exports/Guinea/GIN_06-2017_lum.csv")[,-1]
LBR_2012 <- read.csv("../Data Exports/Liberia/LBR_06-2012_lum.csv")[,-1]
LBR_2013 <- read.csv("../Data Exports/Liberia/LBR_06-2013_lum.csv")[,-1]
LBR_2014 <- read.csv("../Data Exports/Liberia/LBR_06-2014_lum.csv")[,-1]
LBR_2015 <- read.csv("../Data Exports/Liberia/LBR_06-2015_lum.csv")[,-1]
LBR_2016 <- read.csv("../Data Exports/Liberia/LBR_06-2016_lum.csv")[,-1]
LBR_2017 <- read.csv("../Data Exports/Liberia/LBR_06-2017_lum.csv")[,-1]
SLE_2012 <- read.csv("../Data Exports/Sierra Leone/SLE_06-2012_lum.csv")[,-1]
SLE_2013 <- read.csv("../Data Exports/Sierra Leone/SLE_06-2013_lum.csv")[,-1]
SLE_2014 <- read.csv("../Data Exports/Sierra Leone/SLE_06-2014_lum.csv")[,-1]
SLE_2015 <- read.csv("../Data Exports/Sierra Leone/SLE_06-2015_lum.csv")[,-1]
SLE_2016 <- read.csv("../Data Exports/Sierra Leone/SLE_06-2016_lum.csv")[,-1]
SLE_2017 <- read.csv("../Data Exports/Sierra Leone/SLE_06-2017_lum.csv")[,-1]
TZA_2012 <- read.csv("../Data Exports/Tanzania/TZA_06-2012_lum.csv")[,-1]
TZA_2013 <- read.csv("../Data Exports/Tanzania/TZA_06-2013_lum.csv")[,-1]
TZA_2014 <- read.csv("../Data Exports/Tanzania/TZA_06-2014_lum.csv")[,-1]
TZA_2015 <- read.csv("../Data Exports/Tanzania/TZA_06-2015_lum.csv")[,-1]
TZA_2016 <- read.csv("../Data Exports/Tanzania/TZA_06-2016_lum.csv")[,-1]
TZA_2017 <- read.csv("../Data Exports/Tanzania/TZA_06-2017_lum.csv")[,-1]
UGA_2012 <- read.csv("../Data Exports/Uganda/UGA_06-2012_lum.csv")[,-1]
UGA_2013 <- read.csv("../Data Exports/Uganda/UGA_06-2013_lum.csv")[,-1]
UGA_2014 <- read.csv("../Data Exports/Uganda/UGA_06-2014_lum.csv")[,-1]
UGA_2015 <- read.csv("../Data Exports/Uganda/UGA_06-2015_lum.csv")[,-1]
UGA_2016 <- read.csv("../Data Exports/Uganda/UGA_06-2016_lum.csv")[,-1]
UGA_2017 <- read.csv("../Data Exports/Uganda/UGA_06-2017_lum.csv")[,-1]
ZMB_2012 <- read.csv("../Data Exports/Zambia/ZMB_06-2012_lum.csv")[,-1]
ZMB_2013 <- read.csv("../Data Exports/Zambia/ZMB_06-2013_lum.csv")[,-1]
ZMB_2014 <- read.csv("../Data Exports/Zambia/ZMB_06-2014_lum.csv")[,-1]
ZMB_2015 <- read.csv("../Data Exports/Zambia/ZMB_06-2015_lum.csv")[,-1]
ZMB_2016 <- read.csv("../Data Exports/Zambia/ZMB_06-2016_lum.csv")[,-1]
ZMB_2017 <- read.csv("../Data Exports/Zambia/ZMB_06-2017_lum.csv")[,-1]
ZWE_2012 <- read.csv("../Data Exports/Zimbabwe/ZWE_06-2012_lum.csv")[,-1]
ZWE_2013 <- read.csv("../Data Exports/Zimbabwe/ZWE_06-2013_lum.csv")[,-1]
ZWE_2014 <- read.csv("../Data Exports/Zimbabwe/ZWE_06-2014_lum.csv")[,-1]
ZWE_2015 <- read.csv("../Data Exports/Zimbabwe/ZWE_06-2015_lum.csv")[,-1]
ZWE_2016 <- read.csv("../Data Exports/Zimbabwe/ZWE_06-2016_lum.csv")[,-1]
ZWE_2017 <- read.csv("../Data Exports/Zimbabwe/ZWE_06-2017_lum.csv")[,-1]
NAM_2012 <- read.csv("../Data Exports/Namibia/NAM_06-2012_lum.csv")[,-1]
NAM_2013 <- read.csv("../Data Exports/Namibia/NAM_06-2013_lum.csv")[,-1]
NAM_2014 <- read.csv("../Data Exports/Namibia/NAM_06-2014_lum.csv")[,-1]
NAM_2015 <- read.csv("../Data Exports/Namibia/NAM_06-2015_lum.csv")[,-1]
NAM_2016 <- read.csv("../Data Exports/Namibia/NAM_06-2016_lum.csv")[,-1]
NAM_2017 <- read.csv("../Data Exports/Namibia/NAM_06-2017_lum.csv")[,-1]
ZAF_2012 <- read.csv("../Data Exports/South Africa/ZAF_06-2012_lum.csv")[,-1]
ZAF_2013 <- read.csv("../Data Exports/South Africa/ZAF_06-2013_lum.csv")[,-1]
ZAF_2014 <- read.csv("../Data Exports/South Africa/ZAF_06-2014_lum.csv")[,-1]
ZAF_2015 <- read.csv("../Data Exports/South Africa/ZAF_06-2015_lum.csv")[,-1]
ZAF_2016 <- read.csv("../Data Exports/South Africa/ZAF_06-2016_lum.csv")[,-1]
ZAF_2017 <- read.csv("../Data Exports/South Africa/ZAF_06-2017_lum.csv")[,-1]
KEN_2012 <- read.csv("../Data Exports/Kenya/KEN_06-2012_lum.csv")[,-1]
KEN_2013 <- read.csv("../Data Exports/Kenya/KEN_06-2013_lum.csv")[,-1]
KEN_2014 <- read.csv("../Data Exports/Kenya/KEN_06-2014_lum.csv")[,-1]
KEN_2015 <- read.csv("../Data Exports/Kenya/KEN_06-2015_lum.csv")[,-1]
KEN_2016 <- read.csv("../Data Exports/Kenya/KEN_06-2016_lum.csv")[,-1]
KEN_2017 <- read.csv("../Data Exports/Kenya/KEN_06-2017_lum.csv")[,-1]
ETH_2012 <- read.csv("../Data Exports/Ethiopia/ETH_06-2012_lum.csv")[,-1]
ETH_2013 <- read.csv("../Data Exports/Ethiopia/ETH_06-2013_lum.csv")[,-1]
ETH_2014 <- read.csv("../Data Exports/Ethiopia/ETH_06-2014_lum.csv")[,-1]
ETH_2015 <- read.csv("../Data Exports/Ethiopia/ETH_06-2015_lum.csv")[,-1]
ETH_2016 <- read.csv("../Data Exports/Ethiopia/ETH_06-2016_lum.csv")[,-1]
ETH_2017 <- read.csv("../Data Exports/Ethiopia/ETH_06-2017_lum.csv")[,-1]


pair_prep <- function(Pre_Treat, Post_Treat, Treatment_Country, Pre_N_Treat, Post_N_Treat, N_Treatment_Country, Pre_Year, Post_Year, pair_x){
  Treated <- rbind(Pre_Treat, Post_Treat)
  rows <- nrow(Pre_Treat)
  colnames(Treated)[1] <- "Admin"
  Treated$Year <- c(rep(Pre_Year, rows), rep(Post_Year, rows))
  Treated$Pre_Post <- c(rep("Pre", rows), rep("Post", rows))
  Treated$T <- rep(1, rows*2)
  Treated$Country <- rep(Treatment_Country, rows*2)
  Untreated <- rbind(Pre_N_Treat, Post_N_Treat)
  rows <- nrow(Pre_N_Treat)
  colnames(Untreated)[1] <- "Admin"
  Untreated$Year <- c(rep(Pre_Year, rows), rep(Post_Year, rows))
  Untreated$Pre_Post <- c(rep("Pre", rows), rep("Post", rows))
  Untreated$T <- rep(0, rows*2)
  Untreated$Country <- rep(N_Treatment_Country, rows*2)
  pair_X <- rbind(Treated, Untreated)
  pair_X$pair <- rep(pair_x, nrow(pair_X))
  
  return(pair_X)
}

# 1-year gap

## Pair I
pair_I <- pair_prep(Pre_Treat = TZA_2014, 
                    Post_Treat = TZA_2015,
                    Treatment_Country = "Tanzania", 
                    Pre_N_Treat = UGA_2014, 
                    Post_N_Treat = UGA_2015,
                    N_Treatment_Country = "Uganda",
                    Pre_Year = 2014,
                    Post_Year = 2015,
                    pair_x = "Pair I")

# Pair II
pair_II <- pair_prep(Pre_Treat = KEN_2014, 
                     Post_Treat = KEN_2015,
                     Treatment_Country = "Kenya", 
                     Pre_N_Treat = ETH_2014, 
                     Post_N_Treat = ETH_2015,
                     N_Treatment_Country = "Ethiopia",
                     Pre_Year = 2014,
                     Post_Year = 2015,
                     pair_x = "Pair II")

# Pair III
pair_III <- pair_prep(Pre_Treat = GIN_2015, 
                      Post_Treat = GIN_2016,
                      Treatment_Country = "Guinea", 
                      Pre_N_Treat = MLI_2015, 
                      Post_N_Treat = MLI_2016,
                      N_Treatment_Country = "Mali",
                      Pre_Year = 2015,
                      Post_Year = 2016,
                      pair_x = "Pair III")

# Pair IV
pair_IV <- pair_prep(Pre_Treat = ZMB_2015, 
                     Post_Treat = ZMB_2016,
                     Treatment_Country = "Zambia", 
                     Pre_N_Treat = ZWE_2015, 
                     Post_N_Treat = ZWE_2016,
                     N_Treatment_Country = "Zimbabwe",
                     Pre_Year = 2015,
                     Post_Year = 2016,
                     pair_x = "Pair IV")

# Pair V
pair_V <- pair_prep(Pre_Treat = ZAF_2015, 
                    Post_Treat = ZAF_2016,
                    Treatment_Country = "South Africa", 
                    Pre_N_Treat = NAM_2015, 
                    Post_N_Treat = NAM_2016,
                    N_Treatment_Country = "Namibia",
                    Pre_Year = 2015,
                    Post_Year = 2016,
                    pair_x = "Pair V")

# Pair VI
pair_VI <- pair_prep(Pre_Treat = LBR_2015, 
                     Post_Treat = LBR_2016,
                     Treatment_Country = "Liberia", 
                     Pre_N_Treat = SLE_2015, 
                     Post_N_Treat = SLE_2016,
                     N_Treatment_Country = "Sierra Leone",
                     Pre_Year = 2015,
                     Post_Year = 2016,
                     pair_x = "Pair VI")


# Combine pairs to one dataset
diff_diff_data <- rbind(pair_I, pair_II, pair_III, pair_IV, pair_V, pair_VI) %>%
  select(Country, pair, Admin, T, Year, Pre_Post, Area, Population, r_u, mean)


# Fix the one Kenya region
diff_diff_data$mean[is.na(diff_diff_data$mean)] <- 0.01

# Make factors
diff_diff_data$pair <- factor(diff_diff_data$pair)
diff_diff_data$Pre_Post <- factor(diff_diff_data$Pre_Post)

# Fix stuff
diff_diff_data$EIU <- inclusive_internet_score$overall_score[match(diff_diff_data$Country, rownames(inclusive_internet_score))]
diff_diff_data$mean <- ifelse(is.nan(diff_diff_data$mean) | is.na(diff_diff_data$mean) | diff_diff_data$mean < 0, 0.01, diff_diff_data$mean)
diff_diff_data$log_mean <- log(diff_diff_data$mean)
diff_diff_data$Treatment <- diff_diff_data$T

# 2-year gap

## Pair I
pair_I <- pair_prep(Pre_Treat = TZA_2014, 
                    Post_Treat = TZA_2016,
                    Treatment_Country = "Tanzania", 
                    Pre_N_Treat = UGA_2014, 
                    Post_N_Treat = UGA_2016,
                    N_Treatment_Country = "Uganda",
                    Pre_Year = 2014,
                    Post_Year = 2016,
                    pair_x = "Pair I")

# Pair II
pair_II <- pair_prep(Pre_Treat = KEN_2014, 
                     Post_Treat = KEN_2016,
                     Treatment_Country = "Kenya", 
                     Pre_N_Treat = ETH_2014, 
                     Post_N_Treat = ETH_2016,
                     N_Treatment_Country = "Ethiopia",
                     Pre_Year = 2014,
                     Post_Year = 2016,
                     pair_x = "Pair II")

# Pair III
pair_III <- pair_prep(Pre_Treat = GIN_2015, 
                      Post_Treat = GIN_2017,
                      Treatment_Country = "Guinea", 
                      Pre_N_Treat = MLI_2015, 
                      Post_N_Treat = MLI_2017,
                      N_Treatment_Country = "Mali",
                      Pre_Year = 2015,
                      Post_Year = 2017,
                      pair_x = "Pair III")

# Pair IV
pair_IV<- pair_prep(Pre_Treat = ZMB_2015, 
                    Post_Treat = ZMB_2017,
                    Treatment_Country = "Zambia", 
                    Pre_N_Treat = ZWE_2015, 
                    Post_N_Treat = ZWE_2017,
                    N_Treatment_Country = "Zimbabwe",
                    Pre_Year = 2015,
                    Post_Year = 2017,
                    pair_x = "Pair IV")

# Pair V
pair_V <- pair_prep(Pre_Treat = ZAF_2015, 
                    Post_Treat = ZAF_2017,
                    Treatment_Country = "South Africa", 
                    Pre_N_Treat = NAM_2015, 
                    Post_N_Treat = NAM_2017,
                    N_Treatment_Country = "Namibia",
                    Pre_Year = 2015,
                    Post_Year = 2017,
                    pair_x = "Pair V")

# Pair VI
pair_VI <- pair_prep(Pre_Treat = LBR_2015, 
                     Post_Treat = LBR_2017,
                     Treatment_Country = "Liberia", 
                     Pre_N_Treat = SLE_2015, 
                     Post_N_Treat = SLE_2017,
                     N_Treatment_Country = "Sierra Leone",
                     Pre_Year = 2015,
                     Post_Year = 2017,
                     pair_x = "Pair VI")


# Combine pairs to one dataset
diff_diff_data_II <- rbind(pair_I, pair_II, pair_III, pair_IV, pair_V, pair_VI) %>%
  select(Country, pair, Admin, T, Year, Pre_Post, Area, Population, r_u, mean)

# Fix the one Kenya region
diff_diff_data$mean[is.na(diff_diff_data$mean)] <- 0.01

# Make factors
diff_diff_data$pair <- factor(diff_diff_data$pair)
diff_diff_data$Pre_Post <- factor(diff_diff_data$Pre_Post)

# Fix stuff
diff_diff_data_II$EIU <- inclusive_internet_score$overall_score[match(diff_diff_data_II$Country, rownames(inclusive_internet_score))]
diff_diff_data_II$mean <- ifelse(is.nan(diff_diff_data_II$mean) | is.na(diff_diff_data_II$mean) |  diff_diff_data_II$mean < 0, 0.01, diff_diff_data_II$mean)
diff_diff_data_II$log_mean <- log(diff_diff_data_II$mean)
diff_diff_data_II$Treatment <- diff_diff_data_II$T

#######################################################
## General Trend I & II


# summary statistics
summary(diff_diff_data[diff_diff_data$T==0,])
summary(diff_diff_data[diff_diff_data$T==1,])
stargazer(diff_diff_data[diff_diff_data$T==0,], type="text")
stargazer(diff_diff_data[diff_diff_data$T==1,], type="text")


general_trend_plot <- function(diff_diff_data){
  pre_no_treatment <- mean(diff_diff_data[diff_diff_data$T==0 & diff_diff_data$Pre_Post == "Pre","mean"], na.rm = T)
  pre_treatment <- mean(diff_diff_data[diff_diff_data$T==1 & diff_diff_data$Pre_Post == "Pre","mean"], na.rm = T)
  post_no_treatment <- mean(diff_diff_data[diff_diff_data$T==0 & diff_diff_data$Pre_Post == "Post","mean"], na.rm = T)
  post_treatment <- mean(diff_diff_data[diff_diff_data$T==1 & diff_diff_data$Pre_Post == "Post","mean"], na.rm = T)
  
  pre_no_treatment_rural <- mean(diff_diff_data[diff_diff_data$T==0 & diff_diff_data$Pre_Post == "Pre" & diff_diff_data$r_u == "R","mean"], na.rm = T)
  pre_treatment_rural <- mean(diff_diff_data[diff_diff_data$T==1 & diff_diff_data$Pre_Post == "Pre" & diff_diff_data$r_u == "R","mean"], na.rm = T)
  post_no_treatment_rural <- mean(diff_diff_data[diff_diff_data$T==0 & diff_diff_data$Pre_Post == "Post" & diff_diff_data$r_u == "R","mean"], na.rm = T)
  post_treatment_rural <- mean(diff_diff_data[diff_diff_data$T==1 & diff_diff_data$Pre_Post == "Post" & diff_diff_data$r_u == "R","mean"], na.rm = T)
  
  pre_no_treatment_urban <- mean(diff_diff_data[diff_diff_data$T==0 & diff_diff_data$Pre_Post == "Pre" & diff_diff_data$r_u == "U","mean"], na.rm = T)
  pre_treatment_urban <- mean(diff_diff_data[diff_diff_data$T==1 & diff_diff_data$Pre_Post == "Pre" & diff_diff_data$r_u == "U","mean"], na.rm = T)
  post_no_treatment_urban <- mean(diff_diff_data[diff_diff_data$T==0 & diff_diff_data$Pre_Post == "Post" & diff_diff_data$r_u == "U","mean"], na.rm = T)
  post_treatment_urban <- mean(diff_diff_data[diff_diff_data$T==1 & diff_diff_data$Pre_Post == "Post" & diff_diff_data$r_u == "U","mean"], na.rm = T)
  
  
  general_trend <- data.frame(Pre_Post = c(0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1), 
                              Luminosity = c(pre_no_treatment, pre_treatment, post_no_treatment, post_treatment,
                                             pre_no_treatment_rural, pre_treatment_rural, post_no_treatment_rural, post_treatment_rural,
                                             pre_no_treatment_urban, pre_treatment_urban, post_no_treatment_urban, post_treatment_urban))
  
  #row.names(general_trend) <- c("pre_no_treatment", "pre_treatment", "post_no_treatment", "post_treatment")
  
  ggplot() + 
    ggtitle("General Trend Economic Output Uganda/Tanzania between Pre and Post") +
    geom_point(data = general_trend, aes(x = Pre_Post, y = Luminosity)) + 
    geom_line(data = general_trend[c(1,3),], aes(x = Pre_Post, y = Luminosity, colour = "No Treatment All")) + 
    geom_line(data = general_trend[c(2,4),], aes(x = Pre_Post, y = Luminosity, colour = "Treatment All")) + 
    geom_line(data = general_trend[c(5,7),], aes(x = Pre_Post, y = Luminosity, colour = "No Treatment Rural")) + 
    geom_line(data = general_trend[c(6,8),], aes(x = Pre_Post, y = Luminosity, colour = "Treatment Rural")) + 
    geom_line(data = general_trend[c(9,11),], aes(x = Pre_Post, y = Luminosity, colour = "No Treatment Urban")) + 
    geom_line(data = general_trend[c(10,12),], aes(x = Pre_Post, y = Luminosity, colour = "Treatment Urban")) + 
    theme_minimal() 
}

# Show general trends
general_trend_plot(diff_diff_data)
general_trend_plot(diff_diff_data_II)


#########################################################
# The Analysis

#################
# 1 - Year Gap

suppressMessages(attach(diff_diff_data))
m3 <- lm(log_mean ~ Treatment*Pre_Post + r_u + pair)
names(coef(m3))
summary(m3)

# The Bootstrap
boot_m3 <- boottest(m3, clustid = "pair", param = "Treatment:Pre_PostPre", B = 9999)
msummary(list(boot_m3), estimate = "{estimate} ({p.value})", statistic = "[{conf.low}, {conf.high}]")

m4 <- coeftest(m3, vcov = vcovHC(m3, type="HC1"))
m5 <- coeftest(m3, vcov= vcovCR(m3, diff_diff_data$pair,type="CR1"))
stargazer(list(m3, m4, m5), column.labels = c("White SE", "Robust SE", "Clustered Pairs"), type="latex")
suppressMessages(detach(diff_diff_data))

## Rerunning this only rural and only urban
# Rural
did_rural <- diff_diff_data[diff_diff_data$r_u == "R",]
suppressMessages(attach(did_rural))
m6 <- lm(log_mean~ Treatment*Pre_Post + pair)

# The Bootstrap
boot_m6 <- boottest(m6, clustid = "pair", param = "Treatment:Pre_PostPre", B = 9999)
msummary(list(boot_m6), estimate = "{estimate} ({p.value})", statistic = "[{conf.low}, {conf.high}]")

m7 <- coeftest(m6, vcov = vcovHC(m6, type="HC1"))
m8 <- coeftest(m6, vcov= vcovCR(m6, did_rural$pair,type="CR1"))
stargazer(list(m6, m7, m8), column.labels = c("White SE", "Robust SE", "Clustered Pairs"), type="latex")
suppressMessages(detach(did_rural))

# Urban
did_urban <- diff_diff_data[diff_diff_data$r_u == "U",]
suppressMessages(attach(did_urban))
m9 <- lm(log_mean ~ Treatment*Pre_Post + pair)

# The Bootstrap
boot_m9 <- boottest(m9, clustid = "pair", param = "Treatment:Pre_PostPre", B = 9999)
msummary(list(boot_m9), estimate = "{estimate} ({p.value})", statistic = "[{conf.low}, {conf.high}]")

m10 <- coeftest(m9, vcov = vcovHC(m9, type="HC1"))
m11 <- coeftest(m9, vcov= vcovCR(m9, did_urban$pair,type="CR1"))
stargazer(list(m9, m10, m11), column.labels = c("White SE", "Robust SE",  "Clustered Pairs"), type="latex")
suppressMessages(detach(did_urban))

##################
# 2 - Year Gap

suppressMessages(attach(diff_diff_data_II))
# Economic Growth(i) = alpha + Free_Basics(i) + Country(i) + Time(t) + Country_x_Time(it) + epsilon
m12 <- lm(log_mean ~ Treatment*Pre_Post + r_u + pair)

# The Bootstrap
boot_m12 <- boottest(m12, clustid = "pair", param = "Treatment:Pre_PostPre", B = 9999)
msummary(list(boot_m12), estimate = "{estimate} ({p.value})", statistic = "[{conf.low}, {conf.high}]")

m13 <- coeftest(m12, vcov = vcovHC(m12, type="HC1"))
m14 <- coeftest(m12, vcov= vcovCR(m12, diff_diff_data_II$pair,type="CR1"))
stargazer(list(m12, m13, m14), column.labels = c("White SE", "Robust SE", "Clustered Pairs"), type="latex")
suppressMessages(detach(diff_diff_data_II))

## Rerunning this only rural and only urban
# Rural
did_rural_II <- diff_diff_data_II[diff_diff_data_II$r_u == "R",]
suppressMessages(attach(did_rural_II))
m15 <- lm(log_mean ~ Treatment*Pre_Post + pair)

# The Bootstrap
boot_m15 <- boottest(m15, clustid = "pair", param = "Treatment:Pre_PostPre", B = 9999)
msummary(list(boot_m15), estimate = "{estimate} ({p.value})", statistic = "[{conf.low}, {conf.high}]")

m16 <- coeftest(m15, vcov = vcovHC(m15, type="HC1"))
m17 <- coeftest(m15, vcov= vcovCR(m15, did_rural$pair,type="CR1"))
stargazer(list(m15, m16, m17), column.labels = c("White SE", "Robust SE", "Clustered Pairs"), type="latex")
suppressMessages(detach(did_rural_II))

# Urban
did_urban_II <- diff_diff_data_II[diff_diff_data_II$r_u == "U",]
suppressMessages(attach(did_urban_II))
m18 <- lm(log_mean ~ Treatment*Pre_Post + pair)

# The Bootstrap
boot_m18 <- boottest(m18, clustid = "pair", param = "Treatment:Pre_PostPre", B = 9999)
msummary(list(boot_m18), estimate = "{estimate} ({p.value})", statistic = "[{conf.low}, {conf.high}]")

m19 <- coeftest(m18, vcov = vcovHC(m18, type="HC1"))
m20 <- coeftest(m18, vcov= vcovCR(m18, did_urban$pair,type="CR1"))
stargazer(list(m18, m19, m20), column.labels = c("White SE", "Robust SE", "Clustered Pairs"), type="latex")
suppressMessages(attach(did_urban_II))
