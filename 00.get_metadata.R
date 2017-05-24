library(rvest)
library(magrittr)

Download <- function(x){
  read_html(x) %>% {
    A1 <- html_nodes(., "div.tips a") %>%{
      Title <- html_text(.)
      ID <- html_attr(., "href") %>%
        gsub('\\D', '', .)
      cbind(Title, ID)
    }
    
    Author <- html_nodes(., "div.name a") %>%
      html_text()
    
    Ablum <- html_nodes(., "div.ablum_list a") %>%
      html_text()
    
    Times <- html_nodes(., "div.times") %>%
      html_text()
    Times <- Times[2:length(Times)]
    
    Click <- html_nodes(., "div.click") %>%
      html_text()
    Click <- Click[2:length(Click)]
    
    cbind(A1, Author, Ablum, Times, Click)
    } %>%
    as.data.frame()
}

# =========================================================================================


Get_catalog <- function(x = '7'){
  ## x 参数表示 http://www.aisixiang.com/toplist/ 中的一天、一周和一月，以及全部，分别为
  ## ‘1’，‘7’，‘30’，‘all’，默认为一周。 
  
  i <- 1
  Name_date <- paste0(x, '_aisixiang_', Sys.Date(), '.csv')
  Aisixiang <- Download(paste0('http://www.aisixiang.com/toplist/index.php?id=1&period=', x,
                               '&page=', i))
  
  ## 注意，如果最后一页恰好为 20，那么程序将永远运行下去，鉴于这种概率只有5%，就算了。
  while(nrow(Aisixiang) == 20 * i){
    i <- i + 1
    Url <- paste0('http://www.aisixiang.com/toplist/index.php?id=1&period=', x, '&page=', i)
    Aisixiang <- rbind(Aisixiang, Download(Url))
    print(i)
    Sys.sleep(1)
  }
  write.csv(Aisixiang, file = Name_date, row.names = F) # 注意命名
}

Get_catalog()
