# Flyability Advisor

This is a prototype version of a suite of tools I'm working on to assist freeflight pilots in making decisions about when and where to go flying.

## Motivation
Unless one has either a large amount of localized experience or a deep understanding of how to quickly analyze macro and micro meteorological data, it can be cognitively taxing to determine when and where to go paragliding.

There are a number of factors contributing to this problem, including:
* The conditions used to determine when/where to fly differ based on flying site, pilot skill level and desired type of flying (thermalling, ridge soaring, XC)
* There are various sources of input data that are situationally valid and the data needed is often not available in a single place for a comprehensive analysis
* Knowledge of which sources of data work where and when and how to interpret the data is shared among pilots in unstructured and often undiscoverable ways (word of mouth, a blurb on a personal website, a message in a chat that only retains X days of history, etc.)
* These local esoteric heuristics can be difficult to replicate and validate quantitatively


## Requirements
### Inputs
#### Paragliding launches
* Name
* Alternative names
* Location (lat, lon)
* Timezone
* Elevation
* Rating requirement
* Glide to closest LZ
* Airspace ceiling
* Links
  * Site guides
  * Track logs
    * X-contest
    * ParaglidingForum
    * Other

#### Forecast data
##### Types of data
For every paragliding launch, we’d like to import the following types of data from various forecasting models:
* Wind speed (Surface - 18k’ MSL)
* Wind direction (Surface - 18k’ MSL)
* Temp (Surface - 18k’ MSL)
* Cloud cover
* Precipitation type and amount
* Dew point temp (Surface - 18k’ MSL)

##### Sources of data
Note: The MeteoMate gem (currently WIP) will be used to fetch forecast data.
* **NOAA digital forecast** - [National Weather Service - Western Region Headquarters](https://www.wrh.noaa.gov/forecast/wxtables/) - Link is for western region.
* **National Digital Forecast Database (NDFD**) [NDFD](https://www.weather.gov/mdl/ndfd_home) - NWS offices work in collaboration with NCEP to create a seamless mosaic of digital forecasts.
  * GRIB data format for grid data [NDFD Grid Data Access](https://www.weather.gov/mdl/ndfd_data_grid)
  * REST data format for point forecasts [National Digital Forecast Database XML/REST Service - NOAA’s National Weather Service](https://graphical.weather.gov/xml/rest.php)

#### Site flyability model data
User contributed site models for determining flyability. There can be multiple models per site.

* Flight type (Ridge soaring, thermalling, XC)
* Valid hours (military format: 00 - 23)
* No-go constraints:
  * Precipitation
  * Cloud cover
* Conditions:
  * Valid wind direction on launch
  * Valid wind speeds on launch
  * Thermalling & XC flight types
    * Above launch minimum (often 2k or higher)
    * Buoyancy/Sheer minimum (often 4 or higher)
    * Avg. wind speed within the boundary layer (ground through thermal tops) maximum (10mph for best, 14mph for good, etc.)
    * Radius to seek for these conditions to be met

#### Reports of flyability
* Leonardo server track logs
* Manually input data from users

### Outputs
#### Calculated data
For every paragliding launch, we’d like to calculate the following data once per hour for each source of forecast data available for that hour:
* **Thermal ceiling** - the lower of the height at which the thermal stops rising or the cloud level.
* **Soaring ceiling** - We stop going up when the thermal is rising just fast enough to offset our sink. We can use the height at which the temp difference between the thermal and surrounding air is about 2 degrees F. This # will be an estimate of the max altitude one could reach starting at launch height.
* **Above launch** - The difference between soaring ceiling and launch elevation. Does not account for ridge lift.
* **Thermal index** - the maximum difference in temp between the rising pocket of air and the surrounding air. The difference in temperature is responsible for the buoyancy of the thermal and larger differences mean faster rising thermals. Values >= 10F are typically shareable and >= 20 could indicate rowdy thermals.
* **Buoyancy/sheer ratio** - [BLIPMAP Parameter Information](http://www.drjack.info/BLIP/INFO/parameter_details.html#BS_Ratio)
### Site flyability scores
These will be calculated based on the site flyablity models for each site.

## Current work

* [MeteoMate](https://github.com/pocketIlmatto/meteo_mate): A ruby gem that abstracts fetching, caching and parsing weather forecast data from various forecast models (GFS, HRRR, NAM, etc.)

## Future work
* Converting this repo to use React & Redux on the front end.. or possibly splitting the frontend out completely and refashioning this as API only with the following responsiblities: managing paragliding-site specific data and user flyablilty models
* Adding alerting (email and sms initially) - either as a separate service or as part of this repo

## Running locally

To bootstrap the database with some initial flying sites data after cloning the repo (and installing ruby, rvm, postgres, etc.):

```sh
bundle install
rake db:create; rake db:migrate; rake db:seed;
rake fetch_forecasts
rake process_into_hourly_forecasts
rake generate_hourly_flyability_scores
```