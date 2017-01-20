library(rvest)
library(magrittr)

Download <- function(x){
  read_html(x) %>% {
    A1 <- html_nodes(., "div.tips a") %>%{
      Title <- html_text(.)
      Title_url <- html_attr(., "href")
      cbind(Title, Title_url)
    }
    
    A2 <- html_nodes(., "div.name a") %>%{
      Author <- html_text(.)
      Author_url <- html_attr(., "href")
      cbind(Author, Author_url)
    }
    
    A3 <- html_nodes(., "div.ablum_list a") %>%{
      Ablum <- html_text(.)
      Ablum_url <- html_attr(., "href")
      cbind(Ablum, Ablum_url)
    }
    
    Times <- html_nodes(., "div.times") %>%
      html_text()
    Times <- Times[2:length(Times)]
    
    Click <- html_nodes(., "div.click") %>%
      html_text()
    Click <- Click[2:length(Click)]
    
    cbind(A1, A2, A3, Times, Click)
    } %>%
    as.data.frame()
}


# =========================================================================================
# download "文章点击排行所有"

Aisixiang <- Download("http://www.aisixiang.com/toplist/index.php?id=1&period=all&page=1")

Url <- paste0("http://www.aisixiang.com/toplist/index.php?id=1&period=all&page=", 2:4965)
for(i in Url){
  Aisixiang <- rbind(Aisixiang, Download(i))
  print(i)
}

write.csv(Aisixiang, "aisixiang_2016-12-27.csv", row.names = F)

# ========================================================================================
# update article "文章点击排行一月", at lease once a month

Update <- Download("http://www.aisixiang.com/toplist/index.php?id=1&period=30&page=1")

Url <- paste0("http://www.aisixiang.com/toplist/index.php?id=1&period=30&page=", 2:13)
for(i in Url){
  Update <- rbind(Update, Download(i))
  print(i)
}

Aisixiang <- read_csv("aisixiang_2016-12-27.csv")
Aisixiang_new <- rbind(Aisixiang, Update)
Aisixiang_new <- unique(Aisixiang_new)

write.csv(Aisixiang_new, "aisixiang_2017-01-20.csv", row.names = F)
