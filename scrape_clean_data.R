library("rvest")
library("tidyverse")
library("readr")

# Function to scrape data from a single page and return as a data frame
scrape_page <- function(year) {
  url <- paste0("http://www.olympedia.org/counts/edition/", year)
  page <- read_html(url)
  
  table <- page %>% 
    html_node("body") %>% 
    html_node("div.container") %>% 
    html_node("div") %>% 
    html_node("table.table-striped")
  
  rows <- table %>% html_nodes("tr")
  
  for (i in 3:(length(rows) - 2)) {
    row <- rows[i]
    country <- row %>% html_node("td:nth-child(1)") %>% html_text(trim = TRUE)
    male <- row %>% html_node("td:nth-last-child(3)") %>% html_text(trim = TRUE) %>% as.character()
    female <- row %>% html_node("td:nth-last-child(2)") %>% html_text(trim = TRUE) %>% as.character()
    all <- row %>% html_node("td:nth-last-child(1)") %>% html_text(trim = TRUE) %>% as.character()
    
    # Create the row string with columns separated by commas
    row_str <- paste(year, country, male, female, all, sep = ",")
    
    # Append row string to CSV file
    write(row_str, file = "./data/output.csv", append = TRUE)
  }
}

years <- c(1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 53, 54, 59, 61)


# go over each year
for (year in years) {
  data <- scrape_page(year)
}

# the following I did directly in Google Sheets but can also do it here

# add headers
# replace - with 0
# map id to year


# load in the cleaned data

data_cleaned <- read_csv("./data/Olympic athelets by gender - all.csv")

groupByCountry <- data_cleaned %>% group_by(country) %>% summarise(sum=sum(all), sumWomen = sum(female), sumMen = sum(male))
groupByCountry <- groupByCountry %>% mutate(percentWomen = sumWomen/sum * 100)
groupByCountry$category <- cut(groupByCountry$percentWomen, breaks = seq(0, 60, by = 10), labels = seq(0, 50, by = 10),right = FALSE)
write_csv(groupByCountry,"./data/groupByCountry.csv")

groupByCountryCount <- groupByCountry %>% group_by(category) %>% summarise(count = n())

# filter only the top 20 countries (RUS + URS will be combined as one)
countries_list <- c("USA", "FRA", "GBR", "ITA", "GER", "AUS", "CAN", "JPN", "ESP", "SWE", "HUN", "NED", "POL", "CHN", "BRA", "URS", "KOR", "BEL", "RUS", "SUI", "DEN")
filtered_data <- data_cleaned[data_cleaned$country %in% countries_list, ]
write_csv(filtered_data,"./data/top20countries.csv")

# the following I did directly in Google Sheets but can also do it here
# combine RUS + URS
# make sure that there is a row for each of the 20 countries for each year, even if the percent column will be blank
# add in all the years for each country for the years that the Olympics were cancelled (1916, 1940, 1944), even if the percent column will be blank
