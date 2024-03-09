input_presets <- list(
"Apple vs. \"vision pro\"" = list(symbol = "AAPL (APPLE INC)", term = "vision pro",
                                  start="2023-04-01",end=as.character(Sys.Date())),
"Disney vs. \"avengers\"" = list(symbol = "DIS (WALT DISNEY CO/THE)", term = "avengers",
                                 start="2019-02-01",end="2019-07-01"),
"FAANG vs. \"best tech jobs\"" = list(symbol = c("META (META PLATFORMS INC CLASS A)",
                                                 "AMZN (AMAZON.COM INC)",
                                                 "AAPL (APPLE INC)",
                                                 "NFLX (NETFLIX INC)",
                                                 "GOOG (ALPHABET INC CL C)"),
                                      term="best tech jobs",
                                      start="2019-01-01",end=as.character(Sys.Date())),
"McDonalds vs. \"israel boycott\"" = list(symbol = c("MCD (MCDONALD S CORP)"),
                                          term="israel boycott",
                                          start="2023-04-01",end=as.character(Sys.Date()))
)
