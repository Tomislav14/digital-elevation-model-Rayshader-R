library(raster)
library(rayshader)
library(terra)
library(sf)
library(raster)
library(gifski)

# Specify the file path
file_path <- "your_path_to_file_dem.tif"

# Check if the file exists
if (file.exists(file_path)) {
  # Load the raster file
  localtif <- raster(file_path)
  
  # Convert it to a matrix
  elmat <- raster_to_matrix(localtif)
  
  # Plot the map
  elmat %>%
    sphere_shade(texture = "desert") %>%
    plot_map()
} else {
  cat("Error: File not found at specified path.\n")
}
#sphere_shade can shift the sun direction:
elmat %>%
  sphere_shade(sunangle = 45, texture = "desert") %>%
  plot_map()
#detect_water and add_water adds a water layer to the map:
elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  plot_map()
#And we can add a raytraced layer from that sun direction as well:
elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  add_shadow(ray_shade(elmat), 0.5) %>%
  plot_map()
#And here we add an ambient occlusion shadow layer, which models 
#lighting from atmospheric scattering:
elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  add_shadow(ray_shade(elmat), 0.5) %>%
  add_shadow(ambient_shade(elmat), 0) %>%
  plot_map()
#Rayshader also supports 3D mapping by passing a texture map (either external or one produced by rayshader) into the plot_3d function.
elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  add_shadow(ray_shade(elmat, zscale = 3), 0.5) %>%
  add_shadow(ambient_shade(elmat), 0) %>%
  plot_3d(elmat, zscale = 20, fov = 0, theta = -45, phi = 45,         # Adjust Angle Here
          windowsize = c(900, 900), zoom = 0.6, background = "grey10", #Define color
          water = TRUE, waterdepth = 30, wateralpha = 0.7, watercolor = "lightblue", #Change waterdepth and color
          waterlinecolor = "lightblue", waterlinealpha = 0.7, baseshape = "square")  # Change base shape here

Sys.sleep(0.2)
#Render movie
render_movie(filename = "Animation.gif", type = "orbit", 
             frames = 360, fps = 60, phi = 45, zoom = 0.6, theta = -45,
             width = 1920, height = 1080)
 
# Optional high quality Ray-tracing Render
render_highquality(lightintensity = 750, lightcolor = "antiquewhite", clear=TRUE)



