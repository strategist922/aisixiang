library(jiebaR)
library(tidyverse)
library(magrittr)

W <- worker("keywords", topn = 10)


# login data 2017-05-24 ---------------------------------------------------

Files_login <- list.files('data-login20170524')
Files_login2 <- Files_login[grepl("^1-",Files_login)]

L1 <- list()
j <- 1
for(i in Files_login2){
  Filename <- paste0('data-login20170524/', i)
  D0 <- read_table(Filename)
  D1 <- gsub("\\s+", '', D0$X1)
  D1 <- na.omit(D1)
  D1 <- paste(D1,collapse="") 
  D1 <- gsub("\\s+", '', D1)
  L1[[j]] <- keywords(D1, W)
  j <- j + 1
}

L1 %<>%
  unlist() %>%
  table() %>%
  sort(., decreasing = T) %>%
  as.data.frame()

names(L1) <- c('Keywords', 'Freq')

L1 <- filter(L1, Freq > 10)
write_csv(L1, "login_keys_2017_0524.csv")

# sample 2017-05-24 500 --------------------------------------------------------------

Files_non_login <- list.files('data-non-login20170524')
Files_non_login2 <- Files_non_login[grepl("^1-",Files_non_login)]
Files_non_login3 <- sample(Files_non_login2, 523)

L2 <- list()
j <- 1
for(i in Files_non_login3){
  Filename <- paste0('data-non-login20170524/', i)
  D0 <- read_table(Filename)
  D1 <- gsub("\\s+", '', D0$X1)
  D1 <- na.omit(D1)
  D1 <- paste(D1,collapse="") 
  D1 <- gsub("\\s+", '', D1)
  L2[[j]] <- keywords(D1, W)
  j <- j + 1
}

L2 %<>%
  unlist() %>%
  table() %>%
  sort(., decreasing = T) %>%
  as.data.frame()

names(L2) <- c('Keywords', 'Freq')
L2 <- filter(L2, Freq > 10)
write_csv(L2, "non_login_keys_2017_0524.csv")

# compare -----------------------------------------------------------------

Login <- read_csv("login_keys_2017_0524.csv")
Login$Freq <- 0 - Login$Freq
Non_login <- read_csv("non_login_keys_2017_0524.csv")

D <- rbind(Login, Non_login)
D1 <- tapply(D$Freq, D$Keywords, sum) %>% as.data.frame()
D2 <- data.frame(Keywords = rownames(D1), Freq = D1$.)
D2 <- D2[order(D2$Freq, decreasing = T), ]
D2$Keywords <- factor(D2$Keywords, levels = D2$Keywords)

ggplot(D2, aes(Keywords, Freq, fill = Freq)) +
  geom_bar(stat="identity", position = "identity") +
  coord_flip() +
  theme(text = element_text(family = "STFangsong")) +
  guides(fill = FALSE) +
  xlab("关键词") +
  ylab("净频率") +
  ggtitle("全部可见文章与会员可见文章的关键词净频率比较") 
