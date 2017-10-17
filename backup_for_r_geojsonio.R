# Sold price analysis
```{r}
data_sold = read.csv(sold_link, header = TRUE) %>%
  as.data.frame() %>%
  filter(State == "CA") %>%   # get only data in California
  gather("date", "sales", 8:250) %>% # gather dates into a single column
  select(c(-1, -3, -4, -5,-6,-7)) %>% # delete unused columns
  spread(RegionName, sales) %>% # spread regions as columns
  select(-`Alpine`, -`Sierra`) # These two are not inclueded in the other listed_price data
# transform date column into date data type
data_sold$date = paste0(gsub("\\.", "-", gsub("X", "", data_sold$date)),"-01") %>%
  as.Date()
```

# test: set a certain time, get average sold price 
```{r}
start_date = as.Date("1996-04-01")
end_date = as.Date("1996-06-01")

avg_sold = function(data_sold, start_date, end_date)
{
  result = data_sold %>%
    filter(`date` >= start_date & `date` <= end_date) %>% # get slice of chosen time period
    select(c(-1)) %>% # drop date column
    mutate_each(funs(mean)) %>% # mean of each column
    slice(1)
  return(result)
}
# get the avg sold_price
avg_sold_price = avg_sold(data_sold, start_date, end_date)

rownames(avg_sold_price) = "price"

# get each counties shape file (or central point)
avg_sold_price %>%
  gather(key = "county", value = "avg_price")

```
```{r}
```


```{r, warning = FALSE, error= FALSE}
library(leaflet)
library(geojsonio)
country = geojsonio::geojson_read("http://catalog.civicdashboards.com/dataset/ce409ee1-5128-4b66-aa3e-957dbd4de8ba/resource/6f805645-0836-478d-b168-c1f72d53b4f3/download/5faf934922fd4748a843d55990297d9ftemp.geojson", what = "sp")
geojson <- jsonlite::fromJSON(url)
leaflet() %>% 
  addTiles() %>%
  setView(lng = -98.583, lat = 39.833, zoom = 3) %>% 
  addGeoJSON(geojson)
```

