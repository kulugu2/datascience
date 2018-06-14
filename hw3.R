getwd()
a <- read.table("/home/jeff/study/datascience/hw3/auto-mpg.data")
head(a)
str(a)
colnames(a) <- c("mpg", "cylinders", "displacement", 
                 "horsepower", "weight", "acceleration", "model_year",
                 "origin", "car_name")
typeof(a$horsepower)
a$horsepower <- as.character.factor(a$horsepower)
which(a$horsepower == '?')
which(a[,] == '?')
a$horsepower[which(a$horsepower == '?')]  = NA
which(a$horsepower == '?')
which(is.na(a$horsepower))
a$horsepower <- as.numeric(a$horsepower)
horsepoer.mean <- mean(a$horsepower , na.rm =T)
typeof((a$horsepower))
which(is.na(a$horsepower))
a$horsepower[which(is.na(a$horsepower))] = horsepoer.mean
which(is.na(a$horsepower))
library(corrplot)
cormat <- round(cor(a[0:7]), 2)
a[0:7]
corrplot(cormat, method='ellipse')
cormat
