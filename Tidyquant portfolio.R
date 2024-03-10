weights <- c(0.5,0.5)

# Get Our Symbols
symbols <- c("AAPL","MSFT")
# Get our start date and end date
end_date <- Sys.Date()
start_date <- end_date - months(11)

# Get the stock prices
stock_prices_df <- tq_get(symbols,
                          from = start_date,
                          to = end_date,
                          get = "stock.prices")

# Calculate the stock returns
stock_returns <- stock_prices_df %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted, mutate_fun = periodReturn, period = "monthly", type = "log")

# Use tq_portfolio
portfolio_returns_df <- tq_portfolio(data = stock_returns,
                                     assets_col = symbol,
                                     returns_col = monthly.returns,
                                     weights = weights)

# Plot the returns
ggplot(portfolio_returns_df, aes(x = date, y = portfolio.returns)) +
  geom_line() +
  labs(x = "Date", y = "Portfolio Return", title = "Portfolio Returns Over Time")

