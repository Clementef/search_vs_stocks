quant_get <- function(symbols,start,end) {
    tq_get(symbols,
           from = start,
           to = end,
           get = "stock.prices")
}

all_companies <- map_df("SP500", tq_index)
all_stocks_list <- paste0(all_companies$symbol," (", 
                          all_companies$company, ")")
all_stocks_list[[length(all_stocks_list) + 1]] <- "SPY (S&P 500)"