#' Creates a tibble with random ICD-codes entries
#' 
#' Creates a tibble with random ICD-codes entries, 
#' using the function \code{\link[comorbidity]{sample_diag}}. The 
#' results are meant to mimic INTERVENE longitudinal files for
#' testing.
#'
#' For each entry the age at event is drawn from a uniform 
#' distribution. The functions also adds a certain percentage of 
#' secondary ICD-codes.
#'
#' @param indv_ids A string. 
#'                 IDs of the individuals.
#' @param n_samples An integer. 
#'                  Total number of samples to draw for the individuals
#' @param ICD_VERSION The ICD version to draw the samples from.
#'                    Can be either `ICD10_2009`, `ICD10_2011`, or
#'                    `ICD9_2015`. The default is `ICD10_2011`.
#' @param percent_sec_icd Percentage of secondary ICD-codes to add
#'                        to the records.
#' 
#' @return A tibble with columns `ID`, `EVENT_AGE`, `PRIMARY_ICD`,
#' and `secondary_ICD`. Filled with random ICD codes, and age at event.
#'
#' @examples
#' indv_ids = c("KT001","KT002","KT004","KT005","KT006")
#' create_test_df(indv_ids, 50, "ICD10_2011")
#'
#' @export
#' 
#' @author Kira E. Detrois
create_test_df <- function(indv_ids,
                           n_samples,
                           ICD_VERSION="ICD10_2011",
                           percent_sec_icd=0.05) {

    n_secondary_icd <- ceiling(percent_sec_icd * n_samples)
    id_samples <- sample(indv_ids, size = n_samples, replace = TRUE)
    age_samples <- round(stats::runif(n_samples, min = 0, max = 100), 1)
    prim_icd_samples <- comorbidity::sample_diag(n = n_samples,
                                                 version = ICD_VERSION)
    sec_icd_samples <- c(comorbidity::sample_diag(n = n_secondary_icd,
                                                  version = ICD_VERSION),
                         rep(NA, n_samples - n_secondary_icd))
    tibble::tibble(
        ID = id_samples,
        EVENT_AGE = age_samples,
        PRIMARY_ICD = prim_icd_samples,
        secondary_ICD = sec_icd_samples
    )
}

#' Creates a data.frame with random ICD-code entries
#' 
#' Creates a tibble with random ICD-codes entries from different 
#' ICD-versions using the function \code{\link{create_test_df}}. 
#' The results are meant to mimic INTERVENE longitudinal files for
#' testing.
#'
#' It is possible to create a mix of ICD-10 and ICD-9 codes to create
#' a more realistic testing dataset.
#'
#' @param n_icd10 Number of draws from ICD10
#' @param n_icd9 Number of draws from ICD9
#' @param icd10_indv A character vector.
#'                   The names of the individuals with ICD10 codes.
#' @param icd9_indv A character vector.
#'                  The names of the individuals with ICD9 codes.
#' 
#' @return A tibble with columns `ID`, `EVENT_AGE`, `PRIMARY_ICD`,
#' and `secondary_ICD`. Filled with random ICD codes, and age at event.
#' 
#' @importFrom dplyr %>%
#' @export
#' 
#' @author Kira E. Detrois
create_test_df_multi_icd_ver <- function(n_icd10=50,
                                         n_icd9=0,
                                         icd10_indv=c("KT0000001", "KT0000002", "KT0000004", "KT0000005","KT0000006"), 
                                         icd9_indv=c("KT0000005", "KT0000007", "KT0000002", "KT0000008", "KT0000009")) { 
    samples_icd10 <- create_test_df(icd10_indv, n_icd10, "ICD10_2011")
    samples_icd9 <- create_test_df(icd9_indv, n_icd9, "ICD9_2015")
    ICD_VERSIONs <- c(rep("10", n_icd10), rep("9", n_icd9))
    samples <- dplyr::bind_rows(samples_icd10, samples_icd9) %>%
                tibble::add_column(ICD_VERSION = ICD_VERSIONs)
}

#' Creates test ATC data
#' 
#' @param indv_ids A character. IDs of the individuals.
#' @param n_samples A numeric. The number of samples to draw.
#' 
#' @export 
#' 
#' @author Kira E. Detrois
create_test_atc_data <- function(indv_ids,
                                 n_samples) {
    set.seed(1271)
    zero_weight_atcs <- c("BAHDA91", "JASHFA01", "KAJSDFH2", "AHSGF912", "HSJAS012", "HASGF81S")
    weight_atcs <- c("JKLAKF76", "LAKSHD512", "GASHD8123", "NGAS81HJ", "LAKS8D5A", "JAHS91JS", "HAGST1ZT", "PAJS67T", "SFD91GS", "PLO912JS")
    atcs <- c(zero_weight_atcs, weight_atcs)

    id_samples <- sample(indv_ids, n_samples, replace=TRUE)
    atc_samples <- sample(atcs, n_samples, replace = TRUE)
    age_samples <- round(stats::runif(n_samples, min = 0, max = 100), 1)

    atc_data <- tibble::tibble(ID=id_samples,
                               EVENT_AGE=age_samples,
                               ATC=atc_samples)
    weights <- tibble::tibble(ATC=c("JKLAKF76", "LAKSHD512", "GASHD8123", "NGAS81HJ", "LAKS8D5A", 
                                  "JAHS91JS", "HAGST1ZT", "PAJS67T", "SFD91GS", "PLO912JS"),
                            WEIGHT=c(rep(1, 7), rep(-1, 3)))
    atc_data <- dplyr::left_join(atc_data, weights, by="ATC")
    return(atc_data)
}
