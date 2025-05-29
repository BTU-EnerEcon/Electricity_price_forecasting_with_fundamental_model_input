# The Random Forest (RF) Model

## Overview
The **Random Forest (RF) algorithm** presented in this paper is based on **bagging** (bootstrap aggregation) applied to tree learners. Bagging involves repeatedly selecting **$B$ bootstrap samples** from the training set and fitting **$T_b$ trees** to these samples, where **$B$** is the number of trees, and **$T_b$** represents an individual tree in the Random Forest.

## Model Parameter Estimation
For the model's parameter estimation, inputs **$x = \left[x_1, \ldots, x_N\right]^T \in X$** and responses **$y \in Y$** are introduced. Following training, each tree's prediction is obtained. 

The final prediction is determined by averaging the predictions from all regression trees using the following formula:

```math
 \hat{Y}_{rf}^B(x) = \frac{1}{B} \sum_{b=1}^{B} \hat{Y}_b(x) 
```

where **$\hat{Y}_b(x)$**, **$b=1,\ldots,B$** is the prediction of the **$b_{th}$** RF tree.

## Applications
This model is widely used for **short-term Electricity Price Forecasting (EPF)** and has been shown to provide accurate forecasts (Ludwig et al. 2015, Pórtoles et al. 2018, and Mei et al. 2014)).

## References
- Ludwig, Nicole, Stefan Feuerriegel, and Dirk Neumann (2015). “Putting Big Data analytics to work: Feature selection for forecasting electricity prices using the LASSO and random forests”. In: Journal of Decision Systems 24.1, pp. 19–36.
- Pórtoles, Javier, Camino González, and Javier M Moguerza (2018). “Electric- ity price forecasting with dynamic trees: a benchmark against the random forest approach”. In: Energies 11.6, p. 1588.
- Mei, Jie, Dawei He, Ronald Harley, Thomas Habetler, and Guannan Qu (2014). “A random forest method for real-time price forecasting in New York electricity market”. In: 2014 IEEE PES General Meeting| Conference & Exposition. IEEE, pp. 1–5.

## Implementation
This model can be implemented using Python with the `scikit-learn` library. 
For further details, check the full documentation in `Random Forest/`.


