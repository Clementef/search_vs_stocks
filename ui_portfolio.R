ui_portfolio <- fluidPage(
    titlePanel("Custom Portfolio"),
    
    sidebarLayout(
        sidebarPanel(
            # symbol input
            selectizeInput("portfolio_symbols", "Select Stocks:", 
                           choices=all_stocks_list, 
                           selected = c("AAPL (APPLE INC)"), 
                           multiple = TRUE, options = NULL),
            
            # portfolio return period
            selectInput("portfolio_period", "Select Portfolio Period:",
                        choices = c("yearly", "monthly", "weekly", "daily"),
                        selected = "daily"),
            
            # search terms input
            textInput("portfolio_search_term", "Enter Search Term*:", "vision pro"),
            
            # date range input
            fluidRow(
                column(6, dateInput("portfolio_start", "Start Date:", 
                                    value = Sys.Date() - months(2),
                                    max = Sys.Date() - day(1),
                                    min = "2017-01-01")),
                column(6, dateInput("portfolio_end", "End Date:", 
                                    value = Sys.Date(),
                                    max = Sys.Date(),
                                    min = "2017-01-01"))
            ),
            
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