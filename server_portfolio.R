server_portfolio <- function(input, output, session) {
    # preset controls
    observeEvent(input$portfolio_preset_update, {
        preset_values <- input_presets[[input$portfolio_preset]]
        updateTextInput(session, "portfolio_search_term", value = preset_values$term)
        updateSelectizeInput(session, "portfolio_symbols", selected = preset_values$symbol)
        updateDateInput(session,"portfolio_start",value=preset_values$start)
        updateDateInput(session,"portfolio_end",value=preset_values$end)
    })
    
    # create text inputs based on selected symbols
    observeEvent(input$portfolio_symbols, {
        output$portfolio_proportions <- renderUI({
            stock_inputs <- lapply(1:length(input$portfolio_symbols), function(i) {
                numericInput(paste0("proportion", i), 
                             label = paste("Proportion for", 
                                           input$portfolio_symbols[i], ":"), 
                             value = 1 / length(input$portfolio_symbols),
                             min = 0, max = 1, step = 0.01)
            })
            do.call(tagList, stock_inputs)
        })
    })
    
    # update plot based on button
    updated_portfolio_plot <- eventReactive(input$portfolio_submit, {
        # require button press
        req(input$portfolio_submit)
        
        # get proportions and symbols
        proportions <- sapply(1:length(input$portfolio_symbols), function(i) {
            input[[paste0("proportion", i)]]
        })
        
        symbols <- str_extract(input$portfolio_symbols, "\\b\\w+\\b")
        
        stock_prices_df <- tq_get(symbols,
                                  from = input$portfolio_start,
                                  to = input$portfolio_end,
                                  get = "stock.prices")
        
        # Calculate the stock returns
        stock_returns <- stock_prices_df %>%
            group_by(symbol) %>%
            tq_transmute(select = adjusted, mutate_fun = periodReturn, period = input$portfolio_period)
        stock_returns <- stock_returns %>% rename_with(~ "returns", matches(".*\\.returns"))
        # Use tq_portfolio
        portfolio_returns_df <- tq_portfolio(data = stock_returns,
                                             assets_col = symbol,
                                             returns_col = returns,
                                             weights = proportions)
        portfolio_returns_df$date <- as.Date(as.POSIXlt(portfolio_returns_df$date,
                                                "GMT"))
        # get gtrendsr data
        portfolio_search_term <- input$portfolio_search_term
        portfolio_date_range <- paste(input$portfolio_start,input$portfolio_end)
        portfolio_trend_data <- query_gtrends(portfolio_search_term,
                                    portfolio_date_range) %>%
            bind_rows()
        portfolio_trend_data$date <- as.Date(as.POSIXlt(portfolio_trend_data$date,
                                                tz="GMT"))
        
        # clean trend data
        if (!is.numeric(portfolio_trend_data$hits)) {
            portfolio_trend_data$hits <- as.numeric(as.character(portfolio_trend_data$hits))
        }
        portfolio_trend_data$hits[is.na(portfolio_trend_data$hits)] <- 0
        
        # scaling factor
        min_stock <- min(portfolio_returns_df$portfolio.returns, na.rm = TRUE)
        max_stock <- max(portfolio_returns_df$portfolio.returns, na.rm = TRUE)
        min_gtrends <- min(portfolio_trend_data$hits, na.rm = TRUE)
        max_gtrends <- max(portfolio_trend_data$hits, na.rm = TRUE)
        scale_factor <- (max_stock - min_stock) / (max_gtrends - min_gtrends)
        portfolio_trend_data$hits_scaled <- scale_factor * (portfolio_trend_data$hits - min_gtrends) + min_stock
        portfolio_trend_data$hits_scaled
        # Plot the returns
        ggplot() +
            # portfolio data
            geom_point(data=portfolio_returns_df, aes(x = date, y = portfolio.returns, color='portfolio returns')) +
            geom_line(data=portfolio_returns_df, aes(x = date, y = portfolio.returns, color='portfolio returns')) +
            # search trend data
            geom_point(data=portfolio_trend_data, aes(x=date, y=hits_scaled,
                                            color=paste("Relative Fearch Frequency for \"",portfolio_search_term,"\""))) +
            geom_line(data=portfolio_trend_data, aes(x=date, y=hits_scaled,
                                           color=paste("Relative Fearch Frequency for \"",portfolio_search_term,"\""))) +
            # stock data
            labs(x = "Date", y="", 
                 title = paste(str_to_title(input$portfolio_period),
                               "Portfolio Returns and Search Frequency for \"",
                               portfolio_search_term, "\""),
                 color="Legend") +
            theme_bw() +
            theme(
                text = element_text(size = 18, color="#f8f8f2"),
                axis.text = element_text(color = "#f8f8f2"),
                panel.grid = element_line(color = "#555555"),
                panel.background = element_blank(),
                plot.background = element_blank(),
                legend.background = element_blank(),
                legend.key = element_blank(),
                legend.position = "bottom",
            )
    })
    
    # render plot
    output$portfolio_plot <- renderPlot({
        updated_portfolio_plot()
    }, bg="transparent")
}