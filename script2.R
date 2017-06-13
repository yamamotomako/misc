library(rpart)


result = read.csv("/Users/yamamoto/work/tree/gs1000.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
result <- result[6:9]
View(result)
#pairs(result, col=as.integer(result$category), pch=as.integer(result$category))


set.seed(777)
tmp <- sample(1:2000, 1800)
x <- result[tmp,]
y <- result[-tmp,]

tree_cart <- rpart(category ~ ., data=x)
plot.new(); par(xpd=T); plot(tree_cart)
text(tree_cart, use.n = T, digits=getOption("digits"))


tree_pred <- predict(tree_cart, y, type="class")
table(y$category, tree_pred)


g <- rpart.plot(tree_cart)
summary(g)
plot(g)

nrow(filter(result, category=="germline"))
nrow(filter(result, category=="others"))
nrow(filter(result, category=="somatic"))


nrow(filter(x, category=="germline"))
nrow(filter(x, category=="others"))
nrow(filter(x, category=="somatic"))


nrow(filter(y, category=="germline"))
nrow(filter(y, category=="others"))
nrow(filter(y, category=="somatic"))





