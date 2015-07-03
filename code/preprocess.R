library(lubridate)
train = read.csv('../data/train_set.csv', stringsAsFactors = FALSE)
test = read.csv('../data/test_set.csv', stringsAsFactors = FALSE)

# Convert to date.
train$quote_date <- as.Date(train$quote_date)
test$quote_date <- as.Date(test$quote_date)

# Extract different date components from date
train$year <- year(train$quote_date)
train$month <- month(train$quote_date)
train$dayofyear <- yday(train$quote_date)
train$dayofweek <- wday(train$quote_date)
train$day <- day(train$quote_date)

test$year <- year(test$quote_date)
test$month <- month(test$quote_date)
test$dayofyear <- yday(test$quote_date)
test$dayofweek <- wday(test$quote_date)
test$day <- day(test$quote_date)



# remove useless columns
test <- subset(test, select = -c(quote_date, id,supplier))
train <- subset(train, select = -c(quote_date, supplier))

# Convert to categorical
train$tube_assembly_id <- factor(train$tube_assembly_id)
test$tube_assembly_id <- factor(test$tube_assembly_id)
train$bracket_pricing <- factor(train$bracket_pricing)
test$bracket_pricing <- factor(test$bracket_pricing)
#train$supplier <- factor(train$supplier)
#test$supplier <- factor(test$supplier)

save(train,test, file = "../data/data.RData")
