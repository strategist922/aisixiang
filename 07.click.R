library(tidyverse)
library(lubridate)

D0524 <- read_csv("aisixiang_2017_05_24_full.csv")
D0524$Availablity %<>% as.character()

D0524_non_login <- filter(D0524, Availablity == 0)
D0524_login <- filter(D0524, Availablity == 1)
D0524_login_sample <- D0524_login[sample(nrow(D0524_login), 531), ]

D <- rbind(D0524_login_sample, D0524_non_login)

D$Availablity %<>% as.factor()

ggplot(D0524, aes(Times, Click, color = Availablity)) +
 #geom_point(alpha = 0.2, size = 0.4) +
  scale_y_continuous(breaks = seq(0, 140000, by = 10000)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  geom_smooth() +
  theme(text = element_text(family = "STFangsong")) +
  xlab('日期') +
  ylab('点击量') +
  ggtitle('会员文章与全部可见文章的点击量对比') +
  guides(color = guide_legend(title="文章类型")) +
  scale_color_hue(labels = c("仅会员可见文章", "全部可见文章"))

tapply(D$Click, D$Availablity, mean)
tapply(D$Ablum, D$Availablity, table)
