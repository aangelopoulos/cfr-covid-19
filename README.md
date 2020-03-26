# Identifying and Correcting Bias from Time- and Severity- Dependent Reporting Rates in the Estimation of the COVID-19 Case Fatality Rate
## Anastasios Nikolas Angelopoulos, Reese Pathak, Rohit Varma, Michael I. Jordan
Associated paper: https://arxiv.org/abs/2003.08592
## Credit
We relied principally on the following references:

For developing the method and R library which we used in our paper:
Reich NG, Lessler J, Cummings DA, Brookmeyer R. Estimating absolute and relative case fatality ratios from infectious disease surveillance
data. Biometrics. 2012;68(2):598–606

For data:
https://github.com/CSSEGISandData/COVID-19
Dong, E., Du, H., & Gardner, L. (2020). An interactive web-based dashboard to track COVID-19 in real time. The Lancet Infectious Diseases.

# Setup
Use `bash setup.sh` to set up the repo.

# Dependencies
All R dependencies are included in the Dockerfile.
The python dependencies are standard.

# Usage
We use R for the estimation and python to parse the CSSE data. Run `process_data.py` and `process_data_bystate.py` to generate numpy arrays which the R script will read.
Then, run `Rscript global_cfr.r` for the global estimation performed in Table 1 of our paper, and run `Rscript relative_cfr.r` for the estimation by country.
In order to change the relative cfr estimate, inside `relative_cfr.r`, change the line `FILE=...` to `FILE="./numpy_data/Country1_Country2.npy". 
For example, `FILE="./numpy_data/China_Italy.npy"`

Ignore the warnings resulting from the EM procedure. (See coarseDataTools for details on this).

# Contact
mylastnameatberkeleydotedu
