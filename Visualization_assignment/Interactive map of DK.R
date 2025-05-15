#Homewwork assignment
library(tidyverse)
library(htmlwidgets)
library(leaflet)
# The chunk below sets the location and zoom level of your map
leaflet() %>% 
  setView(10.2029623, 56.1724346, zoom = 10) %>%
  addTiles()  # checking I am in the right area


# Bring in a choice of Esri background layers  

# Create a basic base map
l_dk <- leaflet() %>%   # assign the base location to an object
  setView(10.2029623, 56.1724346, zoom = 10)

# Now, prepare to select backgrounds by grabbing their names
esri <- grep("^Esri", providers, value = TRUE)

# Select backgrounds from among provider tiles. To view the options, 
# go to https://leaflet-extras.github.io/leaflet-providers/preview/
# Run the following three lines together!
for (provider in esri) {
  l_dk <- l_dk %>% addProviderTiles(provider, group = provider)
}
l_dk
# We make a layered map out of the components above and write it to 
# an object called DANmap
DANmap <- l_dk %>%
  addLayersControl(baseGroups = names(esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                        }") %>% 
  addControl("", position = "topright")

# run this to see your product
DANmap

########## SAVE THE FINAL PRODUCT

# Save map as a html document (optional, replacement of pushing the export button)
# only works in root

# We will also need this widget to make pretty maps:

saveWidget(DANmap, "DANmap.html", selfcontained = TRUE)


########################################
######################################## ADD DATA TO LEAFLET

# Before you can proceed to Task 2, you need to learn about coordinate creation. 
# In this section you will manually create machine-readable spatial
# data from GoogleMaps, load these into R, and display them in Leaflet with addMarkers(): 

### First, go to https://bit.ly/CreateCoordinates1
### Enter the coordinates of your favorite leisure places in Denmark 
# extracting them from the URL in googlemaps, adding name and type of monument.
# Remember to copy the coordinates as a string, as just two decimal numbers separated by comma. 

# Caveats: Do NOT edit the grey columns! They populate automatically!

### Second, read the sheet into R. You will need gmail login information. 
# IMPORTANT: watch the console, it may ask you to authenticate or put in the number 
# that corresponds to the account you wish to use.
install.packages("googlesheets4")
# Libraries
library(tidyverse)
library(googlesheets4)
library(leaflet)

# If you experience difficulty with your read_sheet() function (it is erroring out), 
# uncomment and run the following function:
gs4_deauth()  # run this line and then rerun the read_sheet() function below

# Read in the Google sheet you've edited
places <- read_sheet("https://docs.google.com/spreadsheets/d/1U6JgrE14NKu6bIa6hlHcf5dc82Cv2WKQZ4WjiotySUs/edit?usp=sharing",
                     col_types = "cccnncnc",   # check that you have the right number and type of columns
                     range = "DK2025")  # select the correct worksheet name

glimpse(places)  
# Question 3: are the Latitude and Longitude columns present? 
# Do they contain numeric decimal degrees?



# If your coordinates look good, see how you can use addMarkers() function to
# load them in a basic map. Run the lines below and check: are any points missing? Why?
leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = paste(places$Description, "<br>", places$Type))
# Now that you have learned how to load points from a googlesheet to a basic leaflet map, 
# apply the know-how to YOUR DANmap object. 

########################################
######################################## TASK TWO


# Task 2: Read in the googlesheet data you and your colleagues created
# into your DANmap object (with 11 background layers you created in Task 1).

# Solution
DANmap%>%
  addLayersControl(baseGroups = names(esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                        }") %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = paste(places$Description, "<br>", places$Type)) %>% 
  addControl("", position = "topright")

DANmap
######################################## TASK THREE

# Task 3: Can you cluster the points in Leaflet?
# Hint: Google "clustering options in Leaflet in R"

# Solution
leaflet(places) %>% 
  addTiles() %>% 
  addMarkers(clusterOptions = markerClusterOptions())

######################################## TASK FOUR

# Task 4: Look at the two maps (with and without clustering) and consider what
# each is good for and what not.

# Your brief answer
#Without you are able to see all the places spread on the map, but with clustering you can tell in which areas that there are the most places. It gives a better overview with the clustering, but you can go more in depth without.

######################################## TASK FIVE

# Task 5: Find out how to display the notes and classifications column in the map. 
# Hint: Check online help in sites such as 
# https://r-charts.com/spatial/interactive-maps-leaflet/#popup

# Solution
answer5 <- leaflet() %>% 
  addTiles() %>% 
  setView(lng = 10.2036565, lat = 56.1714117, zoom = 10) %>% 
  addMarkers(lng = 10.2036565, lat = 56.1714117)

answer5

#This was one of the many solutions availible
######################################## CONGRATULATIONS - YOUR ARE DONE :)

