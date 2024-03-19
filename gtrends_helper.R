query_gtrends <- function(search, input_time) {
    gtrends(
        keyword = search,
        geo = "US",
        time = input_time,
        gprop = "web",
        category = 0,
        hl = "en-US",
        compared_breakdown = FALSE,
        low_search_volume = FALSE,
        cookie_url = "http://trends.google.com/Cookies/NID",
        tz = "UTC",
        onlyInterest = TRUE
    )$interest_over_time
}

trends_enabled <- FALSE