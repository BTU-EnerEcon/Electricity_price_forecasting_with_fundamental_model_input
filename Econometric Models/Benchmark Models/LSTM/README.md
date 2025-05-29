# Long-Short-Term Memory Model

## Overview
One of the most crucial components of both current deep learning models and power market price forecasting is understanding long-term dependencies. This is the starting point for choosing and creating a forecasting model.

Like typical recurrent neural network models, the **Long-Short-Term Memory (LSTM)** model has emerged as a crucial instrument for analyzing complex feature interactions and sequence dependencies. The memory capacity of LSTM is greatly enhanced compared to recurrent neural networks (RNNs). More specifically, LSTM can handle long-term dependencies due to built-in mechanisms that regulate how information is retained or forgotten over time. These models are more effective at handling continuous sequences and are widely used in **electricity price forecasting (EPF)**.

LSTM was first proposed by **Hochreiter & Schmidhuber (1997)** and has since been improved by other researchers to enhance performance.

## LSTM Architecture
The LSTM introduces the concept of "gates," specifically:
- **Forget Gate**: Controls how much information from the previous cell is retained.
- **Input Gate**: Determines what new information is stored in the cell state.
- **Output Gate**: Computes the output for the next step.

## LSTM Equations
The following equations define the functioning of an LSTM cell:

### 1. Input Gate & Candidate Cell State
```math
 i_t = \sigma(W_{xi} x_t + W_{hi} h_{t-1} + b_i)
```
```math
 C_t^* = \tanh(W_{xc} x_t + W_{hc} h_{t-1} + b_c)
```

### 2. Forget Gate & New Cell State
```math
 f_t = \sigma(W_{xf} x_t + W_{hf} h_{t-1} + b_f)
```
```math
 C_t = f_t C_{t-1} + i_t C_t^*
```

### 3. Output Gate & Final Output
```math
 o_t = \sigma(W_{xo} x_t + W_{ho} h_{t-1} + b_o)
```
```math
 h_t = o_t \tanh(C_t)
```

## Notations:
- **$i_t$**, **$f_t$**, **$o_t$**: Input, Forget, and Output gates
- **$W_{xi}$, $W_{xc}$, $W_{xf}$, $W_{xo}$**: Weight matrices
- **$b_i$, $b_c$, $b_f$, $b_o$**: Bias terms
- **$C_t^*$**: Candidate cell state output
- **$\sigma$** and **$	anh$**: Activation functions

## References
- Hochreiter, Sepp and Jürgen Schmidhuber (1997). “Long short-term mem- ory”. In: Neural computation 9.8, pp. 1735–1780.
- Kawakami, Kazuya (2008). “Supervised sequence labelling with recurrent neural networks”. PhD thesis. Technical University of Munich.
  
Additional references on **LSTM applications in EPF**:

- Xiong, Xiaoping and Guohua Qing (2022). “A hybrid day-ahead electricity price forecasting framework based on time series”. In: Energy, p. 126099.
- Li, Wei and Denis Mike Becker (2021). “Day-ahead electricity price predic- tion applying hybrid models of LSTM-based deep learning methods and feature selection algorithms under consideration of market coupling”. In: Energy 237, p. 121543.
- Shao, Zhen, Qingru Zheng, Chen Liu, Shuangyan Gao, Gang Wang, and Yan Chu (2021). “A feature extraction-and ranking-based framework for electricity spot price forecasting using a hybrid deep neural network”. In: Electric Power Systems Research 200, p. 107453.
- Shao, Zhen, Yudie Yang, Qingru Zheng, Kaile Zhou, Chen Liu, and Shanlin Yang (2022). “A pattern classification methodology for interval forecasts of short-term electricity prices based on hybrid deep neural networks: A comparative analysis”. In: Applied Energy 327, p. 120115.

## Usage
This model is implemented in Python using TensorFlow/Keras. For installation and usage, see the full documentation in `LSTM/`.

