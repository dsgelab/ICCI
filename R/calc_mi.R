#' Calculates a medication score, based on ATC codes and associated weights
#' 
#' @param atc_data A data.frame with at least columns, `ID`, `ATC`, and `WEIGHT`
#' @inheritParams calc_cci
#'
#' @importFrom dplyr %>%
#' @export
#' 
#' @author Kira E. Detrois
calc_mi <- function(atc_data,
                    exp_start,
                    exp_end) {
    mi_data <- get_exposure_data(atc_data, 
                                 exp_start, 
                                 exp_end) %>%
                        dplyr::select(ID, ATC, WEIGHT) %>% 
                        dplyr::distinct()
    mi_data$WEIGHT[is.na(mi_data$WEIGHT)] <- 0
    mi_data <- dplyr::group_by(mi_data, ID) %>% 
                dplyr::summarise(SCORE=sum(WEIGHT))
    mi_data <- add_back_missing_indvs(atc_data, mi_data)
    mi_data <- dplyr::rename(mi_data, MI=SCORE)
    return(mi_data)
}