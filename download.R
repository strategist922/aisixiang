library(readr)
library(rvest)
library(magrittr)

D0 <-read_csv("aisixiang_2017-01-20.csv")
head(D0)

Get_txt <- function(x){
  read_html(x, encoding = "gb18030") %>%
    html_nodes("div#content2 p") %>%
    html_text()
}

Available <- vector()

# 615

j <- 616

D <- D0[j:nrow(D0), ]

for(i in D[["Title_url"]]){
  Url1 <- i %<>% paste0("http://www.aisixiang.com", .)

  Page <- read_html(Url1, encoding = "gb18030") %>%
    html_nodes("div.list_page a") %>%
    html_text()
  Page <- Page[length(Page) - 1] %>%
    as.numeric()
  
  if(length(Page) > 0){
    Begin <- substr(Url1, 1, nchar(Url1)-5)
    U2 <- paste0(Begin,"-", 1:Page, ".html")
    
    Article <- as.character()
   
    for(i in U2){
      One <- try(Get_txt(i), silent = F)
      Article <- c(Article, One)
    }
  }else{
    Article <- Get_txt(Url1)
  }
  
  Available[j] <- Av <- ifelse(length(Article) > 0, 1, 0)
  
  Title <- D[["Title"]][j] %>%
    paste0(Av, "-", j, "-", ., ".txt")
  
  print(j)
  j <- j + 1
  
  print(Title)
  
  write.table(Article, Title, quote = F, row.names = F, col.names = F)

  Sys.sleep(1)
}

write.csv(Available, "Available.csv", row.names = F, col.names = F)
