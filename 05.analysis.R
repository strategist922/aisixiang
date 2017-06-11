library(tidyverse)
library(magrittr)
library(lubridate)

D0120 <- read.csv("aisixiang_2017_01_20_full.csv", stringsAsFactors = F)
D0524 <- read_csv("aisixiang_2017_05_24_full.csv")
D0610 <- read_csv('all_aisixiang_2017-06-10.csv')

# Author frequency --------------------------------------------------------

table(D0120$Author) %>% sort(., decreasing = T) %>% View()


# ID with time ------------------------------------------------------------

ggplot(D0524, aes(Times, ID)) +
  geom_point(size = 0.2) +
  theme(text = element_text(family = "STFangsong")) +
  xlab('日期') +
  ylab('文章ID') +
  ggtitle('文章 ID 与时间的关系') 

# 2017-06-10 delete -------------------------------------------------------

Index <- All %in% D0610$ID
table(Index)
All <- 1:max(D0610$ID)
Delete <- All[!Index]

Index2 <- D0610$ID %in% (Delete+10)

D_new <- D0610[Index2, ]
D_new$delete <- 'Deleted'
D0610$delete <- 'Not deleted'
D_new <- rbind(D_new, D0610)

ggplot(D_new, aes(year(Times), fill = delete)) +
  geom_histogram(bins = 18) +
  scale_x_continuous(breaks = 2000:2017) +
  scale_y_continuous(breaks = seq(0, 15000, by = 3000)) +
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5)) +
  theme(text = element_text(family = "STFangsong")) +
  xlab('日期') +
  ylab('文章数量') +
  ggtitle('历年文章数量与删文数量') 

# delete ratio ------------------------------------------------------------

1 - nrow(D0120) / max(D0120$ID)
1 - nrow(D0524) / max(D0524$ID)
1 - nrow(D0610) / max(D0610$ID)

# delete content analysis -------------------------------------------------

Index <- D0120$ID %in% D0610$ID
ID_delete <- D0120[!Index, ]$ID
Delete0120 <- filter(D0120, ID %in% ID_delete)

table(Delete0120$Availablity)
table(Delete0120$Author) %>% sort(., decreasing = T) %>% View()
