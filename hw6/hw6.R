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
head(a[1:8])
cormat <- round(cor(a[1:8]), 2)
a[1:8]
corrplot(cormat, method='ellipse')
cormat
summary(a)
plot(a[0:6])
installed.packages("ggplot2")
library(ggplot2)
ggplot(a, aes(x = horsepower, y=weight)) + geom_point()
ggplot(a, aes(x = weight, y=displacement)) + geom_point()
ggplot(a, aes(x = cylinders, y=acceleration)) + geom_point()
ggplot(a, aes(x = displacement, y=mpg)) + geom_point()
ggplot(a, aes(x = model_year, y=mpg)) + geom_point(aes(color = cylinders))
ggplot(a, aes(x = weight, y=mpg)) + geom_point(aes(color = cylinders))
ggplot(a, aes(x = horsepower, y=mpg)) + geom_point(aes(color = cylinders))
ggplot(a, aes(x = horsepower, y=mpg)) + geom_point(aes(color = displacement))
ggplot(a, aes(x = weight, y=mpg)) + geom_point(aes(color = displacement))
a1 <- a
a1$cylinders <- as.factor(a1$cylinders)
ggplot(a1, aes(x = cylinders, y=mpg)) + geom_boxplot()
ggplot(a1, aes(x = cylinders, y=weight)) + geom_boxplot()
boxplot(a$mpg)
which.max(a$mpg)
a2 <- a[1:6]
mod <- lm(mpg ~ ., data=a2)
cooksd <- cooks.distance(mod)
plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")
abline(h = 5*mean(cooksd, na.rm=T), col="red")
text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>5*mean(cooksd, na.rm=T),names(cooksd),""), col="red")  # add labels
influential <- as.numeric(names(cooksd)[(cooksd > 5*mean(cooksd, na.rm=T))])
head(a[influential, ])
summary(a)
a[influential, ]


library(caret)
library(np)
a <- a[1:8]
train.ind <- createDataPartition(a$mpg, p = 2/3, list = F)
train <- a[train.ind,]
test <- a[-train.ind,]
lr1 = lm(mpg ~ cylinders + horsepower + weight + displacement  + acceleration + model_year + origin, data = a)
summary(lr1)
lr2 = lm(mpg ~ cylinders + horsepower + weight + displacement  + acceleration + model_year + origin - 1, data = a)
summary(lr2)
lr3 = lm(mpg ~ cylinders + horsepower + weight + displacement  + acceleration , data = a)
summary(lr3)
lr4 = lm(mpg ~ cylinders + horsepower + weight + acceleration + model_year + origin, data = a)
summary(lr4)
lr5 = lm(mpg ~ cylinders + weight + displacement  + acceleration + model_year + origin, data = a)
summary(lr5)
loe = loess(mpg ~ cylinders + horsepower + weight + displacement  , data = a)
summary(loe)
loe2 = loess(mpg ~ cylinders + horsepower + weight + displacement  , data = a, span = 0.2)
summary(loe2)
loe3 = loess(mpg ~ cylinders + horsepower + weight + displacement  , data = a, span = 0.4)
summary(loe3)
loe4 = loess(mpg ~ cylinders + horsepower + weight + displacement  , data = a, span = 0.6)
summary(loe4)
loe5 = loess(mpg ~ cylinders + horsepower + weight + displacement  , data = a, span = 0.8)
summary(loe5)
loe6 = loess(mpg ~ cylinders + horsepower + weight + displacement  , data = a, span = 1.0)
summary(loe6)
loe7 = loess(mpg ~ cylinders + horsepower + weight + displacement  , data = a, span = 1.5)
summary(loe7)
loe8 = loess(mpg ~ cylinders + horsepower + weight + displacement  , data = a, span = 5.0)
summary(loe8)
gau.all <- npregbw(mpg ~ cylinders + horsepower + weight + displacement  + acceleration + model_year + origin, data = a,
                   regtype = 'll' )
summary(gau.all)
gau = npreg(mpg ~ cylinders + horsepower + weight + displacement  + acceleration + model_year + origin, data = a, 
            ckertype='gaussian', ckerorder=2)
gau.model <- npreg(bws = gau.all)
summary(gau.model)
lr1.predict <- predict(lr1 ,test)
lr2.predict <- predict(lr2 ,test)
lr3.predict <- predict(lr3 ,test)
lr4.predict <- predict(lr4, test)
lr5.predict <- predict(lr5, test)
loe.predict <- predict(loe ,test)
loe2.predict <- predict(loe2 ,test)
loe3.predict <- predict(loe3 ,test)
loe4.predict <- predict(loe4 ,test)
loe5.predict <- predict(loe5 ,test)
loe6.predict <- predict(loe6 ,test)
loe7.predict <- predict(loe7 ,test)
loe8.predict <- predict(loe8 ,test)
gau.predict <- predict(gau.model,test)

e <- lr1.predict - test[1] 
elr1 <- sum(e*e)
elr1
e <- lr2.predict - test[1] 
elr2 <- sum(e*e)
elr2
e <- lr3.predict - test[1] 
elr3 <- sum(e*e)
elr3
e <- loe.predict - test[1] 
eloe <- sum(e*e)
eloe
e <- lr4.predict - test[1] 
elr4 <- sum(e*e)
elr4
e <- lr5.predict - test[1] 
elr5 <- sum(e*e)
elr5
e <- gau.predict - test[1] 
egau <- sum(e*e)
egau

e <- loe2.predict - test[1] 
eloe2 <- sum(e*e)
eloe2
e <- loe3.predict - test[1] 
eloe3 <- sum(e*e)
eloe3
e <- loe4.predict - test[1] 
eloe4 <- sum(e*e)
eloe4
e <- loe5.predict - test[1] 
eloe5 <- sum(e*e)
eloe5
e <- loe6.predict - test[1] 
eloe6 <- sum(e*e)
eloe6
e <- loe7.predict - test[1] 
eloe7 <- sum(e*e)
eloe7
e <- loe8.predict - test[1] 
eloe8 <- sum(e*e)
eloe8
