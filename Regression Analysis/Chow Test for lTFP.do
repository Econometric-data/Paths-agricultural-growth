// Clear existing data and memory
clear all

// Set working directory to current path (assuming the Excel file is here)
cd "."

// Import data from Excel
import excel "Database for regression.xlsx", sheet("Base de dados") firstrow

// Generate log variables
gen lProduction = ln(Production)
gen lProductivity = ln(Productivity)
gen lOccupiedPeople = ln(OccupiedPeople)
gen lTotalTillage = ln(TotalTillage)
gen lAnnualInvestment = ln(AnnualInvestment)
gen lCapitalStock = ln(CapitalStock)
gen lPlantedPastages = ln(PlantedPastages)
gen lNaturalPastages = ln(NaturalPastages)
gen lTotalPastages = ln(TotalPastages)
gen lPIA = ln(PIA)
gen lTFP = ln(TFP)
drop if Ano == 1995

// Set panel data
xtset Codigo Ano, delta(5)

// Create structural break dummy (1 for years after 1995, 0 otherwise)
gen post1995 = (Ano > 1995)

// Create interaction term for lTFP with post-1995 dummy
gen TFP_post1995 = TFP * post1995


// Run unrestricted model (full sample with interaction)
xtivreg lProduction (lTotalTillage = TFP TFP_post1995 lPIA lAnnualInvestment lCapitalStock TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste Jaciara year1980 year1985 year1995 year2006), re vce(robust)
predict yhat_unrestricted, xb
gen res_unrestricted = lProduction - yhat_unrestricted
gen res_unrestricted_sq = res_unrestricted^2
sum res_unrestricted_sq

// Run model previous to 1995 (1975, 1980 and 1985 years)
drop if Ano > 1995
xtivreg lProduction (lTotalTillage = TFP TFP_post1995 lPIA lAnnualInvestment lCapitalStock TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste Jaciara year1980 year1985), re vce(robust)
predict yhat_prev_95, xb
gen res_prev_95 = lProduction - yhat_prev_95
gen res_prev_95_sq = res_prev_95^2
sum res_prev_95_sq


// Run model previous to 1995 (1975, 1980 and 1985 years)
clear all
cd "."
import excel "Database for regression.xlsx", sheet("Base de dados") firstrow

// Generate log variables
gen lProduction = ln(Production)
gen lProductivity = ln(Productivity)
gen lOccupiedPeople = ln(OccupiedPeople)
gen lTotalTillage = ln(TotalTillage)
gen lAnnualInvestment = ln(AnnualInvestment)
gen lCapitalStock = ln(CapitalStock)
gen lPlantedPastages = ln(PlantedPastages)
gen lNaturalPastages = ln(NaturalPastages)
gen lTotalPastages = ln(TotalPastages)
gen lPIA = ln(PIA)
gen lTFP = ln(TFP)

// Set panel data
xtset Codigo Ano, delta(5)

// Create structural break dummy (1 for years after 1995, 0 otherwise)
gen post1995 = (Ano > 1995)

// Create interaction term for lTFP with post-1995 dummy
gen TFP_post1995 = TFP * post1995

drop if Ano < 2006

ivreg lProduction (lTotalTillage = TFP TFP_post1995 lPIA lAnnualInvestment lCapitalStock TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste Jaciara year1980 year1985)
predict yhat_prev_2006, xb
gen res_prev_2006 = lProduction - yhat_prev_2006
gen res_prev_2006_sq = res_prev_2006^2
sum res_prev_2006_sq

