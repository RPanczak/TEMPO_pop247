place_full_name <- tweets_clean_2019_03_18 %>% 
  filter(is.na(lat)) %>% 
  filter(place_place_type != "country") %>% 
  filter(place_place_type != "admin") %>% 
  group_by(place_full_name) %>% 
  summarise(freq = n()) %>% 
  arrange(desc(freq)) %>% 
  ungroup()

api <- readLines("./google.api")

# devtools::install_github("dkahle/ggmap", ref = "tidyup")
# ggmap::register_google(key = api)
# ggmap::ggmap_credentials()
# 
# ggmap::geocode("Sydney, New South Wales", output = "all")

p_load(googleway)

## API keys for different APIs
googleway::set_key(api, api = "geocode")
googleway::set_key(api, api = "map")
# googleway::google_keys()

# temp <- googleway::google_geocode("Sydney, New South Wales")

# temp$results$address_components
# temp$results$formatted_address
# temp$results$geometry
# temp$results$geometry$location_type
# temp$results$place_id
# temp$results$types

# loc <- googleway::geocode_coordinates(temp)
# 
# googleway::google_map() %>%
#   googleway::add_markers(data = loc)

place_full_name$status <- ""
place_full_name$location_type <- ""
place_full_name$formatted_address <- ""
place_full_name$ext_lat <- numeric(length = nrow(place_full_name))
place_full_name$ext_lon <- numeric(length = nrow(place_full_name))

place_full_name <- readRDS(file = "./data/Twitter/clean/place_full_name.rds")

slice(place_full_name, 2128:2130)

for (i in 2129:nrow(place_full_name)) {
  temp <- googleway::google_geocode(address = place_full_name$place_full_name[i], key = api)
  
  if (temp$status == "ZERO_RESULTS") {
    
    place_full_name$status[i] <- temp$status
    
  } else {
    
    place_full_name$status[i] <- temp$status
    place_full_name$location_type[i] <- temp$results$geometry$location_type
    place_full_name$formatted_address[i] <- temp$results$formatted_address
    place_full_name$ext_lat[i] <- temp$results$geometry$location$lat
    place_full_name$ext_lon[i] <- temp$results$geometry$location$lng
    
  }
  
  Sys.sleep(1)
}

# saveRDS(place_full_name, file = "./data/Twitter/clean/place_full_name.rds")
rm(api)

# !!!results are in !!!
# place_full_name_google.rds