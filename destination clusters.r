#--------------------------------------------------------------------------
# Shivani Sheth 
# R script that clusters destinations based on supervised set of conditions# 
# Nov 2016
#--------------------------------------------------------------------------

clusterdata <- read.csv("C:/Users/ssheth/Documents/R/Raw Data/RawData_BudgetPlanning.csv")
clusterdata <- clusterdata [clusterdata$Groups == 'Western Europe',]
attach(clusterdata)

# K-means clustering (partitioning method)
# Determine number of clusters
# Ward Hierarchical Clustering
d <- dist(clusterdata, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward")
plot(fit) # display dendogram

# K-Means Cluster Analysis
fit <- kmeans(clusterdata$TSessions + clusterdata$TAttractioncount, 4) # n cluster solution
summary(fit)

# get cluster means 
aggregate(clusterdata,by=list(fit$cluster),FUN=mean)

# append cluster assignment
mydata <- data.frame(clusterdata, fit$cluster)
#write.table(mydata, "C:/Users/ssheth/Documents/R/Output/PodClustering.csv", append = TRUE, sep=",")
