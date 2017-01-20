library(readr)
library(rvest)
library(magrittr)

D <-read_csv("aisixiang_2017-01-20.csv")
head(D)
Dtest <- D[1,]
Dtest[2] %<>% paste0("http://www.aisixiang.com", .)


Download_txt <- function(x){
  Page <- read_html(x) %>%
    html_nodes("div.list_page a") %>%
    html_text()
  Page <- Page[length(Page) - 1] %>%
    as.numeric()
  
  Begin <- substr(x, 1, nchar(x)-5)
  
  U2 <- paste0(Begin,"-", 1:Page, ".html")
  
  Main <- as.character()
  for(i in U2){
    One <- read_html(i) %>%
      html_nodes("div#content2 p") %>%
      html_text()
    Main <- c(Main, One)
  }
  Main
}

mm <- Download_txt(U1)
x <- "http://www.aisixiang.com/data/102861.html"


write.table(mm, "test.txt", quote = F, row.names = F, col.names = F)
