#' Calculates a medication score, based on ATC codes and associated weights
#' 
#' @param atc_data A data.frame with at least columns, `ID`, `ATC`, and `WEIGHT`
#' @inheritParams calc_cci
#'
#' @importFrom dplyr %>%
#' @export
#' 
#' @author Kira E. Detrois
calc_med <- function(atc_data,
                    exp_start,
                    exp_end) {
    med_data <- get_exposure_data(atc_data, 
                                 exp_start, 
                                 exp_end) %>%
                        dplyr::select(ID, ATC, WEIGHT) %>% 
                        dplyr::distinct()
    med_data$WEIGHT[is.na(med_data$WEIGHT)] <- 0
    med_data <- dplyr::group_by(med_data, ID) %>% 
                dplyr::summarise(SCORE=sum(WEIGHT))
    med_data <- add_back_missing_indvs(atc_data, med_data)
    med_data <- dplyr::rename(med_data, MED=SCORE)
    return(med_data)
}