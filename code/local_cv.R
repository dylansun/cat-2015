### Randomforest
library(randomForest)
library(caret)
index <- createDataPartition(train$cost, times =1, p = .8, list = F)
dtrain_cv = train[index,]
dtest_cv = train[-index,]
 
### Train randomForest on dtrain_cv and evaluate predictions on dtest_cv
set.seed(123)
rf1 = randomForest(dtrain_cv$cost~., dtrain_cv[,-match("cost", names(dtrain_cv))], ntree = 10, do.trace = 2)

pred = predict(rf1, dtest_cv)
sqrt(mean((log(dtest_cv$cost + 1) - log(pred + 1))^2)) # 0.2589951

### With log transformation trick
set.seed(123)
rf2 = randomForest(log(dtrain_cv$cost + 1)~., dtrain_cv[,-match(c("id", "cost"), names(dtrain_cv))], ntree = 10, do.trace = 2)
pred = exp(predict(rf2, dtest_cv)) - 1

sqrt(mean((log(dtest_cv$cost + 1) - log(pred + 1))^2)) # 0.2410004
