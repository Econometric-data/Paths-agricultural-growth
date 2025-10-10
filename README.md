# Project Analysis

This repository contains the code and data used for analyzing economic data, including Python scripts for graphs and Stata do-files for regression analysis.

---

## Project Structure

The project is organized into the following main directories:

### `Descriptive data`
This directory contains the Python code used to generate to make descriptive statistics.

* **`Description of data.ipynb`**: A Jupyter Notebook file containing the Python code for the statistics.

---

### `Graphs`
This directory contains the Python code used to generate the graphs so as the data used in the plots.

* **`Graphs.ipynb`**: A Jupyter Notebook file containing the Python code for data visualization and graph creation.
* **`MT to MS GDP.ipynb`**: A Jupyter Notebook file containing the Python code for plot the GDP for Mato Grosso and Mato Grosso do Sul.
---

### `Regression Analysis`
This directory holds the data files and Stata do-files used for regression analysis.

* **`Chow Test for Kandir Law.do`**: Stata do-file for performing a Chow Test related to the Kandir Law analysis.
* **`Chow Test for lTFP.do`**: Stata do-file for performing a Chow Test on the lTFP (log of Total Factor Productivity) data.
* **`Production - regression estimation.do`**: Stata do-file containing the code for estimating production function regressions.
* **Data Files**: This folder also contains the necessary data files used by the Stata do-files.

---


### How to Use This Repository

To utilize the contents of this repository, please follow these steps:

1.  **Download all content:** Download or clone the entire repository to your local machine. Ensure that the `Graphs` and `Data and Regression Analysis` folders, along with their contents, are intact in your local directory.
2.  **Run the codes:**
    * **For Python Graphs:** Open `Graphs/Graphs.ipynb` in a Jupyter Notebook environment (e.g., Anaconda Navigator, VS Code with Jupyter extension). The code within the notebook is prepared to import data from its relative location within the downloaded folders.
    * **For Stata Regressions:** Open the `.do` files located in `Data and Regression Analysis/` (e.g., `Chow Test for Kandir Law.do`, `Chow Test for lTFP.do`, `Production - regression estimation.do`) using Stata. These do-files are configured to import the necessary data directly from their respective locations within the downloaded folders.
