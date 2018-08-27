rm(list = ls())
get_imconvert
install.packages('moveVis')
library(move)
library(moveVis)
library(magick)

setwd("~/Google Drive/Completed Projects/Egyptian Vulture/EGVU_Papers/EV_Migration/R_Code")


V = read.csv("EVAS.csv")
head(V)
summary(V)
data.frame(V)
V$DateTime <- as.POSIXct(strptime(V$DateTime, "%m/%d/%Y %H:%M", tz = "UTC"))

head(V$DateTime)
class(V$DateTime)

#Differentiating Individuals
indi_levels <- levels(V$ID)
indi_levels_n <- length(indi_levels)
for(i in 1:indi_levels_n){
  if(i == 1){
    indi_subset <- list(subset(V, ID == indi_levels[i]))
  }else{
    indi_subset <- c(indi_subset,list(subset(V,
                                             ID == indi_levels[i])))
  }
}
indi_names <- paste(indi_levels, collapse = ", ")

#Move-Class Object Creation
for(i in 1:length(indi_subset)){
  if(
    i == 1){ data_ani <- list(move(x=indi_subset[[i]]$Long,y=indi_subset[[i]]$Lat,
                                   time=indi_subset[[i]]$DateTime,
                                   proj=CRS("+proj=longlat +ellps=WGS84"),
                                   animal=indi_levels[i]))
  }else{
    data_ani[i] <- list(move(x=indi_subset[[i]]$Long,y=indi_subset[[i]]$Lat,
                             time=indi_subset[[i]]$DateTime,
                             proj=CRS("+proj=longlat +ellps=WGS84"),
                             animal=indi_levels[i]))}
}


#Get ImageMagick
conv_dir <- get_imconvert()

#OUTPUT Directory
out_dir <- "~/Google Drive/Completed Projects/Egyptian Vulture/EGVU_Papers/EV_Migration/R_Code"

img_title <- "Egyptian Vulture (Neophron percnopterus) migrations across three continents"
img_caption <- "August 2010-March 2017"
img_sub <- paste0("Buechley, Evan R.; Oppel, Steffen; Beatty, William S.; Nikolov, Stoyan C.; Dobrev, Vladimir; Arkumarev, Volen; Saravia, Victoria; Bougain, Clementine; Bounas, Anastasios; Kret, Elzbieta; Skartsi, Theodora; Aktay, Lale; Frehner, Ethan; Sekercioglu, ?agan H.")



animate_move(data_ani, out_dir, conv_dir = conv_dir, tail_elements = 40, tail_size = 2,
             frames_interval = .05, layer = "basemap", layer_dt = "basemap", map_elements = FALSE,
             paths_mode = "simple", img_title = img_title, paths_alpha = 0,
             img_sub = img_sub, log_level = 1)


help(memory.size)


memory.limit(size = 500000)
