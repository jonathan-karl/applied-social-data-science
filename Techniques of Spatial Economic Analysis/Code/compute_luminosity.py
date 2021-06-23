# import necessary packages to work with spatial data in Python
import os
import gc
import fiona, rasterio
import geopandas as gpd
from rasterio.plot import show
import matplotlib.pyplot as plt
import rasterio.plot as rplt
from rasterio.features import rasterize
import rasterstats
from rasterstats import zonal_stats, point_query
import pandas as pd
import numpy as np

# Input path
path1 = "/XUsers/Jonathan/OneDrive - London School of Economics/GY460 - Spatial Economic Analysis/Summative Assessment/"
path2 = "/Users/antonboycenko/Desktop/Jonathan/"
path3 = "/Volumes/T7_Jonathan/GY460/"
if os.path.isdir(path1)==True:
    path = path1
elif os.path.isdir(path2)==True:
    path = path2
elif os.path.isdir(path3)==True:
    path = path3
else:
    print("none of the paths are valid")

os.chdir(path)
print("Path Set to: "+path)

# Set up paths for luminosity data, shapefiles, and data exports
path_lum = path+"Raw Data/Luminosity/"
path_shapefiles = path+"Raw Data/Shapefiles/"
path_export = "/Users/Jonathan/OneDrive - London School of Economics/GY460 - Spatial Economic Analysis/Summative Assessment/Data Exports/"
path_pop = path+"Raw Data/Population/"

# Set up dictionaries for countries and luminosity files
shapefiles = {"NGA": "Nigeria",\
              "BEN": "Benin",\
              "GIN": "Guinea",\
              "MLI": "Mali",\
              "LBR": "Liberia",\
              "SLE": "Sierra Leone",\
              "UGA": "Uganda",\
              "TZA": "Tanzania",\
              "RWA": "Rwanda",\
              "ZWE": "Zimbabwe",\
              "ZMB": "Zambia",\
              "AGO": "Angola",\
              "NAM": "Namibia",\
              "ZAF": "South Africa",\
              "KEN": "Kenya",\
              "ETH": "Ethiopia"}

admin_levels = {"NGA": ["NAME_2","2"],\
                "BEN": ["NAME_2", "2"],\
                "GIN": ["NAME_3", "3"],\
                "MLI": ["Name_3", "3"],\
                "LBR": ["NAME_3", "3"],\
                "SLE": ["NAME_3", "3"],\
                "UGA": ["NAME_2", "2"],\
                "TZA": ["NAME_2", "2"],\
                "RWA": ["NAME_2", "2"],\
                "ZWE": ["NAME_2", "2"],\
                "ZMB": ["NAME_2", "2"],\
                "AGO": ["NAME_2", "2"],\
                "NAM": ["NAME_2", "2"],\
                "ZAF": ["NAME_3", "3"],\
                "KEN": ["NAME_2", "2"],\
                "ETH": ["NAME_2", "2"]}

projections = {"NGA": "26392",\
               "BEN": "32631",\
               "GIN": "3462",\
               "MLI": "32630",\
               "LBR": "32629",\
               "SLE": "32629",\
               "UGA": "32735",\
               "TZA": "32739",\
               "RWA": "4210",\
               "ZWE": "32737",\
               "ZMB": "32737",\
               "AGO": "9159",\
               "NAM": "29333",\
               "ZAF": "22293",\
               "KEN": "32737",\
               "ETH": "32637"}

lightsdict = {"06-2012": "VNL_v2_npp_201204-201212_global_vcmcfg_c202101211500.average.tif",\
             "06-2013": "VNL_v2_npp_2013_global_vcmcfg_c202101211500.average.tif",\
             "06-2014": "VNL_v2_npp_2014_global_vcmslcfg_c202101211500.average.tif",\
             "06-2015": "VNL_v2_npp_2015_global_vcmslcfg_c202101211500.average.tif",\
             "06-2016": "VNL_v2_npp_2016_global_vcmslcfg_c202101211500.average.tif",\
             "06-2017": "VNL_v2_npp_2017_global_vcmslcfg_c202101211500.average.tif"}


def zonalstats_luminosity(shp_dict, project_dict, adm_level_dict, luminosity_dict):
    '''Take two arguments .......


    '''
    for key, country_name in shp_dict.items():
        print("Start with: "+country_name)
        # Set admin level
        for gov, level in adm_level_dict.items():
            if gov == key:
                admin_level = level[0]
                admin_number = level[1]
                print(country_name+" admin level: "+admin_level)

        # Read shapefile, adjust projection and export for luminosity analysis
        country = gpd.read_file(path_shapefiles+"gadm36_"+key+"_"+admin_number+"_rural_urban.shp")
        for zone, code in projections.items():
            if zone == key:
                country = country.to_crs('epsg:'+code)
                print(country_name+ " crs code: "+code)
        country['Area'] = country['geometry'].area/10**6
        # Count rows (for later when assembling the dataframe)
        print("Moin")
        nb_rows = country[admin_level].count()

        # Revert projection (to WGS 84, i.e. luminosity raster) and Export shp to make useable for analysis
        country = country.to_crs('epsg:4326')

        # Compute Population Statistics for weighting later
        zs = zonal_stats(path_shapefiles+"gadm36_"+key+"_"+admin_number+"_rural_urban.shp",
                 path_pop+"GHS_POP_E2015_GLOBE_R2019A_4326_9ss_V1_0.tif",
                 geojson_out=True,
                 stats=["sum"])

        population = []
        for i in range(len(zs)):
            one_district = zs[i]
            district_properties = one_district['properties']
            sum_temp = district_properties["sum"]
            if sum_temp == None:
                population.append(0)
            else:
                population.append(sum_temp)


        population_rounded = [round(district,0) for district in population]
        country["Population"] = population_rounded

        country.to_file(path_shapefiles+"/gadm36_"+key+"_"+admin_number+"_rural_urban_area_pop.shp")

        ## Analyse the luminosity for every adm2 district
        for time, file in luminosity_dict.items():
            print(time)

            #if os.path.isfile(path_export+country_name+"/"+key+"_"+time+"_lum.csv") == True:
            #    print(country_name+"/"+key+"_"+time+"_lum.csv --> Already exists.")
            #    continue

            with rasterio.open(path_lum+time+"/"+file) as src:
                transform = src.transform
                array = src.read(1)

            zs = zonal_stats(path_shapefiles+"gadm36_"+key+"_"+admin_number+"_rural_urban_area_pop.shp",
                             array,
                             affine=transform,
                             geojson_out=True,
                             stats=["mean", "min", "max", "sum", "count", "std"])

            dict =[]
            for i in range(nb_rows):
                one_district = zs[i]
                sublist = one_district['properties']
                sublist2 = {k: sublist[k] for k in (admin_level, "Area", "Population", "r_u", "mean", "min", "max", "sum")}
                dict.append(sublist2)
                df = pd.DataFrame.from_dict(dict, orient='columns', dtype=None, columns=None)
                df.to_csv(path_export+country_name+"/"+key+"_"+time+"_lum.csv")

        # Delete objects that crowd the memory
        del src
        del array
        del transform
        gc.collect()

        print("Done with: "+country_name)



# Execute function
#zonalstats_luminosity(shapefiles, projections, admin_levels, lightsdict)
print("\nLuminosity data processed. All Done.")
