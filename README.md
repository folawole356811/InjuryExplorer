# injuryExplorer

An R package containing a Shiny application for exploring emergency room injury data from the *Mastering Shiny* ER injuries case study.

## Features

- Interactive graphical summaries
- Numerical summaries
- Frequency tables
- Patient narratives by body part
- Injury location exploration tab

## Installation

```r
install.packages("remotes")
remotes::install_github("folawole356811/InjuryExplorer")
```

## Usage

```r
library(injuryExplorer)

run_app()
```

## Package Structure

```text
R/
├── app_ui.R
├── app_server.R
└── run_app.R
```

## Data Source

The app uses the ER injuries data from the *Mastering Shiny* case study.

## Author

Funmi Olawole