library(xgboost)
load("../data/data2.RData")
X_train <- train[,-match(c("id","cost"), names(train))]
X_test <- test[,-match(c("id","cost"), names(test))]

## train on log(x)+1
labels <- log(train[,match("cost", names(train))] +1)

dtrain <- xgb.DMatrix(data.matrix(X_train, rownames = FALSE), label = labels)
dtest <- xgb.DMatrix(data.matrix(X_test, rownames = F))


regobj <- function(preds, dtrain) {
  labels <- getinfo(dtrain, "label")
  grad <- preds - labels
  hess <- preds * (1 - preds)
  return(list(grad = grad, hess = hess))
}

# user defined evaluation function, return a pair metric_name, result
# NOTE: when you do customized loss function, the default prediction value is margin
# this may make buildin evalution metric not function properly
# for example, we are doing logistic loss, the prediction is score before logistic transformation
# the buildin evaluation error assumes input is after logistic transformation
# Take this in mind when you use the customization, and maybe you need write customized evaluation function
evalerror <- function(preds, dtrain) {
  labels <- getinfo(dtrain, "label")
  err <- as.numeric(sum((preds - labels)^2))/length(labels)
  return(list(metric = "error", value = err))
}




param <- list(max.depth = 5, eta = 1, silent =1,objective = 'reg:linear')

history <- xgb.cv(param, dtrain, nround = 50, nfold = 5, metrics = {'rmse'}, showsd = T)



bst <- xgb.train(param, dtrain, nthread = 2, nround = 50)

pred  <- predict(bst, dtest)

datasub <- data.frame(id = test$id, cost = exp(pred)-1)
datasub <- aggregate(cost ~ id, data = datasub, mean)
write.csv(datasub, '../res/submission_xgboost2.csv', quote = FALSE, row.names = FALSE)

