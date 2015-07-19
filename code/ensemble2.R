a1 <- read.csv("../res/bench2.csv")
names(a1)
a2 <- submitDb
a2$cost <- (a1$cost + a2$cost)/2
write.csv(a2, file = "../res/ensemble.csv", row.names = F, quote = F)

a1 <- read.csv("../res/bench2.csv")
names(a1)
a2 <- submitDb
a2$cost <- (.4*a1$cost + .6*a2$cost)
write.csv(a2, file = "../res/ensemble2.csv", row.names = F, quote = F)

a1 <- read.csv("../res/bench2.csv")
names(a1)
a2 <- submitDb
a2$cost <- (.3*a1$cost + .7*a2$cost)
write.csv(a2, file = "../res/ensemble3.csv", row.names = F, quote = F) ## .259106

a1 <- read.csv("../res/bench2.csv")
names(a1)
a2 <- submitDb
a2$cost <- (.35*a1$cost + .65*a2$cost)
write.csv(a2, file = "../res/ensemble4.csv", row.names = F, quote = F)## .258898

a1 <- read.csv("../res/bench2.csv")
names(a1)
a2 <- submitDb
a2$cost <- (.38*a1$cost + .62*a2$cost)
write.csv(a2, file = "../res/ensemble5.csv", row.names = F, quote = F)## .258815

a1 <- read.csv("../res/bench2.csv")
names(a1)
a2 <- submitDb
a2$cost <- (.45*a1$cost + .55*a2$cost)
write.csv(a2, file = "../res/ensemble6.csv", row.names = F, quote = F)## .258815
