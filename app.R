# tidyverse
library(dplyr)
library(purrr)
library(tibble)
library(stringr)
library(lubridate)
library(ggplot2)

# apis
library(gtrendsR)
library(tidyquant)

# shiny
library(shiny)
library(shinyBS)
library(shinythemes)
library(shinycssloaders)

# set project
library(here)
i_am("finance_search_trends_webapp.Rproj")

# external scripts
source(here("gtrends_helper.R"))
source(here("quant_helper.R"))
source(here("presets.R"))

# pages
source(here("ui_selectedstocks.R"))
source(here("server_selectedstocks.R"))
source(here("ui_portfolio.R"))
source(here("server_portfolio.R"))

# app definition
shinyApp(
    ui = navbarPage(
        theme = shinytheme("slate"),
        "Search vs. Stocks",
        tabPanel("Selected Stocks", ui_selectedstocks),
        tabPanel("Custom Portfolio", ui_portfolio)
    ),
    server = function(input, output, session) {
        server_selectedstocks(input, output, session)
        server_portfolio(input, output, session)
    }
)