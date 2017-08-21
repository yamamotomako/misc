d = read.csv("/Users/yamamoto/work/beta_binomial/all_gs_beta.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")

#d <- dplyr::mutate(d, category_test=ifelse(grep("/A/",sample), "somatic", "germline"))
d$category <- ifelse(d$category == "A","somatic","germline")
#d <- dplyr::filter(d, depth-variant >= 3)
#d <- dplyr::filter(d, variant/depth < 0.95)

d <- dplyr::mutate(d, log_pvalue=-log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta)))
d$log_pvalue <- ifelse(d$other_misrate == "", 0, d$log_pvalue)

p <- ggplot(d, aes(x=category, y=log_pvalue)) + geom_boxplot() + theme(axis.text.x = element_text(size=rel(2)), axis.text.y = element_text(size=rel(2)), axis.title.x = element_text(size=rel(2)), axis.title.y = element_text(size=rel(2)))
p + ylim(c(0,20))

plot(p)



d <- dplyr::arrange(d, desc(log_pvalue))


quit()




a <- 2.3
b <- 2.4
#x <- seq(0.01, 1.0, len=500)
x <- c(0.488)
plot(x, dbeta(x, a, b), xlim = c(0, 1))

hist(rbetabinom.ab(10000, 100, shape1 = 80, shape2 = 100), breaks = seq(0, 100, 1))
sum(rbetabinom.ab(10000000, 68, shape1 = 87, shape2 = 105) <= 9)

-log10(dbetabinom.ab(1, 68, shape1 = 87, shape2 = 2.5))


#for文遅い
for(i in 0:nrow(d)){
    i <- i + 1
        
    alpha <- d$alpha[i]
    beta <- d$beta[i]
    depth <- d$depth[i]
    variant <- d$variant[i]
    
    pvalue <- -log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta))
    d$pvalue[i] <- as.numeric(pvalue)

}

# + theme(axis.text.y = element_blank())





