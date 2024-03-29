#' Calculates the Charlson Comorbidity Index based on ICD-codes
#'
#' Maps the ICD-codes onto the relevant conditions for the 
#' charlson-deyo comorbidity index, using the function 
#' \code{\link[comorbidity]{comorbidity}}.
#' Then calculates the scores, using the function 
#' \code{\link[comorbidity]{score}}.
#'
#' Can handle different ICD-versions also for a single patient by
#' adding up the results.
#'
#' @param icd_data A data.frame with at least columns `ID`, and 
#'                  `PRIMARY_ICD`.
#' @inheritParams get_exposure_data
#' @param score_type A character. Describes, whether to use the CCI
#'                   or elixhauser comorbidity index (EI).
#'                   Can be either `charlson`, or `elixhauser`.   
#' 
#' @return A tibble with columns `ID` and `CCI`, or `EI` depending on the 
#'         `score_type` used. Contains the charlson weighted comorbidity 
#'          scores for each individual.
#'
#' @importFrom dplyr %>%
#' @export
#' 
#' @author Kira E. Detrois
calc_cci <- function(icd_data,
                     exp_start=NULL,
                     exp_end=NULL,
                     score_type="charlson") {
    if(!(score_type %in% c("charlson", "elixhauser")) )
        warning("From ICCI::calc_cci. CCI score type ", score_type, " not known. Can be either `charlson`, or `elixhauser`")
    process_icd_data <- preprocess_icd_data(icd_data, exp_start, exp_end)
    if(nrow(process_icd_data) > 0) {
        group_icd_data <- group_icd_data_by_ver(process_icd_data)

        # For adding up different ICD-version scores
        all_cci_scores <- tibble::tibble()
        for (ICD_VERSION in as.character(group_icd_data$keys)) {
            curnt_icd_data <- get_group_icd_data(group_icd_data, 
                                                 ICD_VERSION)
            curnt_cci_scores <- calc_icd_ver_spec_ccis(curnt_icd_data, 
                                                       ICD_VERSION,
                                                       score_type=score_type)
            all_cci_scores <- dplyr::bind_rows(all_cci_scores, 
                                               curnt_cci_scores)
        }
        # Adds up the scores from the same individual with different ICD-version
        # entries.
        total_cci_scores <- add_up_cci_scores(all_cci_scores)
        total_cci_scores <- add_back_orig_ids(total_cci_scores, 
                                            process_icd_data) 
        full_scores <- add_back_missing_indvs(icd_data, total_cci_scores)
    } else {
        full_scores <- tibble::add_column(icd_data, SCORE=rep(0, nrow(icd_data)))
    }
    if(score_type == "charlson") {
        full_scores <- dplyr::rename(full_scores, CCI=SCORE)
        full_scores <- dplyr::select(full_scores, ID, CCI)
    }
    else {
        full_scores <- dplyr::rename(full_scores, EI=SCORE)
        full_scores <- dplyr::select(full_scores, ID, EI)
    }
    return(full_scores)
}