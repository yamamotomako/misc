library(ggplot2)

d_all = read.csv("/Users/yamamoto/work/tree/result/all.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")

d_all$category <- ifelse(d_all$category == "A","somatic",ifelse(d_all$category == "B", "germline", "others"))


label <- c("somatic", "germline", "others")

p <- ggplot(d_all, aes(x = category, y=cohort_count)) + geom_boxplot() + scale_x_discrete(limits=label)
plot(p)
ggsave("/Users/yamamoto/work/tree/result/cohort_count.png")

p <- ggplot(d_all, aes(x = category, y=depth)) + geom_boxplot() + scale_x_discrete(limits=label)
plot(p)
ggsave("/Users/yamamoto/work/tree/result/depth.png")

p <- ggplot(d_all, aes(x = category, y=variantNum)) + geom_boxplot() + scale_x_discrete(limits=label)
plot(p)
ggsave("/Users/yamamoto/work/tree/result/variantNum.png")

p <- ggplot(d_all, aes(x = category, y=misRate)) + geom_boxplot() + scale_x_discrete(limits=label)
plot(p)
ggsave("/Users/yamamoto/work/tree/result/misRate.png")


