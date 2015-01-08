## Visualization in R

### Prerequisites and Class Info:

This module builds on the Machine Learning in R and Data Wrangling classes given in the first week. You should be comfortable writing R code to run linear regression, logistic regression, and clustering algorithms which were all taught in Machine Learning in R. You should also be comfortable using the table command, the apply family of functions (tapply, lapply, apply), the merge command, the split-apply-combine framework, and creating your own functions. These were taught in Data Wrangling. Please review all these concepts before class on Tuesday, especially if you are new to R.

The material covered will be very similar to last year. However, you're welcome to repeat, if you like! Some datasets, examples, and in-class problems will be different.

### Git Update:

Please update your git repository so that you have the most recent class materials.

### Data:

You will need the "flights.csv" dataset that you created in your pre-class assignment for Module 2, Data Wrangling. You will also need the "airports.csv" dataset which is available in the data directory of the github repository. Please make sure you have both of these ready to go.

### Installation Instructions:

Please run the following commands in an R console:

```
install.packages("ggplot2")
install.packages("maps")
install.packages("ggmap")
install.packages("mapproj")
```

### Assignment:

Run the following code. After each plot is produced, save it, and finally submit a document on Stellar containing the three plots.

```
library(ggplot2)
ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point()
```
```
library(maps)
italy = map_data("italy")
ggplot(italy, aes(x = long, y = lat, group = group)) + geom_polygon()
```
```
library(ggmap)
MIT = get_map(location = "Massachusetts Institute of Technology", zoom = 15)
ggmap(MIT)
```

### Questions?

Please email Angie King (aking10@mit.edu).
