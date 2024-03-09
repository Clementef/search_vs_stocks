ui_portfolio <- fluidPage(
    titlePanel("Custom Portfolio"),
    
    sidebarLayout(
        sidebarPanel(
            # symbol input
            selectizeInput("portfolio_symbols", "Select Stocks:", 
                           choices=all_stocks_list, 
                           selected = c("AAPL (APPLE INC)"), 
                           multiple = TRUE, options = NULL),
            
            # proportions input
            uiOutput("portfolio_proportions"),
            
            # submit button
            actionButton("portfolio_submit", "Submit")
        ),
        
        mainPanel(
            withSpinner(plotOutput("portfolio_plot"), 
                        type = 1, color="#dbdbdb")
        )
    )
)