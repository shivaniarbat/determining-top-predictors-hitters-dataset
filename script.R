rm(list=ls())
library('ISLR')
library(glmnet)
library(ncvreg)
library(leaps)
library(dplyr)
library(ggplot2)
data("Hitters")

# remove the rows with missing data
hittersData <- Hitters[rowSums(is.na(Hitters)) == 0,]

# data partitioning
set.seed(100)
index = sample(1:nrow(hittersData), 0.7*nrow(hittersData))
train = hittersData[index,] # training data
x_train = model.matrix(Salary~.-1, data=train)
y_train = train$Salary
test = hittersData[-index,] # test data
x_test = model.matrix(Salary~.-1, data=test)
y_test = test$Salary
dim(train)
dim(test)

# Compute R^2 from true and predicted values
eval_results <- function(true, predicted, df) {
  SSE <- sum((predicted - true)^2)
  SST <- sum((true - mean(true))^2)
  R_square <- 1 - SSE / SST
  RMSE = sqrt(SSE/nrow(df))
  # Model performance metrics
  data.frame(
    RMSE = RMSE,
    Rsquare = R_square
  )
}

# fit a lasso model
lasso_reg <- cv.glmnet(x_train,y_train, alpha = 1,lambda = 10^seq(2,-3,by = -
                                                                    .1),standardize = TRUE, nfolds = 5)
lasso_reg$lambda.min
lambda_best = lasso_reg$lambda.min
lasso_model = glmnet(x_train,y_train,lambda = 10^seq(2,-3,by = -.1), alpha =
                       1,standardize = TRUE)
predictions_train <- predict(lasso_model, s = lambda_best, newx = x_train)
eval_results(y_train, predictions_train, train)
predictions_test <- predict(lasso_model, s = lambda_best, newx = x_test)
eval_results(y_test, predictions_test, test)

# fit elastic net model
elasticnet_reg <- cv.glmnet(x_train,y_train,lambda = 10^seq(2,-3,by = -.1),
                            alpha = 0.5)
elasticnet_reg$lambda.min
lambda_best_el <- elasticnet_reg$lambda.1se
elasticnet_model = glmnet(x_train,y_train, lambda = 10^seq(2,-3,by = -.1),
                          alpha = 0.5)
el_prediction_train <- predict(elasticnet_model, s = lambda_best_el, newx =
                                 x_train)
eval_results(y_train, el_prediction_train, train)
el_prediction_test <- predict(elasticnet_model, s = lambda_best_el, newx =
                                x_test)
eval_results(y_test, el_prediction_test, test)

# SCAD model
scad = cv.ncvreg(x_train,y_train,lambda = 10^seq(2,-3,by = -.1),alpha=1)
scad$lambda.min
lambda_best_scad <- scad$lambda.min
scad_model <- ncvreg(x_train,y_train,lambda = 10^seq(2,-3,by = -.1),alpha=1)
scad_prediction_train <- predict(scad_model, lambda =lambda_best_scad, X =
                                   x_train)
eval_results(y_train, scad_prediction_train, train)
scad_prediction_test <- predict(scad_model, lambda =lambda_best_scad, X =
                                  x_test)
eval_results(y_test, scad_prediction_test, test)

# adaptive lasso
tau = 1
first.step.coef = coef(lasso_reg)[-1]
penalty.factor = abs(first.step.coef+1/sqrt(nrow(x_train)))^(-tau)
adalasso = cv.glmnet(x_train,y_train,crit="bic",
                     penalty.factor=penalty.factor)
# get top predictors for the respective models
coef(lasso_reg)
coef(elasticnet_reg)
coef(scad_model, lambda = lambda_best_scad)
coef(adalasso)
