library(dplyr)

data_raw <- read.csv("./alt_fuel_stations (Oct 21 2016).csv",
                     header = TRUE,sep = ",",stringsAsFactors = FALSE)

str(data_raw)

# Selected Data
data_select<- data_raw%>%
    select(ID,Station.Name,Longitude,Latitude
           ,Street.Address,City,State,ZIP,Station.Phone,
           Fuel.Type.Code)%>%
    filter(Fuel.Type.Code=="ELEC")%>%
    mutate(PopText = paste(sep = "<br />","<dl>",
                           paste("<dt><b>Name:</b></dt>","<dd>",Station.Name,"</dd>"),
                           paste("<dt><b>Street:</b></dt>","<dd>",Street.Address,"</dd>"),
                           paste("<dt><b>City, State:</b></dt>","<dd>",City,", ",State,"</dd>"),
                           paste("<dt><b>Zip Code:</b></dt>","<dd>",ZIP,"</dd>"),
                           paste("<dt><b>Phone:</b></dt>","<dd>",Station.Phone,"</dd>"),
                           "</dl>"))


library(leaflet)
my_map <- leaflet() %>%
    addTiles() %>% 
    addMarkers(lat=data_select$Latitude, lng=data_select$Longitude, 
               popup=data_select$PopText,
               clusterOptions = markerClusterOptions())
my_map
    