library(rpart)


d_somatic = read.csv("/Users/yamamoto/work/snp_result/somatic.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
d_germline = read.csv("/Users/yamamoto/work/snp_result/germline.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")


#d_somatic$category <- "somatic"
#d_germline$category <- "germline"

d_somatic$dbsnp <- ifelse(d_somatic$dbsnp == "True",1,0)
d_germline$dbsnp <- ifelse(d_germline$dbsnp == "True",1,0)

d_somatic <- dplyr::mutate(d_somatic, othersnp=ifelse(d_somatic$other_misrate == "", 0, 1))
d_germline <- dplyr::mutate(d_germline, othersnp=ifelse(d_germline$other_misrate == "", 0, 1))

d_somatic <- dplyr::mutate(d_somatic, log_pvalue=-log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta)))
d_somatic$log_pvalue <- ifelse(d_somatic$other_misrate == "", 0, d_somatic$log_pvalue)

d_germline <- dplyr::mutate(d_germline, log_pvalue=-log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta)))
d_germline$log_pvalue <- ifelse(d_germline$other_misrate == "", 0, d_germline$log_pvalue)



#d_germline <- filter(d_germline, exac >= 0.01)
#d_germline <- sample_n(tbl = d_germline, size = 1285)


set.seed(sample.int(1000,1))
tmp <- sample(1:79, 60)

x_somatic <- d_somatic[tmp,]
y_somatic <- d_somatic[-tmp,]
x_germline <- d_germline[tmp,]
y_germline <- d_germline[-tmp,]

x <- rbind(x_somatic, x_germline)
y <- rbind(y_somatic, y_germline)

tree_train <- rpart(category ~ dbsnp + cosmic + misrate + depth + variant + log_pvalue + othersnp + exac + cohort_count, data=x)
plot.new(); par(xpd=T); plot(tree_train)
text(tree_train, use.n = T, digits=getOption("digits"))


tree_pred <- predict(tree_train, y, type="class")
table(y$category, tree_pred)

result <- cbind(y, tree_pred)
mismatch_result <- result %>% filter(result$category != result$tree_pred)
#mismatch_result$cohort_count <- as.integer(mismatch_result$cohort_count)


#next
d_germline_exac <- filter(d_germline, exac >= 0.01)
#d_germline_exac_1285 <- sample_n(tbl = d_germline_exac, size = 1285)


x_germline_2 <- d_germline_exac[tmp,]
x2 <- rbind(x_somatic, x_germline_2)


tree_train_2<- rpart(category ~ dbsnp + cosmic + misrate + depth + variant + log_pvalue + othersnp, data=x2)
plot.new(); par(xpd=T); plot(tree_train_2)
text(tree_train_2, use.n = T, digits=getOption("digits"))


tree_pred_2<- predict(tree_train_2, mismatch_result, type="class")
table(mismatch_result$category, tree_pred_2)

result_2 <- cbind(mismatch_result, tree_pred_2)
#mismatch_result_2 <- result_2 %>% filter(result_2$category != result_2$tree_pred_2)
