
# BHAIpkgHafsa

<!-- badges: start -->
<!-- badges: end -->

## Overview

`BHAIpkgHafsa` is an R package developed for visualising and exploring the **burden of Healthcare-Associated Infections (HAIs)** by infection type.  
It provides:

- A **packaged dataset** of HAI burden and attributable deaths.  
- A **Shiny web application** for interactive data exploration.  
- Support for teaching, analysis, and demonstration of infection surveillance data.

---

## Features

- Preloaded, cleaned dataset: `healthcare_associated_infections`  
- nteractive **Shiny dashboard** for exploring infection burden  
- Custom plotting and summary table outputs  
- Fully documented functions and dataset using **roxygen2**  
- Integrated vignette and **pkgdown** documentation website

---

## Usage

library(BHAIpkgHafsa)

#### View the dataset
head(healthcare_associated_infections)

#### Launch the interactive Shiny app
if (interactive()) {
  launch_haiexplorer()
}

## Dataset Description

Dataset name: healthcare_associated_infections

This dataset includes estimated numbers of healthcare-associated infections (HAIs) and attributable deaths across major infection types.

- Infection_Type:	Type of infection (e.g., BSI, HAP, UTI, SSI, CDI)
- Number_of_HAIs:	Estimated number of infection cases
- Number_of_attributable_deaths:	Estimated deaths directly caused by each infection type

## Shiny App Overview

The HAI Explorer App allows users to:

- Select an infection type or view all.

- Switch between total infections and attributable deaths.

- Interactively hover over bars to view exact counts.

- Display a detailed summary table.

App interface styling:

- Custom theme and layout using shinythemes::shinytheme("flatly")

- Enhanced hover interactivity using plotly

- Light, accessible design beyond the default white/grey interface

## Documentation

Full function references, dataset details, and vignettes are available on the package’s pkgdown website:

Documentation site:
https://ETC5523-2025.github.io/assignment-4-packages-and-shiny-apps-Hafsa0005/

You can also access the vignette locally after installation:

# browseVignettes("BHAIpkgHafsa")

## License

This package is licensed under the MIT License — see the LICENSE file for details.

## Author

Hafsa Altaf
Developed as part of ETC5523 — Communicating with Data assignment. (Monash University, 2025).

## Acknowledgements

- Built using the usethis, devtools, and roxygen2 frameworks.

- Interactive visualisation powered by shiny, plotly, and ggplot2.









