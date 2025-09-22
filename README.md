This document provides a comprehensive guide on how to retrieve meteorological time series using the `weathercan` R package. The `weathercan` package can be found at [weathercan](https://github.com/ropensci/weathercan/). Once you have obtained the data from `weathercan`, you can use it with a missing value imputation tool, available at [missing value imputation tool](https://raventools-weathercan-imputation.share.connect.posit.cloud). This tool is designed to fill in any gaps in the data, ensuring a complete dataset. Moreover, the imputed time series can be transformed into `.rvt` files that comply with [Raven Hydrologic Framework](http://raven.uwaterloo.ca/) input file format.


## Based on proximity
In this approach, the method involves searching for station(s) based on a specified proximity and a radius for the search. To initiate the search, the user must provide latitude (lat) and longitude (lon) coordinates in decimal DMS format, along with a radius value (in kilometers).


``` r
if(require("weathercan")) install.packages("weathercan",repos = "https://ropensci.r-universe.dev")
library(weathercan)

lat     <-  43.4  # degree
lon     <- -80.5  # degree
dist    <-  30    # Km
interval<- "day"
stn<-stations_search(coords   = c(lat,lon),
                     dist     = dist,
                     interval = interval)
stn<-stn[stn$end>2019,]  # filtering stations with available data after 2019

# download data
data<-weather_dl(station_ids = stn$station_id,
                 start       = as.Date("2019-01-01"),
                 end         = as.Date("2021-12-31"),
                 interval    = interval)

# save data
write.csv(data,"met_data.csv")
```

## Based on name
In this method, searching is perfomed based on the location name:

``` r
if(require("weathercan")) install.packages("weathercan",repos = "https://ropensci.r-universe.dev")
library(weathercan)

name    <- "waterloo"
interval<- "day"
stn<-stations_search(name     = name,
                     interval = interval)
stn<-stn[stn$end>2010,]    # filtering stations with available data after 2000

# download data
data<-weather_dl(station_ids = stn$station_id,
                 start       = as.Date("2010-01-01"),
                 end         = as.Date("2012-12-31"),
                 interval    = interval)

# save data
write.csv(data,"met_data.csv")
```
