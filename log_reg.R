result = read.csv("/Users/yamamoto/work/tree/misc/gs1000.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
result <- result[6:9]

colnames(result) <- c("category_name", "dbSNP.old", "cosmic", "exac")
result <- transform(result, category=ifelse(category_name=="germline",1,0))
result <- transform(result, dbsnp=ifelse(dbSNP.old=="True",1,0))
head(result, n=10)

set.seed(777)
tmp <- sample(1:2000, 1800)
x <- result[tmp,]
y <- result[-tmp,]


train_model = glm(category ~ dbsnp + cosmic + exac, data=x, family = binomial(link="logit"))
summary(train_model)

test_predict <- round(predict(train_model, y, type="response"))
result_tbl <- table(y$category, test_predict)




#2値分類なので、０〜１で出力、roundで丸めているだけ（四捨五入で近い方）
train_model.p <- round(predict(train_model, type="response"))
train_model.t <- table(x$category, train_model.p)




d <- read.csv("/Users/yamamoto/work/tree/misc/data4a.csv.3")
d.res <- glm(cbind(y, N-y) ~x + f, data = d, family=binomial(link="logit"))
summary(d.res)
#png("logisticGlm.png")
plot(d$x, d$y, col=c("red", "blue")[d$f])

#make new data
xx <- seq(min(d$x), max(d$x), length=1000)
ft <- factor("T", levels=levels(d$f))
df.t <- data.frame(x=xx, f=ft)
#fc <- factor("C", levels=levels(d$f))
#df.c <- data.frame(x=xx, f=fc)

qq.t <- predict(d.res, df.t, type="response")
lines(xx, max(d$N) * qq.t, col="yellow")


#test_result <- predict(train_model, y, type="response")
fit <- fitted(train_model)
log2 <- cbind(log2, fit)
predict <- ifelse(log2$fit>0.5,1,0)
log2 <- cbind(log2, predict)
table(log2$category, log2$predict)

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



