# ICCI

<!-- badges: start -->
<!-- badges: end -->

- This is an R package that calculates the Charlson Comorbidity Index (CCI) on longitudinal ICD data, using the R package `comorbidity`. 
    - The data should have at least the columns `ID` and `PRIMARY_ICD`, and `ICD_VERSION`.
    - If you want to restrict the exposure period to calculate the index on, the data needs an additional column `EVENT_AGE`.
- The package can handle different ICD-versions for the same individual.
    - Possible entries for the column `ICD_VERSION` are "10", "10CM", "9", or "9CM".
- Can also be used to calculate a medication score for data with ATC codes and associated weights.

### R package Dependencies

- assertthat (For testing)
- comorbidity (>= 1.0.0, For calculating the CCI)
- dplyr (For data manipulation)
- tibble (For better data.frames)


## Installation

You can install the development version of ICCI from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dsgelab/ICCI")
```

In FinnGen you can find the `ICCI` and `comorbidity` packages at `/finngen/shared/icci_pckg_share/20241108_090028/files/detrois_share/packages` or alternatively upload the package from this repository through green uploads.

Then in the Sandbox use i.e.

```{r example}
# In case the default R version is not the same as the one for which the package was build.
rpkgs_path <- "/path/to/installed/rpackges/for/this/version/" i.e. /home/ivm/R/x86_64-pc-linux-gnu-library/4.4
.libPaths(c(rpkgs_path, .libPaths()))  
libpath <- .libPaths()[1]
install.packages("/finngen/shared/icci_pckg_share/20241108_090028/files/detrois_share/packages/ICCI_2.3.1.tar.gz",
                 rpkgs_path,
                 repos = NULL, 
                 type="source")
```

Also see: [How to install a R package into Sandbox?](https://finngen.gitbook.io/finngen-analyst-handbook/working-in-the-sandbox/quirks-and-features/how-to-upload-to-your-own-ivm-via-finngen-green/my-r-package-doesnt-exist-in-finngen-sandbox-r-rstudio.-how-can-i-get-a-new-r-package-to-finngen). 

Do the same for the [comorbidity](https://cran.r-project.org/web/packages/comorbidity/) package. In FinnGen you can find it at `/finngen/shared/icci_pckg_share/20241108_090028/files/detrois_share/packages/comorbidity_1.1.0.tar.gz`.

## Example

The data frame `icd_data` needs to contain the columns `EVENT_AGE`, `PRIMARY_ICD`, and `ICD_VERSION`.

```{r example}
library(dplyr)
library(tibble)
library(comorbidity)
library(ICCI)

file_name <- "/path/to/file/longitudinal_icd_data.txt"
icd_data <- readr::read_delim(file_name)
score_data <- ICCI::calc_cci(icd_data)
score_data_age_20_to_30 <- ICCI::calc_cci(icd_data, 
                                          exp_start=20,
                                          exp_end=30)
```

For variable exposure windows for different individuals there are two options:

1. Give either or both `exp_start`, and `exp_end` vectors of the exact same length as the
original data with the  different exposure periods. This is the ideal option if the start and end of the expsoure period are already part of the same data.frame as the ICD data.

```{r example}
mock_data <- tibble::tibble(ID=c("KT0000001", "KT0000002", "KT0000001"), 
                            EVENT_AGE=c(12.3, 89, 23.4), 
                            PRIMARY_ICD=c("Y728", "M797", "E283"), 
                            ICD_VERSION=c("10", "10", "10"),
                            EXP_START=c(10, 40, 10),
                            EXP_END=c(50, 70, 50))
ICCI::calc_cci(icd_data=mock_data,
               exp_start=mock_data$EXP_START,
               exp_end=mock_data$EXP_END)
```

2. Give both `exp_start` and `exp_end`  a data.frame with each a column `ID`, and then `EXP_START` for the `exp_start` argument and `EXP_END`, for the `exp_end` argument. This way ensures that the exposures are mapped to the correct IDs. Thus, this is the better option if the information on the exposure window comes from another data source. 

```{r example}
mock_data <- tibble::tibble(ID=c("KT0000001", "KT0000002", "KT0000001"), 
                            EVENT_AGE=c(12.3, 89, 23.4), 
                            PRIMARY_ICD=c("Y728", "M797", "E283"), 
                            secondary_ICD=c(NA, NA, NA), 
                            ICD_VERSION=c("10", "10", "10"))
EXP_START <- tibble::tibble(ID=c("KT0000001", "KT0000002"),
                            EXP_START=c(10, 40))
EXP_END <- tibble::tibble(ID=c("KT0000001", "KT0000002"),
                          EXP_END=c(50, 70))

ICCI::calc_cci(icd_data=mock_data,
               exp_start=EXP_START,
               exp_end=EXP_END)
```