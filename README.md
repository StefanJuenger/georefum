# georefum
This is an R package. Currently, it is under heavy, heavy development. So please do not expect a finished product. Especially the 
documentation is lacking relevant information. But it is planned to deliver a stable version by February 2017. So stay tuned!

## Installation
Install the 'georefum' package from GitHub:

~~~{r}
devtools::install_github("stefmue/georefum")
~~~

This may take a while as the package contains large data. Therefore, it is not in compliance with CRAN.

## cdr_*()
Functions that refer to procedures on data originating from the European Environment Information and Observation Network (EIONET) 
Central Data Repository (CDR). These are data that were collected according to the Environmental Noise Directive (2002/49/EG) of the
European Union. They (mostly) consist of single shapefiles containing attributes on road traffic noise, rail traffic noise, air traffic
noise and industry noise and are licensed under a CC-BY license. 

http://cdr.eionet.europa.eu/

## census_*()
Functions that refer to procedures on data originating from the German Census 2011. These are data that were collected according to the
2011 European Union census regulation (763/2008). These data aim to monitor basic demographic compositions of the population on a 
small spatial scale. For the case of Germany the data are available on 1 km²
aggregated grid cell attributes that extend the whole area of Germany.

https://www.zensus2011.de/
