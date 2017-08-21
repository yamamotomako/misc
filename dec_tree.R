library(rpart)


d_somatic = read.csv("/Users/yamamoto/work/beta_binomial/new/somatic_beta.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
d_germline = read.csv("/Users/yamamoto/work/beta_binomial/new/germline_beta_1286.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")

#d_somatic = read.csv("/Users/yamamoto/work/beta_binomial/new2/somatic_beta.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
#_germline = read.csv("/Users/yamamoto/work/beta_binomial/new2/germline_nofilter_exac.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")

d_somatic$category <- "somatic"
d_germline$category <- "germline"

d_somatic$dbsnp <- ifelse(d_somatic$dbsnp == "True",1,0)
d_germline$dbsnp <- ifelse(d_germline$dbsnp == "True",1,0)

d_somatic <- dplyr::mutate(d_somatic, othersnp=ifelse(d_somatic$other_misrate == "", 0, 1))
d_germline <- dplyr::mutate(d_germline, othersnp=ifelse(d_germline$other_misrate == "", 0, 1))

d_somatic <- dplyr::mutate(d_somatic, log_pvalue=-log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta)))
d_somatic$log_pvalue <- ifelse(d_somatic$other_misrate == "", 0, d_somatic$log_pvalue)

d_germline <- dplyr::mutate(d_germline, log_pvalue=-log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta)))
d_germline$log_pvalue <- ifelse(d_germline$other_misrate == "", 0, d_germline$log_pvalue)


set.seed(sample.int(1000,1))
tmp <- sample(1:1285, 1158)

x_somatic <- d_somatic[tmp,]
y_somatic <- d_somatic[-tmp,]
x_germline <- d_germline[tmp,]
y_germline <- d_germline[-tmp,]

x <- rbind(x_somatic, x_germline)
y <- rbind(y_somatic, y_germline)

tree_train <- rpart(category ~ dbsnp + cosmic + exac + misrate + log_pvalue + othersnp, data=x)
plot.new(); par(xpd=T); plot(tree_train)
text(tree_train, use.n = T, digits=getOption("digits"))


tree_pred <- predict(tree_train, y, type="class")
table(y$category, tree_pred)

result <- cbind(y, tree_pred)
mismatch_result <- result %>% filter(result$category != result$tree_pred)

mismatch_result %>% dplyr::select(category, tree_pred, chr, start, dbsnp, cosmic, exac, cohort, log_pvalue)










d$category <- ifelse(d$category == "A","somatic","germline")
d$dbsnp <- ifelse(d$dbsnp == "True",1,0)
d$othersnp <- ifelse(d$other_misrate == "", 0, 1)

#d <- transform(d, othersnp=ifelse(misRate_otherSNP!="",1,0))
d <- dplyr::mutate(d, log_pvalue=-log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta)))
d$log_pvalue <- ifelse(d$other_misrate == "", 0, d$log_pvalue)

#d <- dplyr::mutate(d, test=ifelse(d$other_misrate == "", 0, d$log_pvalue))

View(d)


set.seed(sample.int(1000,1))
tmp <- sample(1:1286, 128)


x <- d[tmp,]
y <- d[-tmp,]



tree_train <- rpart(category ~ dbsnp + cosmic + exac + misrate + log_pvalue + othersnp, data=x)
plot.new(); par(xpd=T); plot(tree_train)
text(tree_train, use.n = T, digits=getOption("digits"))


tree_pred <- predict(tree_train, y, type="class")
table(y$category, tree_pred)

result <- cbind(y, tree_pred)
mismatch_result <- result %>% filter(result$category != result$tree_pred)

mismatch_result %>% dplyr::select(category, tree_pred, chr, start, dbsnp, cosmic, exac, cohort, log_pvalue)


nrow(filter(result, category=="germline"))
nrow(filter(result, category=="others"))
nrow(filter(result, category=="somatic"))


nrow(filter(x, category=="germline"))
nrow(filter(x, category=="others"))
nrow(filter(x, category=="somatic"))


nrow(filter(y, category=="germline"))
nrow(filter(y, category=="others"))
nrow(filter(y, category=="somatic"))





