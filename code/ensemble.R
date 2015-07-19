min <- min(train$cost)
max <- max(train$cost)
best <- read.csv("../res/bench2.csv") # 0.263888
xgboost1 <- read.csv("../res/submission_xgboost1.csv")
min(best$cost)
max(best$cost)
sub <- train[train$cost <200,]
hist(sub$cost)
summary(train)
summary(best)
summary(xgboost1)
lower_bound_xgboost1 <- xgboost1

lower_bound_xgboost1[bound_xgboost1$cost < .5, 2] <- .5

## 0.365625 inprove from 0.366693
write.csv(lower_bound_xgboost1, file = "../res/lower_bound_xgboost1.csv", row.names=F, quote = F)
lower_bound_xgboost1[bound_xgboost1$cost > 200, 2] <- 200
## 0.361085 improve form 0.366693
write.csv(lower_bound_xgboost1, file = "../res/lower_upper_bound_xgboost1.csv", row.names=F, quote = F)

##
upper_bound_best <- best
upper_bound_best[upper_bound_best$cost > 200, 2] <- 200
## 0.264735
write.csv(upper_bound_best, file = "../res/upper_bound_best.csv", row.names=F, quote = F)

ensem <- best 
ensem$cost <- (best$cost + lower_bound_xgboost1$cost)/2
write.csv(ensem, file = "../res/submission_rf_xgboost_mean.csv", row.names = F, quote = F)
