ui_portfolio <- fluidPage(
    titlePanel("Custom Portfolio"),
    
    sidebarLayout(
        sidebarPanel(
            # symbol input
            selectizeInput("portfolio_symbols", "Select Stocks:", 
                           choices=all_stocks_list, 
                           selected = c("AAPL (APPLE INC)",
                                        "META (META PLATFORMS INC CLASS A)"), 
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
            actionButton("portfolio_submit", "Submit"),
            
            br(),br(),
            
            # preset controls
            bsCollapse(id = "Portfolio Settings Collapse",
                       bsCollapsePanel("Examples",
                                       selectInput("portfolio_preset", 
                                                   "Select from a list of presets:", 
                                                   choices = names(input_presets)),
                                       actionButton("portfolio_preset_update", 
                                                    "Apply Preset"),
                                       style = "default")
            ),
            
            # footnote
            paste("*Search trends data is on a relative scale (0-100),",
                  "which is then scaled to match the price range of selected",
                  "stocks over the selected date range.")
        ),
        
        mainPanel(
            withSpinner(plotOutput("portfolio_plot"), 
                        type = 1, color="#dbdbdb")
        )
    )
)