getwd()
a <- read.table("/home/jeff/study/datascience/hw7/mushroom.data", sep=',')
head(a)
str(a)
mushroom <- a[,-c(12,17)]
library(e1071)
library(caret)
set.seed(20180602)
train.ind <- createDataPartition(mushroom$V1, p = 1/2, list = F)
train <- mushroom[train.ind, ]
test <- mushroom[-train.ind, ]
dim(train) ; dim(test)
model.nb <- naiveBayes(V1 ~ ., train)
model.nb
predict(model.nb, test)
table(predict(model.nb,test) == test$V1)/length(test$V1)
model.lr <- glm(V1 ~ ., data = train, family = "binomial")
model.lr
p <- predict(model.lr, test, type = "response")
labels <- ifelse(p > 0.5, "p", "e")
labels
table(labels == test$V1)/length(test$V1)


model.svm <- svm(V1 ~ ., data = train, kernel = "linear")
model.svm
predict(model.svm, test)
table(predict(model.svm, test) == test$V1)/length(test$V1)

library(kknn)
model <- kknn(V1 ~ ., train, test, kernel = "rectangular")
model$fitted.values
table(model$fitted.values == test$V1)/length(test$V1)
library(rpart)
model.dt <- rpart(V1 ~ .,train)
library(rpart.plot)
rpart.plot(model.dt)
predict(model.dt, test, type = "class")
table(predict(model.dt, test, type = "class") ==
        test$V1)/length(test$V1)

