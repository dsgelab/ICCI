#' Translates ICD-version descriptions 
#' 
#' Translates the ICD-version descriptions "10", "10CM", "9", and "9CM"
#' from an INTERVENE longitudinal file into strings understandable
#' by the function \code{\link[comorbidity]{comorbidity}}.
#'
#' @param icd_version The ICD-version in INTERVENE format.
#'                    Can be either "10", "10CM", "9", or "9CM".
#'
#' @return A string. Either "charlson_icd10_quan", or 
#'         "charlson_icd9_quan".
#' 
#' @export
#' 
#' @author Kira E. Detrois
get_comorb_icd_ver_str <- function(icd_version,
                                   score_type="charlson") {
    if (icd_version %in% c("10", "10CM")) {
        if(score_type == "charlson")
            return("charlson_icd10_quan")
        else if(score_type == "elixhauser")
            return("elixhauser_icd10_quan")
        else 
            message(paste0("Unknown Score type. ", score_type, " Possible values are: `charlson`, `elixhauser`."))
    } else if (icd_version %in% c("9", "9CM")) {
        if(score_type == "charlson")
            return("charlson_icd9_quan")
        else if(score_type == "elixhauser")
            return("elixhauser_icd9_quan")
        else 
            message(paste0("Unknown Score type. ", score_type, " Possible values are: `charlson`, `elixhauser`."))

    } else {
        message(paste0("Unknown ICD-version. ", icd_version, " Ignoring data."))
    }
}