
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


