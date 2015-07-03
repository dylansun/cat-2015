library(xgboost)
load("../data/data2.RData")
X_train <- train[,-match(c("id","cost"), names(train))]
X_test <- test[,-match(c("id","cost"), names(test))]

## train on log(x)+1
result <- log(train[,match("cost", names(train))] +1)
source("RandomForest_R.R")


model_rf_1 <- RandomForestRegression_CV(X_train,result,X_test,cv=5,ntree=25,nodesize=5,seed=235,metric="rmse")
model_rf_2 <- RandomForestRegression_CV(X_train,result,X_test,cv=5,ntree=25,nodesize=5,seed=357,metric="rmse")
model_rf_3 <- RandomForestRegression_CV(X_train,result,X_test,cv=5,ntree=25,nodesize=5,seed=13,metric="rmse")
model_rf_4 <- RandomForestRegression_CV(X_train,result,X_test,cv=5,ntree=25,nodesize=5,seed=753,metric="rmse")
model_rf_5 <- RandomForestRegression_CV(X_train,result,X_test,cv=5,ntree=25,nodesize=5,seed=532,metric="rmse")


## submission
test_rf_1 <- model_rf_1[[2]]
test_rf_2 <- model_rf_2[[2]]
test_rf_3 <- model_rf_3[[2]]
test_rf_4 <- model_rf_4[[2]]
test_rf_5 <- model_rf_5[[2]]

submission1 <- cbind(1:NROW(test), exp(test_rf_1$pred_rf)-1)
submission2 <- cbind(1:NROW(test), exp(test_rf_2$pred_rf)-1)
submission3 <- cbind(1:NROW(test), exp(test_rf_3$pred_rf)-1)
submission4 <- cbind(1:NROW(test), exp(test_rf_4$pred_rf)-1)
submission5 <- cbind(1:NROW(test), exp(test_rf_5$pred_rf)-1)

colnames(submission1) <- c('id', 'cost')
colnames(submission2) <- c('id', 'cost')
colnames(submission3) <- c('id', 'cost')
colnames(submission4) <- c('id', 'cost')
colnames(submission5) <- c('id', 'cost')

write.csv(submission1, '../res/submission1', quote = FALSE, row.names = FALSE)
write.csv(submission2, '../res/submission2', quote = FALSE, row.names = FALSE)
write.csv(submission3, '../res/submission3', quote = FALSE, row.names = FALSE)
write.csv(submission4, '../res/submission4', quote = FALSE, row.names = FALSE)
write.csv(submission5, '../res/submission5', quote = FALSE, row.names = FALSE)

