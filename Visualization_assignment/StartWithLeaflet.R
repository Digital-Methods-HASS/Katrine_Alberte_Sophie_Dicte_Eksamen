###   GETTING STARTED WITH LEAFLET

# Try to work through down this script, observing what happens in the plotting pane. There are three
# initial example exercises, followed by a few questions and 5 tasks. 

# Review favorite backgrounds in:
# https://leaflet-extras.github.io/leaflet-providers/preview/
# beware that some need extra options specified

# To install Leaflet package, run this command at your R prompt:
#install.packages("leaflet")
#install.packages("htmlwidget")

# Activate the library
library(tidyverse)
library(leaflet)
library(htmlwidgets) # not essential, only needed for saving the map as .html

########## Example 1: create a Leaflet map of Europe with addAwesomeMarkers() 

# Learn to create a map by plotting three point markers, called Robin, Jakub and Jannes.

# First, create labels for your points
popup = c("Robin", "Jakub", "Jannes")

# Next, you create a Leaflet map with these basic steps: 
# call the leaflet() function and pipe in some background maps ("tiles"), 
# and then addMarker() function with longitude and latitude.
# Run the pipeline below to see the result:
leaflet() %>%                                 # create a map widget by calling the leaflet library
  addProviderTiles("Esri.WorldPhysical") %>%  # add Esri World Physical map tiles explicitly
  addAwesomeMarkers(lng = c(-3, 23, 11),      # add point markers specified with longitude for 3 points
                    lat = c(52, 53, 49),      # and latitude for 3 points (coordinates fall in EU)
                    popup = popup)            # specify labels for points, which will appear if you click on the point in the map

########### Example 2: create a Leaflet map of Sydney with the setView() function 

# Note that there are no points or markers below, just background tiles. setView() function
# alone helps you focus and zoom the map in a particular area of the world.

# Now we are in Sydney
leaflet() %>%
  addTiles() %>%                              # add default OpenStreetMap map tiles
  addProviderTiles("Esri.WorldImagery",       # add custom Esri World Physical map tiles
                   options = providerTileOptions(opacity=0.5)) %>%     # make the Esri tile transparent
  setView(lng =56.17304819452666, lat = 10.206537980689244, zoom = 10)              # set the location of the map 
# Question 1: What is the order of longitude and latitude in the setView() function?
56.17304819452666, 10.206537980689244
56.172869,10.2038772
# Now let's go back to Europe again
# When the map defined below renders, click the box in top right corner
# in your map Viewer to select between different background layers

leaflet() %>% 
  addTiles() %>% 
  setView( lng = 2.34, lat = 48.85, zoom = 5 ) %>%  # let's use setView to navigate to our area
  addProviderTiles("Esri.WorldPhysical", group = "Physical") %>%  # add physical background
  addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%  # add satellite image
  addProviderTiles("MtbMap", group = "Geo") %>%               # add geomorphic units map
    
addLayersControl(                                 # we are adding layers control to the maps
  baseGroups = c("Geo","Aerial", "Physical"),
  options = layersControlOptions(collapsed = F))  # replace T with F and back and run it

# Question 2: How does the map above change if you replace the T 
# in the last line of code above with F?



########### Example 3:  SYDNEY HARBOUR DISPLAY WITH 11 LAYERS

# Let's create a map with more background layers that allows
# interactive selection between multiple layers. This can be useful
# if you want to rendering historical maps illustrating change over time

# The chunk below sets the location and zoom level of your map
leaflet() %>% 
  setView(151.2339084, -33.85089, zoom = 13) %>%
  addTiles()  # checking I am in the right area

# Bring in a choice of Esri background layers  

# Create a basic base map
l_aus <- leaflet() %>%   # assign the base location to an object
  setView(151.2339084, -33.85089, zoom = 13)

# Now, prepare to select backgrounds by grabbing their names
esri <- grep("^Esri", providers, value = TRUE)

# Select backgrounds from among provider tiles. To view the options, 
# go to https://leaflet-extras.github.io/leaflet-providers/preview/
# Run the following three lines together!
for (provider in esri) {
  l_aus <- l_aus %>% addProviderTiles(provider, group = provider)
}

# Map of Sydney, NSW, Australia
# We make a layered map out of the components above and write it to 
# an object called AUSmap
AUSmap <- l_aus %>%
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
AUSmap

########## SAVE THE FINAL PRODUCT

# Save map as a html document (optional, replacement of pushing the export button)
# only works in root

# We will also need this widget to make pretty maps:

saveWidget(AUSmap, "AUSmap.html", selfcontained = TRUE)

########################################  TASK NUMBER ONE


# Task 1: Create a Danish equivalent of AUSmap with Esri layers, 
# but call it DANmap. You will need it layer as a background for Danish data points.

# Create a basic base map
l_dk <- leaflet() %>%   # assign the base location to an object
  setView(10.2029623,56.1724346, zoom = 13)


# Now, prepare to select backgrounds by grabbing their names
esri <- grep("^Esri", providers, value = TRUE)

# Select backgrounds from among provider tiles. To view the options, 
# go to https://leaflet-extras.github.io/leaflet-providers/preview/
# Run the following three lines together!
for (provider in esri) {
  l_dk <- l_dk %>% addProviderTiles(provider, group = provider)
}

# Map of Sydney, NSW, Australia
# We make a layered map out of the components above and write it to 
# an object called AUSmap
DKmap <- l_dk %>%
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
DKmap

########## SAVE THE FINAL PRODUCT

# Save map as a html document (optional, replacement of pushing the export button)
# only works in root

# We will also need this widget to make pretty maps:

saveWidget(AUSmap, "AUSmap.html", selfcontained = TRUE)

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

# Libraries¨
install.packages("googlesheets4")
library(tidyverse)
library(googlesheets4)
library(leaflet)

# If you experience difficulty with your read_sheet() function (it is erroring out), 
# uncomment and run the following function:
gs4_deauth()  # run this line and then rerun the read_sheet() function below

# Read in the Google sheet you've edited
places <- read_sheet("https://docs.google.com/spreadsheets/d/1PlxsPElZML8LZKyXbqdAYeQCDIvDps2McZx1cTVWSzI/edit#gid=124710918",
                     col_types = "cccnncnc",   # check that you have the right number and type of columns
                     range = "DAM2025")  # select the correct worksheet name

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

######################################## TASK THREE

# Task 3: Can you cluster the points in Leaflet?
# Hint: Google "clustering options in Leaflet in R"

# Solution

######################################## TASK FOUR

# Task 4: Look at the two maps (with and without clustering) and consider what
# each is good for and what not.

# Your brief answer

######################################## TASK FIVE

# Task 5: Find out how to display the notes and classifications column in the map. 
# Hint: Check online help in sites such as 
# https://r-charts.com/spatial/interactive-maps-leaflet/#popup

# Solution

######################################## CONGRATULATIONS - YOUR ARE DONE :)