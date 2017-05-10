# georefum
This is an R package for spatial linking of survey data with German Census 2011 and environmental noise data. It can be used for illustrative purposes but also for your own survey and coordinates data. All routines are implemented in compliance with German data protections legislations as described in Schweers et al. 2016 (http://dx.doi.org/10.1080/15420353.2015.1100152). However, use it at your own risk.

## Installation
Install the 'georefum' package from GitHub:

~~~{r}
devtools::install_github("stefmue/georefum")
~~~

This may take a while as the package contains large data. Therefore, it is not in compliance with CRAN.

## cdr_*()
Functions that refer to procedures on data originating from the European Environment Information and Observation Network (EIONET) 
Central Data Repository (CDR). These data were collected according to the Environmental Noise Directive (2002/49/EG) of the
European Union. They (mostly) consist of single shapefiles containing attributes on road traffic noise, rail traffic noise, air traffic
noise and industry noise and are licensed under a CC-BY license. 

http://cdr.eionet.europa.eu/

## census_*()
Functions that refer to procedures on data originating from the German Census 2011. These are data that were collected according to the
2011 European Union census regulation (763/2008). These data aim to monitor basic demographic compositions of the population on a 
small spatial scale. For the case of Germany the data are available on 1 km²
aggregated grid cell attributes that extend the whole area of Germany.

https://www.zensus2011.de/
