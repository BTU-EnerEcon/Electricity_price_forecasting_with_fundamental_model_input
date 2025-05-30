# Electricity_price_forecasting_with_fundamental_model_input
This repository presents a novel approach combining a techno-economic energy system model with an econometric model to enhance electricity price forecasting accuracy. The methodology is tested on the German day-ahead wholesale electricity market with hourly data sample between 2015 and 2024. The analysis is carried out across three historical periods and under three different modeling scenarios.
This repository contains the code and data needed to reproduce the results from our paper.


---

## Step-by-Step Usage

### 1. Run the ESM Model

- Use the input data provided to simulate the **Market Clearing Price (MCP)**.
- All relevant files are located in the `Energy System Modeling/` directory.

---

### 2. Econometric Modeling Scenarios

Three scenarios are implemented for forecasting electricity prices using econometric models:

#### **Scenario 1: Exogenous Variables Only**
- Inputs:  
  - Day-ahead wind and solar production  
  - Day-ahead load forecast  
  - Coal, CO₂, and gas prices  
- MCP is **not included** in this setup.  
- This corresponds to the first part of **Table 2** and **Table 3** in the paper.

#### **Scenario 2: Exogenous Variables + MCP**
- Adds MCP (from the ESM model) as an additional regressor.

#### **Scenario 3: MCP Only**
- Uses MCP as the **sole** input variable, excluding all others.

➡ You can find:
- Code in `Econometric Models/`  
- Inputs in `Input/`  
- Outputs in `Output/`

---

### 3. Test Periods

We evaluate the models over three distinct historical timeframes:

1. **2019–2020**: Pre-COVID, pre-energy crisis  
2. **2021–2022**: Energy crisis onset (training includes 2017–2022)  
3. **2023–2024**: Post-crisis period (training includes 2019–2024)

Each period has a dedicated dataset in the `Input/` folder.

---

### 4. Model Implementation Notes

- **LAREX (Lasso with Exogenous Variables)**:  
  A single run includes all three scenarios.

- **Random Forest**:  
  One script covers all three scenarios.

- **LARE, LSTM, DNN**:  
  Each scenario must be run **separately** with the corresponding dataset.

> **Note**:  
> The **DNN**, **LEAR**, and their **ensemble versions** are replications of the original code from *Lago et al. (2021)*.  
> We have only modified the **input data** and the **calibration windows** used in the LEAR ensemble model, as explained in the paper.

---

### 5. Evaluation

Forecasting results are saved in the `Output/` directory and can be used as input to the evaluation module.

The evaluation includes:
- Evaluation metrics- MAE, sMAPE, RMSE,..
- **Giacomini–White (GW) test** Statistical test for forecast Evaluation 


- **Economic Storage Optimization**  
 We simulate a storage operator using day-ahead price forecasts to decide daily charge/discharge actions for three storage types with different energy-to-capacity ratios and efficiencies.

   - Code for this application is in the Storage_Dispatch/ folder.

   - The dispatch optimization uses forecasted prices to maximize revenue, then calculates actual profit based on real market prices.

   - Forecasts are evaluated by comparing revenue to the perfect-forecast benchmark.
---

## 📄 Citation

Lago, Jesus, Grzegorz Marcjasz, Bart De Schutter, and Rafał Weron (2021).
“Forecasting day-ahead electricity prices: A review of state-of-the-art al-
gorithms, best practices and an open-access benchmark”. In: Applied Energy 293, p. 116983.

---




