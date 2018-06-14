getwd()
a <- read.table("/home/jeff/study/datascience/hw7/crx.data", sep=',', na.strings = '?')
a <- na.omit(a)
head(a)
str(a)
credit <- a
summary(credit)
#mushroom <- a[,-c(12,17)]
library(e1071)
library(caret)
set.seed(20180602)
train.ind <- createDataPartition(credit$V1, p = 2/3, list = F)
train <- credit[train.ind, ]
test <- credit[-train.ind, ]
dim(train) ; dim(test)
model.nb <- naiveBayes(V16 ~ ., train)
model.nb
predict(model.nb, test)
table(predict(model.nb,test) == test$V16)/length(test$V16)

model.lr <- glm(V16 ~ ., data = train, family = "binomial")
model.lr
p <- predict(model.lr, test, type = "response")
labels <- ifelse(p > 0.5, "+", "-")
labels
table(labels == test$V16)/length(test$V16)


model.svm <- svm(V16 ~ ., data = train, kernel = "linear")
model.svm
predict(model.svm, test)
esvm <- table(predict(model.svm, test), test$V16)
table(predict(model.svm, test) == test$V16)/length(test$V16)

tp  <- sum(predict(model.svm, test) == '+' & ( test$V16 == '+'))
fp  <- sum(predict(model.svm, test) == '+' & ( test$V16 == '-'))
tn  <- sum(predict(model.svm, test) == '-' & ( test$V16 == '-'))
fn  <- sum(predict(model.svm, test) == '-' & ( test$V16 == '+'))
precision(esvm)
recall(esvm)

library(kknn)
model <- kknn(V16 ~ ., train, test, kernel = "rectangular")
model$fitted.values
model
table(model$fitted.values == test$V16)/length(test$V16)
library(rpart)
model.dt <- rpart(V16 ~ .,train)
library(rpart.plot)
rpart.plot(model.dt)
predict(model.dt, test, type = "class")
table(predict(model.dt, test, type = "class") ==
        test$V16)/length(test$V16)

