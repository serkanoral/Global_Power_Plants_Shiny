POWER PLANTS CAPACITIES OVER THE GLOBE - 2018

This is my first R shiny application, so any feed back is so valuable for me.
This shiny application is about power house capacities in the globe.
I didn't get into capacity usage, so it's only the capacities.
It's a global matter to have more green energy source, although the investment decisions are given by governments. So I try to present the matter on both perspectives.

Global Tab

I use three plots first map is global distribution of power houses. 
I created three segments and fuel type to filter down more detailed view.
There is one static plot, which shows the total capacity by fuel type.
The last one show top 15 countries has the most percentage of selected fuel type in the selected country.

Country Tab

The map here is according to the country, which may let you see more details.
I have two plots which are identical to first page. 

About the Data

  - `country_long` (text): longer form of the country designation
	- `name` (text): name or title of the power plant, generally in Romanized form
	- `capacity_mw` (number): electrical generating capacity in megawatts
	- `latitude` (number): geolocation in decimal degrees; WGS84 (EPSG:4326)
	- `longitude` (number): geolocation in decimal degrees; WGS84 (EPSG:4326)
	- `primary_fuel` (text): energy source used in primary electricity generation or export

Here is the app. https://serkanoral.shinyapps.io/Power_Plants_2018/
The data can be downloaded from https://datasets.wri.org/dataset/globalpowerplantdatabase .

