#' Gets individuals matching exposure window
#' 
#' Subsets the data.frame to only include the entries from individuals
#' inside the exposure period. By default gets all data from the 
#' data.frame. The exposure has to be given as age. In this case the
#' data.frame also needs to have a column `EVENT_AGE`.
#' 
#' If either or both `exp_start` and `exp_end` are provided restricts
#' the entries to the exposure period for each individual.
#' 
#' @param long_data A data.frame with at least columns `ID`, and 
#'                  `PRIMARY_ICD`.
#' @param exp_start A numeric, or a data.frame with at least columns
#'                  `ID`, and `EXP_START`.
#'                  Start of the exposure period. Can be used to restrict 
#'                  the timeframe on which the index should be calculated. 
#'                  In this case the `icd_data` data.frame needs column 
#'                  `EVENT_AGE`. 
#'                  If the numeric is a vector has to have the length of
#'                  the number of rows in `icd_data`.
#' @param exp_end A numeric, or a data.frame with at least columns
#'                  `ID`, and `EXP_END`.
#'                  End of the exposure period. See `exp_start` docu.
#' 
#' @export
#' 
#' @author Kira E. Detrois 
get_exposure_data <- function(long_data,
                              exp_start=NULL,
                              exp_end=NULL) {
    if(!is.null(exp_start) | !is.null(exp_end)) {
        assertthat::assert_that("EVENT_AGE" %in% colnames(long_data))
        # Replacing any missing with values outside human life-spans
        if(is.null(exp_end)) {
            exp_end = 200 # Change this in case super humans exist
        } else if(!is.data.frame(exp_end) & any(is.na(exp_end))) {
            exp_end[is.na(exp_end)] = 200 # Change this in case super humans exist
        } 
        if(is.null(exp_start)) {
            exp_start = 0
        } else if(is.null(exp_start)) {
            exp_start[is.na(exp_start)] = 0
        }
        if(!is.data.frame(exp_end)) {
            long_data <- tibble::add_column(long_data, 
                                            EXP_END=exp_end) 
        } else {
            long_data <- dplyr::inner_join(exp_end, long_data, by="ID")
        }
        if(!is.data.frame(exp_start)) {
            long_data <- tibble::add_column(long_data, 
                                            EXP_START=exp_start) 
        } else {
            long_data <- dplyr::inner_join(exp_start, long_data, by="ID")
        }
        long_data <- dplyr::filter(long_data, 
                                    EVENT_AGE >= EXP_START & 
                                    EVENT_AGE <= EXP_END) %>%
                     dplyr::select(-EXP_END, -EXP_START)
    }

    return(long_data)               
}