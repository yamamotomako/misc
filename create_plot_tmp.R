library(ggplot2)

d_all = read.csv("/Users/yamamoto/work/tree/result/all.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")

d$category <- ifelse(d$category == "A","somatic",ifelse(d$category == "B", "germline", "others"))


p <- ggplot(d_all, aes(x = category, y=cohort_count)) + geom_boxplot()
plot(p)

p <- ggplot(d_all, aes(x = category, y=depth)) + geom_boxplot()
plot(p)

p <- ggplot(d_all, aes(x = category, y=variantNum)) + geom_boxplot()
plot(p)

p <- ggplot(d_all, aes(x = category, y=misRate)) + geom_boxplot()
plot(p)


