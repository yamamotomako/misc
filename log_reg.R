result = read.csv("/Users/yamamoto/work/tree/gs1000.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
result <- result[6:9]

set.seed(777)
tmp <- sample(1:2000, 1800)
x <- result[tmp,]
y <- result[-tmp,]

head(result, n=10)

train_model = glm(category ~ ., data=x, family = binomial(link="logit"))
summary(train_model)

#test_result <- predict(train_model, y, interval="confidence", level=0.95)



fit <- fitted(train_model)
log2 <- cbind(log2, fit)
predict <- ifelse(log2$fit>0.5,1,0)
log2 <- cbind(log2, predict)
table(log2$category, log2$predict)



train_model.p <- round(predict(train_model, type="resp"))
train_model.t <- table(x$category, train_model.p)


#train_model.pr <- predict(train_model, y, type="response")
#lot(y$category, train_model.pr, type="l")





age.group <- cut(juul.gir$age, c(8:18))
m1.pr <- predict(m1, newage, type="response")
tb <- table(age.group, juul.gir$menarche)
rel.freq <- prop.table(tb,1)[,2]
points(c(8:17)+0.5, rel.freq, pch=1)







#全データから7割
iris_new = bind_rows(iris %>% filter(Species == "setosa"), iris %>% filter(Species == "virginica"))
index <- sample(nrow(iris_new), nrow(iris_new)*0.7)

#回帰
res <- glm(Species ~ ., iris_new[index,], family = binomial())
summary(res)

#
res$coefficients
logLik(res)
yhat <- levels(iris_new$Species)[predict(res, iris_new, type="response") > 0.5 + 1]


mean(yhat[index] != iris$Species[index])
mean(-yhat[index] != iris$Species[-index])
table(true=iris_new$Species, prediction=yhat)








data(babyfood, package="faraway")
mod1 <- glm(cbind(disease, nondisease)~sex+food, family=binomial,data=babyfood)
summary(mod1)

data(juul, package = "ISwR")
set.seed(10)
juul[sample(nrow(juul), 4), ]

temp <- subset(juul, age>8, age < 18)
juul.gir <- na.omit(temp[, 1:4])
head(juul.gir, n=3)


m1 <- glm(menarche ~ age, data=juul.gir, binomial)
summary(m1)

newage <- data.frame(age=seq(8,18,0.1))
m1.pr <- predict(m1, newage, type="response")
plot(newage$age, m1.pr, type="l")

age.group <- cut(juul.gir$age, c(8:18))
m1.pr <- predict(m1, newage, type="response")
tb <- table(age.group, juul.gir$menarche)
rel.freq <- prop.table(tb,1)[,2]
points(c(8:17)+0.5, rel.freq, pch=1)



