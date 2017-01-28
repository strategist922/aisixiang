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

Available <- read_csv("Available8049.csv")
Available <- c(Available[[1]], rep(NA, nrow(D0)- length(Available[[1]])))

# 615\1598\1689\2167\2762\3181\3236\3481\3507\3722\3978, 4123, 4278, 4627, 5499,
# 5760, 5921,5937,6087, 6128, 6150 ,6151, 6204, 6658,7253, 7450,7702,7790, 8050, 8338,
# 9615, 9646

j <- 9647

D <- D0[j:nrow(D0), ]

for(i in D[["Title_url"]]){
  Url1 <- i %<>% paste0("http://www.aisixiang.com", .)
  print(Url1)

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
  
  Title <- D0[["Title"]][j] %>%
    paste0(Av, "-", j, "-", ., ".txt")
  
  print(j)
  j <- j + 1
  
  print(Title)
  
  write.table(Article, Title, quote = F, row.names = F, col.names = F)

  Sys.sleep(1)
}

write.csv(Available, "Available9645.csv", row.names = F)
table(Available)
