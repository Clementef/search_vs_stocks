server_portfolio <- function(input, output, session) {
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
        print(proportions)
        print(symbols)
        
        
        data <- data.frame(
            x = rnorm(100),
            y = rnorm(100)
        )
        
        # Create the scatterplot using ggplot2
        ggplot(data, aes(x = x, y = y)) +
            geom_point(color = "blue", size = 3) +
            labs(title = "Random Scatterplot",
                 x = "X-axis",
                 y = "Y-axis") +
            theme_bw()
    })
    
    # render plot
    output$portfolio_plot <- renderPlot({
        updated_portfolio_plot()
    }, bg="transparent")
}