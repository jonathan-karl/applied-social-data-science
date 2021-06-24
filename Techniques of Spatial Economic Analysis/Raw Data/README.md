# applied-social-data-science

In order to reproduce the analysis of this paper, data from the following sources is necessary to download.

1. Nightlight Luminosity Data (~90GB)
	- The analysis was run with VIIRS (V2) global data. The following files are needed for the analysis:
		- "VNL_v2_npp_201204-201212_global_vcmcfg_c202101211500.average.tif"
		- "VNL_v2_npp_2013_global_vcmcfg_c202101211500.average.tif"
		- "VNL_v2_npp_2014_global_vcmslcfg_c202101211500.average.tif"
		- "VNL_v2_npp_2015_global_vcmslcfg_c202101211500.average.tif"
		- "VNL_v2_npp_2016_global_vcmslcfg_c202101211500.average.tif"
		- "VNL_v2_npp_2017_global_vcmslcfg_c202101211500.average.tif"
	- (download [here](https://eogdata.mines.edu/products/vnl/))
	- The tif files should be saved in the pre-made folders. For instance "VNL_v2_npp_2017_global_vcmslcfg_c202101211500.average.tif" should be saved in "06-2017".

2. Administrative Boundaries (~300MB)
	- For each country, a shapefile with necessary administrative boundaries is necessary to run the analysis. Keep in mind that each shapefile is comprised of five files with the appendices cpg, dbf, prj, shp, shx. The following files are to be downloaded with all appendices.
		- Tanzania: gadm36_TZA_2
		- Uganda: gadm36_UGA_2
		- Zambia: gadm36_ZMB_2
		- Zimbabwe: gadm36_ZWE_2
		- Guinea: gadm36_GIN_3
		- Mali: gadm36_MLI_3
		- Liberia: gadm36_LBR_2
		- Sierra Leone: gadm36_SLE_3
		- South Africa: gadm36_ZAF_3
		- Namibia: gadm36_NAM_2
		- Kenya: gadm36_KEN_2
		- Ethiopia: gadm36_ETH_2
	- (download [here](https://gadm.org/download_country_v3.html))
	- The shapefiles should all simply be dropped in the folder "Shapefiles"


3. DHS geolocated survey data (~3GB)
	- To compute a classification of rural and urban areas, this study uses DHS data. For each country, just download the latest DHS survey (the geo-information are of interest)
		- Tanzania: 2016
		- Uganda: 2016
		- Zambia: 2018
		- Zimbabwe: 2015
		- Guinea: 2018
		- Mali: 2018
		- Liberia: 2020
		- Sierra Leone: 2019
		- South Africa: 2016
		- Namibia: 2013
		- Kenya: 2014
		- Ethiopia: 2016
	- (download [here](https://dhsprogram.com/data/available-datasets.cfm))
	- The data should be safed in the pre-made folders. 
	- Example: When downloading DHS data for Mali, the download will contain multiple subfolders including "MLGE7AFL". This folder contains the geo-information and should be safed in the folder "2018" which is saved in the folder "Mali".


4. GHS Population Data (~2GB)
	- To allow for weighing luminosity values, the GHS population dataset serves well. I recommend downloading the following:
		- Product: GHS-POP
		- Epoch: 2015
		- Resolution: 9 arcsec
		- Coordinate system: WGS84
	- The file "GHS_POP_E2015_GLOBE_R2019A_4326_9ss_V1_0.tif" should be dropped in the folder "Population"
