ui_selectedstocks <- fluidPage(
    titlePanel("Selected Stocks"),
    sidebarLayout(
        sidebarPanel(
            # symbol input
            selectizeInput("stock_input", "Select Stocks:", 
                           choices=all_stocks_list, 
                           selected = c("AAPL (APPLE INC)"), multiple = TRUE, options = NULL),
            
            # search terms input
            # search terms input
            tags$div(
                style = "display: none;",
                textInput("keyword", "Enter Search Term*:", ""),
            ),
            
            # date range input
            fluidRow(
                column(6, dateInput("start_date", "Start Date:", 
                                    value = Sys.Date() - months(2),
                                    max = Sys.Date() - day(1),
                                    min = "2017-01-01")),
                column(6, dateInput("end_date", "End Date:", 
                                    value = Sys.Date(),
                                    max = Sys.Date(),
                                    min = "2017-01-01"))
            ),
            
            # update button
            actionButton("update", "Update"),
            
            br(),br(),
            
            # preset controls
            bsCollapse(id = "Settings Collapse",
                       bsCollapsePanel("Examples",
                                       selectInput("preset", 
                                                   "Select from a list of presets:", 
                                                   choices = names(input_presets)),
                                       actionButton("apply_preset", "Apply Preset"),
                                       style = "default")
            ),
            
            # footnote
            paste("*Search trends data is on a relative scale (0-100),",
                  "which is then scaled to match the price range of selected",
                  "stocks over the selected date range."),
            
        ),
        mainPanel(
            withSpinner(plotOutput("scatterplot"), 
                        type = 1, color="#dbdbdb")
        )
    )
)