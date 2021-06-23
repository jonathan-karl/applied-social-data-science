
##### This file classifies administrative areas in each country as either rural or urban
##### Author: Jonathan Karl


# Set up function to decide if polygons are predominantly urban or rural to distinguish growth in rural and urban areas
compute_rural_urban_shp <- function(path_dhs = NULL, path_shp = NULL, admin_level = "NAME_X", path_export = NULL, to_print = NULL){
  
  #Read in Data of survey responses
  DHS_shp <- readOGR(path_dhs)
  coordinates_dhs <- DHS_shp@coords
  rural_urban_indicator <- DHS_shp@data$URBAN_RURA
  
  # Cross Check with Shapefile
  shp <- readOGR(path_shp)
  
  df_rural_urban <- data.frame(district = shp@data[,admin_level], rural = 0, urban = 0)
  all <- NULL
  for(poly in 1:length(shp@polygons)){
    for(point in 1:nrow(coordinates_dhs)){
      
      no_polys <- length(shp@polygons[[poly]]@Polygons)
      # Check for each polygons all points and if they are in the polygons (returns 0 or 1)
      for(uno in 1:no_polys){
        indicator_in_out <- point.in.polygon(coordinates_dhs[point, 1],
                                             coordinates_dhs[point, 2],
                                             shp@polygons[[poly]]@Polygons[[uno]]@coords[,1],
                                             shp@polygons[[poly]]@Polygons[[uno]]@coords[,2])
        
        # Compute if point is urban or rural
        temp_rural_urban <- rural_urban_indicator[point] 
        
        all <- c(all, indicator_in_out)
        # If point in polygon X and urban, increase count of urban column by 1 (same for rural)
        if(indicator_in_out == 1 & temp_rural_urban == "U"){
          df_rural_urban[poly,"urban"] <- df_rural_urban[poly,"urban"] + 1
        }
        if(indicator_in_out == 1 & temp_rural_urban == "R"){
          df_rural_urban[poly,"rural"] <- df_rural_urban[poly,"rural"] + 1
        }
      }
    }
  }
  
  # Display unmatched polygons (those are likely rural (DHS surveys are mostly focussed on urban and populated areas))
  empty_polygons <- apply(df_rural_urban[,2:3], FUN = sum, MARGIN = 1)
  print(sum(empty_polygons == 0))
  temp_decision_aid <- apply(df_rural_urban[,2:3], FUN = which.max, MARGIN = 1)
  df_rural_urban$r_u <- ifelse(temp_decision_aid == 1, "R", "U")
  shp@data$r_u <- ifelse(temp_decision_aid == 1, "R", "U")
  
  writeOGR(shp, path_export, layer = "admin_boundaries",driver = "ESRI Shapefile")
  
  # Print message of completion
  if(!is.null(to_print)){
    print(paste0("Done with: ", to_print))
  }
  
  return(df_rural_urban)
}


## Execute function for all countries

# Pair I
 Tanzania
df_TZA_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Tanzania/2016/TZGE7AFL/TZGE7AFL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_TZA_2.shp", admin_level = "NAME_2", path_export = "../Raw Data/Shapefiles/gadm36_TZA_2_rural_urban.shp", to_print = "Tanzania")
# Uganda
df_UGA_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Uganda/2016/UGGE7AFL/UGGE7AFL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_UGA_2.shp", admin_level = "NAME_2", path_export = "../Raw Data/Shapefiles/gadm36_UGA_2_rural_urban.shp", to_print = "Uganda")

# Pair II
# Zimbabwe
df_ZWE_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Zimbabwe/2015/ZWGE72FL/ZWGE72FL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_ZWE_2.shp", admin_level = "NAME_2", path_export = "../Raw Data/Shapefiles/gadm36_ZWE_2_rural_urban.shp", to_print = "Zimbabwe")
# Zambia
df_UGA_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Zambia/2018/ZMGE71FL/ZMGE71FL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_ZMB_2.shp", admin_level = "NAME_2", path_export = "../Raw Data/Shapefiles/gadm36_ZMB_2_rural_urban.shp", to_print = "Zimbabwe")

# Pair III
 Sierra_Leone
df_SLE_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Sierra Leone/2019/SLGE7AFL/SLGE7AFL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_SLE_3.shp", admin_level = "NAME_3", path_export = "../Raw Data/Shapefiles/gadm36_SLE_3_rural_urban.shp", to_print = "Sierra Leone")
# Liberia
df_LBR_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Liberia/2020/LBGE7AFL/LBGE7AFL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_LBR_2.shp", admin_level = "NAME_2", path_export = "../Raw Data/Shapefiles/gadm36_LBR_2_rural_urban.shp", to_print = "Liberia")

# Pair IV
 Guinea
df_GIN_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Guinea/2018/GNGE71FL/GNGE71FL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_GIN_3.shp", admin_level = "NAME_3", path_export = "../Raw Data/Shapefiles/gadm36_GIN_3_rural_urban.shp", to_print = "Guinea")
# Mali
df_MLI_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Mali/2018/MLGE7AFL/MLGE7AFL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_MLI_3.shp", admin_level = "NAME_3", path_export = "../Raw Data/Shapefiles/gadm36_MLI_3_rural_urban.shp", to_print = "Mali")

# Pair V
 Angola
df_AGO_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Angola/2016/AOGE71FL/AOGE71FL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_AGO_2.shp", admin_level = "NAME_2", path_export = "../Raw Data/Shapefiles/gadm36_AGO_2_rural_urban.shp", to_print = "Angola")
# Namibia
df_NAM_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Namibia/2013/NMGE61FL/NMGE61FL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_NAM_2.shp", admin_level = "NAME_2", path_export = "../Raw Data/Shapefiles/gadm36_NAM_2_rural_urban.shp", to_print = "Namibia")
# South Africa
df_ZAF_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/South Africa/2016/ZAGE71FL/ZAGE71FL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_ZAF_3.shp", admin_level = "NAME_3", path_export = "../Raw Data/Shapefiles/gadm36_ZAF_3_rural_urban.shp", to_print = "South Africa")

# Pair VI
 Kenya
df_KEN_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Kenya/2014/KEGE71FL/KEGE71FL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_KEN_2.shp", admin_level = "NAME_2", path_export = "../Raw Data/Shapefiles/gadm36_KEN_2_rural_urban.shp", to_print = "Kenya")
# Ethiopia
df_ETH_rural_urban <- compute_rural_urban_shp(path_dhs = "../Raw Data/DHS/Ethiopia/2016/ETGE71FL/ETGE71FL.shp", path_shp = "../Raw #Data/Shapefiles/gadm36_ETH_2.shp", admin_level = "NAME_2", path_export = "../Raw Data/Shapefiles/gadm36_ETH_2_rural_urban.shp", to_print = "Ethiopia")


