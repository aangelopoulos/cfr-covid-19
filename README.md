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

Thank you:
Anthony Ebert helped write the generate_coronamat function in R, since I was doing it in Python in past versions. He has also pointed out a couple of bugs. This helped consolidate the code and improved consistency, so thank you Anthony.  Check his GitHub, https://github.com/AnthonyEbert/ItalyCovid19, for an interface to Italy's data and an R package incorporating our code.  

# Dependencies
I have to update the Dockerfile within the next few days, but most dependencies are there, and others are standard in CRAN.

# Usage
Rscript relative_cfr.r

In order to change the relative cfr estimate, inside `relative_cfr.r`, change COUNTRY1 and COUNTRY2. If COUNTRY1==COUNTRY2, then it will calculate the absolute CFR based on a simulated outbreak.

It is important to note, as in the paper, that the CFR is a time-dependent quantity. The package from Reich et al. which we use does not account for the fact that outbreaks may be at different stages when their relative CFR is queried; so comparing South Korea to Italy, for example, will give strange results. Aligning these outbreaks so their start times are roughly the same would help, but I haven't implemented this yet. In summary, for now, the relative comparison will be most helpful for comparing between current, ongoing outbreaks in similar stages (e.g. Germany and Italy). 

Ignore the warnings resulting from the EM procedure. (See coarseDataTools for details on this).

# Contact
mylastnameatberkeleydotedu
