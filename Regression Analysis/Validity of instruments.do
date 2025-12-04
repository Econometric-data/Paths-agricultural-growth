// Clear existing data and memory
clear all

// Set working directory to current path (assuming the Excel file is here)
cd "."


// Import and Setup Data
import excel "Database for regression.xlsx", sheet("Base de dados") firstrow

// Transformations
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

// Panel Setup
xtset Codigo Ano, delta(5)

// Define your lists of variables for easier handling
// CONTROLS: Variables that affect Production DIRECTLY (Exogenous)
local controls "TangarádaSerra Diamantino Cáceres PonteseLacerdaComodoro MirassolDoeste Sinop Sorriso Juína AltaFloresta PeixotodeAzevedoGuarantãdo Juara BarradoGarças ConfresaVilaRica ÁguaBoa Rondonópolis PrimaveradoLeste Jaciara year1980 year1985 year1995 year2006"

// INSTRUMENTS: Variables that affect Tillage but NOT Production directly (Excluded)
// Note: Ensure lTFP, lPIA, etc. are truly excluded instruments.
local instruments "lTFP lPIA lAnnualInvestment lCapitalStock"

// =========================================================
// Using xtivreg2 (Professional Standard)
// This single command runs the regression AND the tests automatically
// =========================================================

xtivreg2 lProduction `controls' (lTotalTillage = `instruments'), fe robust endog(lTotalTillage)

// INTERPRETATION OF XTIVREG2 OUTPUT:
// 1. "Underidentification test": Checks if the model is identified.
// 2. "Weak identification test": Look for Kleibergen-Paap rk Wald F statistic. 
//    Compare this to the Stock-Yogo values below it. (Should be > 10).
// 3. "Hansen J statistic": Checks Overidentification. You want P-Val > 0.10.
// 4. "Endogeneity test": Checks if lTotalTillage is actually endogenous.
//    If P-Val < 0.05, you were right to use IV. If P-Val > 0.05, regular OLS/RE is fine.
