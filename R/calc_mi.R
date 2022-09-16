#' @importFrom dplyr %>%
#' @export
calc_mi <- function(atc_data,
                    exp_start,
                    exp_end,
                    weights) {
    atc_exp_data <- get_exposure_data(atc_data, 
                                      exp_start, 
                                      exp_end) %>%
                        dplyr::select(ID, ATC) %>% 
                        dplyr::distinct()
    # Counting each medication only once
    mi_data <- dplyr::left_join(atc_exp_data, 
                                weights, 
                                by="ATC")
    mi_data$WEIGHT[is.na(mi_data$WEIGHT)] <- 0
    mi_data <- dplyr::group_by(mi_data, ID) %>% 
                dplyr::summarise(SCORE=sum(WEIGHT))

    mi_data <- add_back_missing_indvs(atc_data, mi_data)
    mi_data <- dplyr::rename(mi_data, MI=SCORE)
    return(mi_data)
}