##################################################
##     ##     ##    ## ### ##     ##    ###     ##
#### #### ### ## ## ##  ## ## ### ## ### ## ### ##
#### #### ### ##   ### # # ## ### ## ### ## ### ##
#### #### ### ## ## ## ##  ##     ## ### ## ### ##
#### ####     ## ## ## ### ## ### ##    ###     ##
##################################################

# Script to extract raster values into something via buffer region / point region, then later writing these to a .csv file


### Part 0 -- Loading required packages and preparation

remove(list=ls())
library(sp)
library(raster)

### Part 1 -- Loading shapefiles and raster satellite GeoTIFF file

# Here how many shapefiles you want to get raster values in it totally up to you

buffer <- shapefile("C:/RSofENV/l8/buff.shp")
sampler <- shapefile("C:/RSofENV/l8/sampler.shp")

# The following lines get the names and locations of the .tif raster files to later automatically import them

rlist=list.files("C:/RSofENV/s2lvl2a", pattern="tif$",all.files=TRUE, full.names=TRUE) # Between "" put your folder of raster files
nlist=list.files("C:/RSofENV/s2lvl2a", pattern="tif$",all.files=TRUE, full.names=FALSE) # Between "" put your folder of raster files

# Automatic import of raster file to Global Environment

for ( k in 1:length(nlist)) {
  
 assign(paste0(nlist[k]), brick(rlist[k]), envir= .GlobalEnv)
 
}

### Part 2: From rasters, we will extract means values to the corresponding shapefiles

# First having a list of bricks of our tifs

liist <- mget(nlist)

# Reprojecting our shapefiles to the Coordinate Reference System of our tifs

buffer <- spTransform(buffer, crs(liist[[1]]))
sampler <- spTransform(sampler, crs(liist[[1]]))

# Automatically generating mean values for the regions your shapefiles covered from rasters

# As.data.frame converts what you get to the .csv friendly manner later you will need

for ( k in 1:length(nlist)) {
  
  assign(paste0(nlist[k], "mn"), as.data.frame(extract(liist[[k]], buffer, fun=mean)), envir= .GlobalEnv)
  assign(paste0(nlist[k], "pt"), as.data.frame(extract(liist[[k]], sampler, fun=mean)), envir= .GlobalEnv)
  
}

### Part 3: Merging all mean values to their respective bigger data frame

# rbindlist function in data.table eases the combination of multiple data.frames with simply listing them in

library(data.table)

means <- rbindlist(mget(ls(pattern="mn$")))
means <- cbind(nlist, means) # Here we also put names to each row of mean values to be able to identify them

pointcentre <- rbindlist(mget(ls(pattern="pt$")))

# In the following command, we modify nlist list to be able to directly put different shapefile generated 
# data.frames into one big frame. If you don't want to merge different shapefiles data.frames, create another name list
# and later generate separate .csv file for the resultant separate merged data frame

nlist <- ls(pattern = "pt$") 
pointcentre <- cbind(nlist, pointcentre)

# As mentioned, the following line is for people who wants their separate shapefile data into a big data.frame

alldata <- rbind(means, pointcentre)

### Part 4 -- Writing these to a csv file
library(utils)
write.csv(alldata, file="C:/RSofENV/s2lvl2a/s2.csv")
