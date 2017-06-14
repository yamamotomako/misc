library(rpart)


d = read.csv("/Users/yamamoto/work/tree/test.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
d <- d[6:9]
View(d)
#pairs(result, col=as.integer(result$category), pch=as.integer(result$category))


set.seed(777)
tmp <- sample(1:440000, 400000)
x <- d[tmp,]
y <- d[-tmp,]

tree_train <- rpart(category ~ ., data=x)
plot.new(); par(xpd=T); plot(tree_train)
text(tree_train, use.n = T, digits=getOption("digits"))


tree_pred <- predict(tree_train, y, type="class")
table(y$category, tree_pred)




nrow(filter(result, category=="germline"))
nrow(filter(result, category=="others"))
nrow(filter(result, category=="somatic"))


nrow(filter(x, category=="germline"))
nrow(filter(x, category=="others"))
nrow(filter(x, category=="somatic"))


nrow(filter(y, category=="germline"))
nrow(filter(y, category=="others"))
nrow(filter(y, category=="somatic"))





