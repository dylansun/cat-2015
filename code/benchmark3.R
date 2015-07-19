# Drawing inspiration from arnauds script but making changes based on my observation and analysis
# Please note that this script will timeout in Kaggle environment hence need to run in an alternate environment

options(scipen = 10)

###
### Build train and test db
###

### Load train and test
test = read.csv("../data/test_set.csv")
train = read.csv("../data/train_set.csv")

train$id = -(1:nrow(train))
test$cost = 0

train = rbind(train, test)
bill_of_materials = read.csv("../data/bill_of_materials.csv")
train=merge(train, bill_of_materials, by="tube_assembly_id", all = TRUE)

tube = read.csv("../data/tube.csv")
train=merge(train, tube, by="tube_assembly_id", all = TRUE)

specs = read.csv("../data/specs.csv")
train=merge(train, specs, by="tube_assembly_id", all = TRUE)

train=train[!is.na(train$id),]

### Clean NA values
for(i in 1:ncol(train)){
  if(is.numeric(train[,i])){
    train[is.na(train[,i]),i] = -1
  }else{
    train[,i] = as.character(train[,i])
    train[is.na(train[,i]),i] = "NAvalue"
    train[,i] = as.factor(train[,i])
  }
}

# Adding new features julian date, year and month
train$quote_date=as.Date(as.character(train$quote_date))
train$quote_date_jul = julian(train$quote_date)
train$quote_year = format(train$quote_date, "%Y")
train$quote_month = format(train$quote_date, "%M")

### Clean variables with too many categories
for(i in 1:ncol(train)){
  if(names(train)[i]!="tube_assembly_id" &  names(train)[i]!="supplier" & names(train)[i]!="quote_date"){
    if(!is.numeric(train[,i])){
      freq = data.frame(table(train[,i]))
      freq = freq[order(freq$Freq, decreasing = TRUE),]
      train[,i] = as.character(match(train[,i], freq$Var1[1:30]))
      train[is.na(train[,i]),i] = "rareValue"
      train[,i] = as.factor(train[,i])
    }
  }
}

# RF has a constraint on 53 Categories only hence limiting the Supplier to the max
freq = data.frame(table(train[,c("supplier")]))
freq = freq[order(freq$Freq, decreasing = TRUE),]
train[,c("supplier")] = as.character(match(train[,c("supplier")], freq$Var1[1:52]))
train[is.na(train[,c("supplier")]),c("supplier")] = "rareValue"
train[,c("supplier")] = as.factor(train[,c("supplier")])

# Removing tube_assembly_id from the list of features as the specifications of tube is good enough to go
# Additionally removing julian date and date, retaining only year and month
train = train[,-match(c("tube_assembly_id","quote_date","quote_date_jul"), names(train))]

test = train[which(train$id > 0),]
train = train[which(train$id < 0),]

### Randomforest
library(randomForest)

### Train randomForest on the whole training set
rf = randomForest(log(train$cost + 1)~., train[,-match(c("id", "cost"), names(train))], ntree =80, do.trace = 2)

pred = exp(predict(rf, test)) - 1

submitDb = data.frame(id = test$id, cost = pred)
submitDb = aggregate(data.frame(cost = submitDb$cost), by = list(id = submitDb$id), mean)

write.csv(submitDb, "../res/benchmark3.csv", row.names = FALSE, quote = FALSE)

