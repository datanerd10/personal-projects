#--------------------------------------------------------------------------
# Shivani Sheth 
# R script for determining variables that influence CVR
# The regression model looks for the right mix of product attributes that 
# are associated with product conversion, either positively or negatively (or both)
# Re-do  Aug 17, 2016
#--------------------------------------------------------------------------

library(dplyr)
library(MASS)
library(ggplot2)

#Loads data from csv into data frame  and merges them

#read and load product data into dataframe
#use the cleaned data and load it into a csv
#Date Range for the omniture and cube data pull Jan - Jun 2016

#products removed
#2280AAHT
#3731VATICAN
#3731COLOSSEUM
# + Any product with < 5 gross orders
# removed top 10% products

merged <- read.csv("C:/Users/ssheth/Documents/R/Raw Data/product content+cvr+price_data_wo_10percents.csv", 
                    stringsAsFactors = FALSE)


str(merged)
merged <- na.omit(merged)
summary(merged)
View(merged)

#Stepwise regression and determining the right independent vars

# t value = estimate/std error
# The larger the abs value of t stats, the more likely the co-ef is to be 
#significant
#you need high values for t value

# Stepwise Regression
fit <- lm(CVR ~ VUC.Flag + Avg.Rating + Rating.y.n.
                + Product.Price + Total.Shop.Reviews
                + Total.Shop.Photos + Total.Videos + Highlightstitle.Wc
                + Inclusions.Wc + Exclusions.Wc + Insidertips.Wc
                + Unique.Intro.WC + Unique.Product.Text.WC
                + Additional.Information.Wc,
                data = merged)
summary(fit)

step <- stepAIC(fit, direction="both")
step$anova # display results

#stepwise model derived from the stepAIC output
model_stepwise <- lm(CVR ~ VUC.Flag + Avg.Rating + Rating.y.n. + Product.Price + Total.Shop.Reviews + 
                           Total.Shop.Photos + Highlightstitle.Wc + Exclusions.Wc + 
                           Insidertips.Wc + Unique.Intro.WC + Unique.Product.Text.WC + 
                           Additional.Information.Wc, data = merged)
summary(model_stepwise)


# Creates quadratic terms
merged <- merged %>%
          mutate(price2 = Product.Price * Product.Price) %>%
          mutate(reviews2 = Total.Shop.Reviews * Total.Shop.Reviews) %>%
          mutate(photos2 = Total.Shop.Photos * Total.Shop.Photos) %>%
          mutate(high2 = Highlightstitle.Wc * Highlightstitle.Wc) %>%
          mutate(incl2 = Inclusions.Wc * Inclusions.Wc) %>%
          mutate(excl2 = Exclusions.Wc * Exclusions.Wc) %>%
          mutate(insi2 = Insidertips.Wc * Insidertips.Wc) %>%
          mutate(intro2 = Unique.Intro.WC * Unique.Intro.WC)  %>%
          mutate(text2 = Unique.Product.Text.WC * Unique.Product.Text.WC) %>%
          mutate(add2 = Additional.Information.Wc * Additional.Information.Wc) %>%
          mutate(rating2 = Avg.Rating * Avg.Rating)

modelSQ <- lm(CVR ~ Product.Price + price2
           + Total.Shop.Reviews + reviews2
           + Total.Shop.Photos + photos2
           + Total.Videos
           + Highlightstitle.Wc + high2
           + Inclusions.Wc + incl2
           + Exclusions.Wc + excl2
           + Insidertips.Wc + insi2
           + Unique.Intro.WC + intro2 
           + Unique.Product.Text.WC + text2
           + Additional.Information.Wc + add2 
           + VUC.Flag 
           + rating2 + Avg.Rating,
           data = merged)
summary(modelSQ)
stepSQ <- stepAIC(modelSQ, direction="both")
stepSQ$anova # display results


modelSQ_stepwise <- lm(CVR ~ Product.Price + price2 + Total.Shop.Reviews + reviews2 + 
                             Total.Shop.Photos + photos2 + Highlightstitle.Wc + high2 + 
                             incl2 + Exclusions.Wc + Insidertips.Wc + Unique.Intro.WC + 
                             intro2 + Unique.Product.Text.WC + text2 + Additional.Information.Wc + 
                             add2 + VUC.Flag + Rating.y.n. + Avg.Rating, data = merged)
    
summary(modelSQ_stepwise)


modelSQ_stepwise_rev <- lm(CVR ~ Product.Price + price2 + Total.Shop.Reviews + reviews2 + 
                                 Highlightstitle.Wc + high2 + 
                                 incl2 + Exclusions.Wc + Insidertips.Wc + Unique.Intro.WC + 
                                 intro2 + Unique.Product.Text.WC + text2 + Additional.Information.Wc + 
                                 add2 + VUC.Flag + Rating.y.n. + Avg.Rating, data = merged)
summary(modelSQ_stepwise_rev)


modelSQ_stepwise_pic <- lm(CVR ~ Product.Price + price2 +  
                                 Total.Shop.Photos + photos2 + Highlightstitle.Wc + high2 + 
                                 incl2 + Exclusions.Wc + Insidertips.Wc + Unique.Intro.WC + 
                                 intro2 + Unique.Product.Text.WC + text2 + Additional.Information.Wc + 
                                 add2 + VUC.Flag + rating2 + Avg.Rating, data = merged)
summary(modelSQ_stepwise_pic)


rating_model <- lm(CVR ~ Avg.Rating + rating2, data = merged)
summary(rating_model)


ratingP_model <- lm(CVR ~ Rating.y.n., data = merged)
summary(ratingP_model)

reviewOnly_model <- lm(CVR ~ Total.Shop.Reviews + reviews2, data = merged)
summary(reviewOnly_model)

modelSQ_rating_rev <- lm(CVR ~ Product.Price + price2 + Total.Shop.Reviews + reviews2 + 
                            + Highlightstitle.Wc + high2 + 
                            Inclusions.Wc + incl2 + Exclusions.Wc + excl2 + Insidertips.Wc + 
                            Unique.Intro.WC + intro2 + Unique.Product.Text.WC + text2 + 
                            Additional.Information.Wc + add2 + Avg.Rating + rating2,
                            data = merged)
summary(modelSQ_rating_rev)


model_x <- lm(CVR ~ Product.Price + price2 + 
              Total.Shop.Photos + photos2 + Highlightstitle.Wc + high2 + 
              incl2 + Exclusions.Wc + excl2 + Insidertips.Wc + Unique.Intro.WC + 
              intro2 + Unique.Product.Text.WC + text2 + Additional.Information.Wc + 
              add2 + VUC.Flag + rating2, data = merged)

summary(model_x)
rmarkdown::render("C:/Users/ssheth/Documents/R/SCripts/Product&CVR_Regression.R")
rmarkdown::render("C:/Users/ssheth/Documents/R/SCripts/Product&CVR_Regression.R", "pdf_document")
