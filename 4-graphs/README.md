## Networks in R Pre-Assignment

## Git update

Please update your git repository to get the latest version of everything.

## Data setup

If you already have the file On_Time_On_Time_Performance_2014_9.csv (the September 2014 airline flight network), that is great. Simply copy it into the folder 4-graphs in the git repository.

If you don't already have this file, download http://www.transtats.bts.gov/Download/On_Time_On_Time_Performance_2014_9.zip and unzip it, saving On_Time_On_Time_Performance_2014_9.csv to the folder 4-graphs in the git repository.

## Assignment

First, start R and set your working directory to the 4-graphs folder of the git repository.

To verify your data is downloaded and located properly, please run the following in R (note that the data will take a small while to load):

```
dat <- read.csv("On_Time_On_Time_Performance_2014_9.csv", stringsAsFactors=FALSE)
nrow(dat)
length(unique(dat$Origin))
```

Next, install the igraph package in R and run some simple commands:

```
install.packages("igraph")
library(igraph)
set.seed(144)
max(betweenness(erdos.renyi.game(100, 0.5)))
```

Please submit the output of these two R snippits (3 total lines of output) in a .txt file on stellar.

## Questions?
Please email John Silberholz (josilber@mit.edu).