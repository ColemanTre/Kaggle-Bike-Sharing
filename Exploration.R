---
  title: "Exploration"
output: html_notebook
---
  ##End Goal
  #Predict bike count

  ## What Methods will we use?
  #Exploratory data analysis, added variable plots
  

##Libraries
library(tidyverse)
library(DataExplorer)
library(caret)
library(vroom)
library(lubridate)
library(car)
library(sigmoid)

##Data
test <- read.csv("test.csv")
train <- read.csv('train.csv')
bike <- bind_rows(train=train, test=test, .id = "id")


#Drop casual and registered
bike <- bike %>% select(-casual, -registered)

## Feature Engineering
bike$month <- month(bike$datetime) %>% as.factor()
bike$season <- as.factor(bike$season)
bike$holiday <- as.factor(bike$holiday)
bike$workingday <- as.factor(bike$workingday)
bike$weather <- as.factor(bike$weather)
bike$hour <- hour(bike$datetime) %>% 
  as.factor()



#Exploratory Plots
qplot(1:nrow(train), train$count,
      geom="point")

ggplot(data=train, aes(x=datetime, y = count, color=as.factor(season))) +
  geom_point()

plot_missing(bike)

plot_correlation(bike, type="continuous",
                 cor_args = list(use= 'pairwise.complete.obs'))

ggplot(bike, aes(season, count)) + 
  geom_boxplot()





##Dummy variable encoding - one-hot encoding
dummyVars(count~season, data=bike) %>% 
  predict(bike) %>% 
  as.data.frame() %>% 
  bind_cols(bike %>% select(-season), .)

## Target encoding
bike$season <- lm(count~season, data=bike) %>% 
  predict(., newdata=bike %>% select(-count))





##Fit some models
system.time({
bike.model <- train(form=log1p(count)~season+ holiday + atemp + weather + hour,
                    data = bike %>% filter(id == "train"),
                    method="xgbTree",
                    tuneGrid = expand.grid(nrounds = 300,
                                            max_depth = 3,
                                            eta =  .5,
                                           gamma = .3,
                                           colsample_bytree = .6,
                                           min_child_weight = .6,
                                           subsample = 1),
                    trControl=trainControl(method='repeatedcv', number = 20, repeats = 2))
})
plot(bike.model)

preds <- predict(bike.model, newdata=bike %>% 
  filter(id=='test'))

preds <- expm1(preds)

submission <- data.frame(datetime=bike %>% filter(id=='test') %>%
  pull(datetime),
  count = relu(preds))
 

write.csv(submission, file = "sampleSubmission.csv", row.names=FALSE)

