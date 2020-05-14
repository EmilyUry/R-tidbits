
#' ---
#' title: "BAS vignette"
#' author: "Merlise A Clyde"
#' date: "2020-02-11"
#' output: html_document
#' ---

### Bas vignette
### https://cran.r-project.org/web/packages/BAS/vignettes/BAS-vignette.html

library(BAS)

data(UScrime, package = "MASS")


UScrime[, -2] <- log(UScrime[, -2])



crime.ZS <- bas.lm(y ~ .,
                   data = UScrime,
                   prior = "ZS-null",
                   modelprior = uniform(), initprobs = "eplogp",
                   force.heredity = FALSE, pivot = TRUE)

#' `BAS` uses a model formula similar to `lm` to specify the full model
#'  with all of the potential predictors. Here we are using the 
#'  shorthand . to indicate that all remaining variables in the `data` 
#'  frame provided by the data argument. Different prior distributions 
#'  on the regression coefficients may be specified using the `prior` argument, 
#'  and include AIC, BIC, etc. "JZS" is the newest prior option. 
#'  It corresponds to the Zellner-Siow prior on the coefficients, but
#'  uses numerical integration rather than a Laplace approximation
#'  to obtain the marginal likelihood of models. 
#'  
#'  By default, `BAS` will try to enumerate all models if p<19 using the default
#'  `method="BAS"`. The prior distribution over the models is a `uniform()`
#'  distribution which assigns equal probabilities to all models. The last 
#'  optional argument `initprobs = eplogp` provides a way to initialize the 
#'  sampling algorithm and order the variables in the tree structure that 
#'  represents the model space in BAS. The eplogp option uses the Bayes factor 
#'  calibration of p-values `−eplog(p)` to provide an approximation to the marginal 
#'  inclusion probability that the coefficient of each predictor is zero, using 
#'  the p-values from the full model. Other options for initprobs include 
#'  “marg-eplogp”, “uniform”, and numeric vector of length p.
#'  The option “marg-eplogp” uses p-values from the p simple linear regressions 
#'  (useful for large p or highly correlated variables).
#'  Since we are enumerating under all possible models these options are not 
#'  important and the `method="deterministic"` may be faster if there are no factors 
#'  or interactions in the model.
#'  
#' ### Plots
#'  Some graphical summaries of the out put ma be optained by the `plot` function.
par(mfrow = c(2,2))
plot(crime.ZS, ask = F)

#' Four plots produced. The first is a plot of residuals and fitted values under 
#' Bayesian Model Averaging. Ideally, if our model assumptions hold, we will not
#' see outliers or non-constant variance. The second plot shows the cumulative 
#' probability of the models in the order that they are sampled.This plot indicates
#' that the cumulative probability is leveling off as each additional model adds 
#' only a small increment to the cumulative probability, while earlier, there are 
#' larger jumps corresponding to discovering a new high probability model. The third 
#' plot shows the dimension of each model (the number of regression coefficients 
#' including the intercept) versus the log of the marginal likelihood of the model. 
#' The last plot shows the marginal posterior inclusion probabilities (pip) for 
#' each of the covariates, with marginal pips greater than 0.5 shown in red.  
#' 
#' The variables with pip > 0.5 correspond to what is known as the median probability 
#' model. Variables with high inclusion probabilities are generally important for 
#' explaining the data or prediction, but marginal inclusion probabilities may be 
#' small if there are predictors that are highly correlated, similar to how p-values 
#' may be large in the presence of multicollinearity. 
#' 

crime.ZS
summary(crime.ZS)

#' A list of the top 5 models (in terms of posterior probability) with the 
#' zero-one indicators for variable inclusion. BF is the Bayes factor of
#' each model to the hights probability model. 
#' 
#' ### Visualize the model space
#' See beyond the first five models

par(mfrow = c(1,1))
image(crime.ZS, rotate = F)

#' This plot indicates that the police expenditure in the two years do not 
#' enter the model together, and is an indication of the high correlation 
#' between the two variables.
#' 
#' ### Examine the marginal distributions of two correlated coefficients 

coef.ZS <- coef(crime.ZS)
par(mfrow = c(1,2))
plot(coef.ZS, subset = c(5:6), ask = F) ## take a look at Po1 v Po2

#' The vertical bar represents the posterior probability that the coefficient 
#' is 0 while the bell shaped curve represents the density of plausible 
#' values from all the models where the coefficient is non-zero. This is 
#' scaled so that the height of the density for non-zero values is the 
#' probability that the coefficient is non-zero. Omitting the subset argument 
#' provides all of the marginal distributions.

confint(coef.ZS)

#' the third column is the posterior mean.

plot(confint(coef.ZS, parm = 2:16))
plot(confint(coef(crime.ZS, estimator = "BMA"))) ## all models averaged
plot(confint(coef(crime.ZS, estimator = "HPM"))) ## highest probability model
plot(confint(coef(crime.ZS, estimator = "MPM"))) ## mean probability model
# exclude variables with point masses at zero


