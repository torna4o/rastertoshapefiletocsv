# rastertoshapefiletocsv

Remote sensing raster values to shapefiles then creating .csv output of these data

# The aim of the repository

Here, we have rasters of some satellite remote sensing images, such as Sentinel-2 MSI. We have shapefiles for our region of interests and we want to extract raster values in those regions, such as mean value of pixels in satellite bands. Then, we want to write all of them in a one single .csv file to later do some other works in possibly other softwares as well, like Microsoft Excel.

# Description

Most of the required explanation is already written in the core code file. What you need to do is putting specific satellite remote sensing GeoTIFFs in a certain folder. You should work on one type of a satellite in a given operation with this code, as it wants to put all values on the same columns of wavelengths etc. Shapefiles might be in any other place but as in all of my codes, locations are explicitly written rather than working directory setting.

# Limitations

As said, one satellite type in a single folder for this script to work smoothly. Additionally, we are getting summary of shapefile covered raster values, such as mean. You can change it to medians or standard deviations or such, but in this setting it will perform only fun = "type of the data summary" way here.
Moreover, you can do this process with multiple shapefiles (regions) easily, but if you want to collect all these in a one big data frame there is a one line of code you need to use while working on, which is also illustrated in the code file itself.

