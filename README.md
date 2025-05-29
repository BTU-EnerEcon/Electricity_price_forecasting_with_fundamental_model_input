# Electricity_price_forecasting_with_fundamental_model_input
This repository presents a novel approach combining a techno-economic energy system model with an econometric model to enhance electricity price forecasting accuracy. Tested on the German day-ahead wholesale electricity market.
This repository contains the code and data needed to reproduce the results from our paper combining a techno-economic energy system model (ESM) with econometric forecasting methods to maximise day-ahead electricity price accuracy on the German wholesale market.

## Key Features

- **Hybrid Forecasting Framework**  
  Integrates output from a detailed ESM into standard econometric models (DNN, LEAR, LSTM, LARX, and RF).

- **Regime-Specific Evaluation**  
  Three overlapping train–test periods (2015–18 → 2019–20, 2017–20 → 2021–22, 2019–22 → 2023–24) to assess performance under normal, crisis, and post-crisis volatility.

- **Economic Storage Optimization**  
  Demonstrates up to 10 % additional revenue for a stylised electric storage asset when using the hybrid forecast.

