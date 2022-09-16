#' Adds individuals without scores, setting their CCI to 0
#' 
#' If some individuals have not diagnosis in the exposure window
#' they will get exluded from the calculation. This function adds
#' them back setting their score to 0. 
#' 
#' @param icd_data A data.frame with at least columns `ID`, the original
#'                   data.
#' @param score_data A data.frame with at least columsn `ID`, and `SCORE`.
#' 
#' @return  A data.frame with all individuals 
#' 
#' @author Kira E. Detrois
add_back_missing_indvs <- function(code_data, 
                                   score_data) {
    id_tib <- dplyr::select(code_data, ID) %>% dplyr::distinct()
    full_scores <- dplyr::left_join(id_tib, score_data, by="ID")
    full_scores$SCORE[is.na(full_scores$SCORE)] <- 0
    return(full_scores)
}