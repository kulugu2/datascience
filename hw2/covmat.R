library(openxlsx)
library(corrplot)
a <- read.xlsx("ENB2012_data.xlsx",sheet=1)
cormat <- round(cor(a),2)
corrplot(a, method = 'circle')
cormat
