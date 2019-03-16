# Replication codes for the paper "Publication Bias under Aggregation Frictions: Theory, Evidence, and a New Correction Method"

This repository contains the `MATLAB` and `R` code used to make numerical simulations.

## Repository structure
- 01_thresholds
- 02_test
- 03_simulation
- 09_output
- 10_documentation

## 1. Thresholds
The 01_thresholds folder contains the `MATLAB` code to compute the equilibrium thresholds and their associated statistics:
- 00_execute_all ... `execute_all.m` runs the entire code.
- 01_common ... stores the m files to compute thresholds (10_documentation folder contains the detailed explanation of the code.)
- 02_figures ... stores the m files to generate figures
  - intermediate_data ... stores matrix file for Figure B6
- 03_simulate ... store the m files to simulate the bias, omission, and welfare in Table B1

## 2. Test
The 02_test folder contains the `R` and `MATLAB` code to implement the empirical test in Section 3. 
- 01_clean ... `R` code to generate relevant data
  - need to modify the paths in function `path_specify` in `combine_original_specification.R` to local folders that have the stem-based method and data set.
- 02_intermediate_data ... store the intermediate data generated from the `R` code in 01_clean folder as inputs into 03_test
- 03_test ... `MATLAB` code to implement the tests and generate figures. `execute.m` runs the entire code.

## 3. Simulation
The 03_simulation folder contains the `R` code to run simulation to assess the performance of various bias correction methods. `execute.R` runs the entire code.
- need to modify the paths to the folder where stem-based method can be installed.

## 9. Output
The 09_output folder stores all the figure outputs to be used in the paper.

## 10. Documentation
The threshold computation in 01_threshold/01_common requires some explanation to understand. Thus, "computation.pdf" explains the code in detail.

## Computational times
Most codes can be executed in a reasonable time frame below 20 minutes using a 8.00GB RAM and i5-7200U CPU @ 2.50GHz 2.71GHz computer. An exception is the threshold computation in `high_N.m` that takes roughly 2 days using a 16.00GB RAM and i7-5600U CPU @ 2.60GHz 2.60GHz  computer. Due to this computational burden, the computational outputs are stored in the `intermediate_data` folder before turned into figures.
