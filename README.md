# Identifying and Correcting Bias from Time- and Severity- Dependent Reporting Rates in the Estimation of the COVID-19 Case Fatality Rate
## Anastasios Nikolas Angelopoulos, Reese Pathak, Rohit Varma, Michael I. Jordan
Associated preprint: https://arxiv.org/abs/2003.08592
We welcome your feedback.
## Credit
We relied principally on the following references:

For developing the method and R library which we used in our paper:
Reich NG, Lessler J, Cummings DA, Brookmeyer R. Estimating absolute and relative case fatality ratios from infectious disease surveillance
data. Biometrics. 2012;68(2):598–606

For data:
https://github.com/CSSEGISandData/COVID-19
Dong, E., Du, H., & Gardner, L. (2020). An interactive web-based dashboard to track COVID-19 in real time. The Lancet Infectious Diseases.

Thank you:
Anthony Ebert helped write the generate_coronamat function in R, since I was doing it in Python in past versions. He has also pointed out a couple of key bugs in the early codebase. This helped consolidate the code and improved consistency, so thank you Anthony.  Check his GitHub, https://github.com/AnthonyEbert/COVID19data, for an interface to Italy's data and an R package incorporating our code.  

# Dependencies
See Dockerfile.

# Usage
In main.r you can define a list of countries whose relative CFRs you want to compute and plot, and for what dates you would like to compute it.

Rscript main.r -newdata will compute the estimator on the new data defined in the list. Without the -newdata flag, it will just plot based on data cached as a csv in the ./plots folder.

# Contact
mylastnameatberkeleydotedu
