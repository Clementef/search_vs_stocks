server_selectedstocks <- function(input, output, session) {
    # preset controls
    observeEvent(input$apply_preset, {
        preset_values <- input_presets[[input$preset]]
        updateTextInput(session, "keyword", value = preset_values$term)
        updateSelectizeInput(session, "stock_input", selected = preset_values$symbol)
        updateDateInput(session,"start_date",value=preset_values$start)
        updateDateInput(session,"end_date",value=preset_values$end)
    })
    
    # generate plot
    updated_plot <- eventReactive(input$update, {
        # require button press
        req(input$update)
        
        # get gtrendsr data
        search_term <- input$keyword
        date_range <- paste(input$start_date,input$end_date)
        trend_data <- query_gtrends(search_term,date_range) %>%
            bind_rows()
        trend_data$date <- as.POSIXct(trend_data$date)
        
        # get financial data
        symbols <- str_extract(input$stock_input, "\\b\\w+\\b")
        stock_prices_df <- quant_get(symbols, input$start_date,input$end_date)
        stock_prices_df$date <- as.POSIXct(stock_prices_df$date)
        
        # clean trend data
        if (!is.numeric(trend_data$hits)) {
            trend_data$hits <- as.numeric(as.character(trend_data$hits))
        }
        trend_data$hits[is.na(trend_data$hits)] <- 0
        
        # scaling factor
        min_stock <- min(stock_prices_df$adjusted, na.rm = TRUE)
        max_stock <- max(stock_prices_df$adjusted, na.rm = TRUE)
        min_gtrends <- min(trend_data$hits, na.rm = TRUE)
        max_gtrends <- max(trend_data$hits, na.rm = TRUE)
        scale_factor <- (max_stock - min_stock) / (max_gtrends - min_gtrends)
        trend_data$hits_scaled <- scale_factor * (trend_data$hits - min_gtrends) + min_stock
        
        
        # plot
        ggplot() +
            # search trend data
            geom_point(data=trend_data, aes(x=date, y=hits_scaled, 
                                            color=paste("Relative Fearch Frequency for \"",search_term,"\""))) +
            geom_line(data=trend_data, aes(x=date, y=hits_scaled,
                                           color=paste("Relative Fearch Frequency for \"",search_term,"\""))) +
            # stock data
            geom_point(data=stock_prices_df, aes(x=date, y=adjusted, color=symbol)) +
            geom_line(data=stock_prices_df, aes(x=date, y=adjusted, color=symbol)) +
            labs(x = paste("Date"), y = "", 
                 title = paste0("Selected Stock Prices and Search Frequency for \"", 
                                search_term, "\""), 
                 color = "Legend") +
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
    output$scatterplot <- renderPlot({
        updated_plot()
    }, bg="transparent")
}