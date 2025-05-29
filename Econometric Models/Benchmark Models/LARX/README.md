# LARX: LASSO Autoregressive Model with Exogenous Variables

## Overview

The autoregressive LASSO technique suggested by Li et al.(2017) is also adopted.LARX model is a linear forecasting technique that combines an autoregressive structure with exogenous regressors and LASSO regularization. It is designed to predict day-ahead electricity prices while automatically selecting the most relevant features and avoiding overfitting. Throughout the manuscript, LARX is used to refer to this model.

## Model Specification

For day $\(d\)$ and hour $\(h\)$, let $\(y_{d,h}\)$ be the electricity price and 
```math
\mathbf{x}_{d,h} = (x_{d,h,1}, \dots, x_{d,h,I})^\top

```
 be the vector of $\(I\)$ exogenous regressors. The LARX model is
```math

y_{d,h} = \beta_0 + \sum_{i=1}^{I} \beta_{h,i}\,x_{d,h,i} + \varepsilon_{d,h}, 
\quad
\varepsilon_{d,h} \sim \mathcal{N}(0,\sigma^2).

```
- **$\(\beta_0\)$**: intercept  
- **$\(\beta_{h,i}\)$**: coefficient for regressor $\(i\)$ at hour $\(h\)$  
- **$\(\varepsilon_{d,h}\)$**: Gaussian noise  

## LASSO Regularization

To estimate the coefficient vector $\(\boldsymbol\beta\)$, LARX minimizes the penalized residual sum of squares:

```math
\hat{\boldsymbol\beta} = \arg\min_{\boldsymbol\beta}
\Bigl\{
\sum_{d,h} \bigl(y_{d,h} - \mathbf{x}_{d,h}^\top\boldsymbol\beta\bigr)^2 
\;+\;
\lambda \sum_{i=1}^I \lvert \beta_i\rvert
\Bigr\},
```

where $\(\lambda \ge 0\)$ is the regularization parameter:
- $\(\lambda = 0\)$ → ordinary least squares (no shrinkage)  
- $\(\lambda\)$ large → many coefficients shrink to zero (high sparsity)  

The optimal $\(\lambda\)$ is chosen via $\(k\)$-fold cross-validation. Practically, we estimate the value of $\lambda$ using $k$-fold cross validation (CV) (Hastie et al.(2009)).
The bigger $\lambda$ is, the sparser the solution $\hat{\beta}_{LASSO}$ will be, which means that fewer data points from the input regressors will be used to predict the future. In this way, the algorithm avoids overfitting and takes into account the most relevant regressors (Gareth et al. (2013)).

## Rolling Forecast Procedure
In our research work, the LARX model is included in a daily-rolling forecast structure. The model is reestimated every day based on all past information until that point (beginning in 2019). The model is re-estimated using LASSO and applied to predict the next 24 hourly prices. The predicted values are then appended to the training history so that the model is constantly updated and adapting to new price behavior. At this point of the whole process, this is very similar to a forecasting operation setup.

1. **Initialization**  
   Use all available historical data starting in 2019 (for test sampel 2023-2024).
2. **Daily Re-estimation**  
   At the start of each day $\(d\)$, re-fit the LARX model on data up to day $\(d-1\)$.
3. **Forecasting**  
   Generate 24 one-hour-ahead forecasts $\(\{\hat y_{d,h}\}_{h=1}^{24}\)$.
4. **Update**  
   Append the forecasts to the history for the next day’s estimation.

This mimics an operational day-ahead forecasting pipeline that continuously adapts to new information.

## Exogenous Regressors

Typical regressors $\(x_{d,h,i}\)$ include:
- Day Ahead Solar and Wind 
- Day ahead Load
- EUA
- Gas Price
- Coal Price
- MCP  

*(See the “Regressors” section in the main manuscript for full details.)*

In recent years, LASSO has become increasingly popular in EPF (Ludwig et al. (2015), Ziel et al.(2015)). 
Compared to the LEAR model, LARX represents the foundational version from which Lago et al.(2021) has developed the state-of-the-art LEAR model.

## References

1. Pan Li et al. “A sparse linear model and significance test for individual consumption prediction”. In: IEEE Transactions on Power Systems 32.6 (2017), pp. 4489–4500.
2. Trevor Hastie et al. The elements of statistical learning: data mining, inference, and prediction. Vol. 2. Springer, 2009.  
3. James Gareth et al. An introduction to statistical learning: with applications in R. Spinger, 2013.
4. Nicole Ludwig, Stefan Feuerriegel, and Dirk Neumann. “Putting Big Data analytics to work: Feature selection for forecasting electricity prices using the LASSO and random forests”. In: Journal of Decision Systems 24.1 (2015), pp. 19–36.
5. Florian Ziel, Rick Steinert, and Sven Husmann. “Efficient modeling and forecasting of electricity spot prices”. In: Energy Economics 47 (2015), pp. 98–111.
6. Jesus Lago et al. “Forecasting day-ahead electricity prices: A review of state-of-the-art algorithms, best practices and an open-access benchmark”. In: Applied Energy 293 (2021), p. 116983.

