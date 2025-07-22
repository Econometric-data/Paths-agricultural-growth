// Clear existing data and memory
clear all

// Set working directory to current path (assuming the Excel file is here)
cd "."

// Import data from Excel
import excel "Database for regression.xlsx", sheet("Base de dados") firstrow

// Create logarithmic transformations of variables
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

// Set panel data structure
xtset Codigo Ano, delta(5)

// Create lagged differences
gen Productionlag = Production - Production[_n-1]
gen OccupiedPeoplelag = OccupiedPeople - OccupiedPeople[_n-1]
gen TotalTillagelag = TotalTillage - TotalTillage[_n-1]

// Create logarithmic transformations of lagged variables
gen lProductionlag = ln(Productionlag)
gen lOccupiedPeoplelag = ln(OccupiedPeoplelag)
gen lTotalTillagelag = ln(TotalTillagelag)
gen lTFP = ln(TFP)

// Run production function regression with IV

// First stage
xtreg lTotalTillage lTFP lPIA lAnnualInvestment lCapitalStock ///
       TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste ///
       Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara ///
       BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste ///
       Jaciara year1980 year1985 year1995 year2006, re vce(robust)
// Store and export results with standard errors in parentheses
estimates store modelo1
esttab modelo1 using modelo1.rtf, replace se ///
       star(* 0.10 ** 0.05 *** 0.01) ///
       title("First Stage Regression Results") ///
       label nogaps
	  
// Second stage
xtivreg lProduction (lTotalTillage = lTFP lPIA lAnnualInvestment lCapitalStock ///
       TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste ///
       Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara ///
       BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste ///
       Jaciara year1980 year1985 year1995 year2006), re vce(robust)
// Store and export results with standard errors in parentheses
estimates store modelo2
esttab modelo2 using modelo2.rtf, replace se ///
       star(* 0.10 ** 0.05 *** 0.01) ///
       title("Second Stage IV Regression Results") ///
       label nogaps
	   
//Heterokedasticity test
xtreg lTotalTillage lTFP lPIA lAnnualInvestment lCapitalStock TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste Jaciara year1980 year1985 year1995 year2006, re
predict resid, e
gen resid2 = resid^2
reg resid2 lTFP lPIA lAnnualInvestment lCapitalStock TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste Jaciara year1980 year1985 year1995 year2006

//Autocorrelation test
sort Codigo Ano
by Codigo: gen resid_lag = resid[_n-1] 
bysort Codigo: corr resid resid_lag 

// Comparing models
// Run the models and store results
xtreg lTotalTillage lTFP lPIA lAnnualInvestment lCapitalStock ///
       TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste ///
       Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara ///
       BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste ///
       Jaciara year1980 year1985 year1995 year2006, re
estimates store Model1

xtreg lTotalTillage lTFP lPIA lAnnualInvestment lCapitalStock ///
       TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste ///
       Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara ///
       BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste ///
       Jaciara year1980 year1985 year1995 year2006, re vce(robust)
estimates store Model2

xtreg lTotalTillage lTFP lPIA lAnnualInvestment lCapitalStock ///
       TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste ///
       Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara ///
       BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste ///
       Jaciara year1980 year1985 year1995 year2006, re vce(cluster Codigo)
estimates store Model3

xtreg lTotalTillage lTFP lPIA lAnnualInvestment lCapitalStock ///
       TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste ///
       Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara ///
       BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste ///
       Jaciara year1980 year1985 year1995 year2006, re vce(robust) nosa
estimates store Model4

// Generate a table with coefficients, standard errors in parentheses
esttab Model1 Model2 Model3 Model4 ///
    using "Variance_estimators.rtf", ///
    replace ///
    b(%9.4f) se(%9.4f) ///
    se ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N chi2, fmt(%9.0g %9.2f) ///
    labels("Observations" "Wald chi2")) ///
    mtitles("Model 1 (Swamy-Arora)" "Model 2 (Huber-White)" "Model 3 (Cluster)" "Model 4 (Robust, Baltagi-Chang)") ///
    title("Comparison of Different Variance Estimators") ///
    label nogaps

