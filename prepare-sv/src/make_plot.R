library(dplyr)
library(ggplot2)

args <- commandArgs(trailingOnly = T)
outdir <- args[1]


#plot of mutation count
#data_mutation = paste0(outdir, "/mutation_count.txt")
print ("building mutation count...")
data_tn <- read.table(paste0(outdir, "/filt_tn_1.txt"), stringsAsFactors = FALSE, header = FALSE, sep="\t")
data_n <- read.table(paste0(outdir, "/filt_n_1.txt"), stringsAsFactors = FALSE, header = FALSE, sep="\t")
data_tn <- data_tn %>% dplyr::mutate(type="TN")
data_n <- data_n %>% dplyr::mutate(type="N")

colnames(data_tn) <- c("sample","mcount", "type")
colnames(data_n) <- c("sample","mcount", "type")

data_all <- rbind(data_tn, data_n)

p <- ggplot(data_all, aes(x=sample, y=mcount, fill=type)) + geom_bar(stat="identity")
p + theme(axis.text.x = element_text(angle = 90)) + guides(fill = FALSE) + ylab("mutation count") + scale_y_log10()
ggsave(paste0(outdir, "/mutation_count.png"))



#plot of dbsnp, cosmic, exac with ABC
print ("building dbsnp, cosmic, exac...")
data <- read.table(paste0(outdir, "/result_all.txt"), stringsAsFactors = FALSE, header = TRUE, sep="\t")

data$cosmic <- as.numeric(data$cosmic)
data$ExAC <- as.numeric(data$ExAC)


X <- data %>% group_by(category, dbSNP) %>% summarize(count = n())
Y <- data %>% group_by(category) %>% summarize(count = n())

X <- dplyr::inner_join(X, Y, by="category")
X <- X %>% mutate(ratio = count.x / count.y * 100)

label <- c("somatic","germline","others")

p <- ggplot(X, aes(x=category, y=ratio, fill=dbSNP)) + geom_bar(stat="identity")
p + scale_x_discrete(limits=label)
ggsave(paste0(outdir, "/dbsnp.png"))

p <- ggplot(data, aes(x=category, y=cosmic, fill=category)) + geom_boxplot()
p + scale_x_discrete(limits=label) + scale_fill_discrete(limits=label)
ggsave(paste0(outdir, "/cosmic.png"))

p <- ggplot(data, aes(x=category, y=-log10(ExAC+1e-6), fill=category)) + geom_boxplot()
p + scale_x_discrete(limits=label) + scale_fill_discrete(limits=label)
ggsave(paste0(outdir, "/exac.png"))





