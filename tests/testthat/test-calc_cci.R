
test_that("calc_cci with integer icd_version doesn't throw error", {
  set.seed(82312)
  sample_data <- create_test_df_multi_icd_ver() 
  sample_data$ICD_version <- as.integer(sample_data$ICD_version)
  # No error
  expect_error(calc_cci(sample_data), regexp=NA)
})

test_that("calc_cci works", {
  set.seed(82312)
  sample_data <-create_test_df_multi_icd_ver(n_icd10 = 100) 
  
  # Adding a test code in ICD-9 for patient 2
  sample_data <- tibble::add_row(sample_data, 
                                  ID = "KT0000002", 
                                  Event_age = 74, 
                                  primary_ICD = "2000", 
                                  secondary_ICD = NA, 
                                  ICD_version = "9")
  cci_scores <- calc_cci(sample_data)
  # First patient has CPD and nothing else -> score of 1
  expect_equal(dplyr::filter(cci_scores, ID == "KT0000001")$CCI, 1)

  # Second patient has two cancer records, 
  # peptic ulcers (pud), and hemiplegia (hp) -> score of 7
  expect_equal(dplyr::filter(cci_scores, ID == "KT0000002")$CCI, 7)
})

test_that("calc_cci with exposure window", {
  set.seed(82312)
  sample_data <- create_test_df_multi_icd_ver(n_icd10 = 100)
  # Adding a test code in ICD-9 for patient 2
  sample_data <- tibble::add_row(sample_data,
                                 ID = "KT0000002",
                                 Event_age = 74,
                                 primary_ICD = "2000",
                                 secondary_ICD = NA,
                                 ICD_version = "9")

  cci_scores <- calc_cci(sample_data)

  cci_scores <- calc_cci(sample_data, exp_start = 20, exp_end = 60)
  # First patient has CPD and nothing else -> score of 1
  expect_equal(dplyr::filter(cci_scores, ID == "KT0000001")$CCI, 1)

  # Second patient has hemiplegia (2) + ulcer (1) --> score of 3
  expect_equal(dplyr::filter(cci_scores, ID == "KT0000002")$CCI, 3)
})

test_that("calc_cci missing indvs zero works", {
  set.seed(82312)
  sample_data <- create_test_df_multi_icd_ver(n_icd10 = 5)
  sample_data <- tibble::add_row(sample_data, ID="KT000001", Event_age=5, primary_ICD="XZY", ICD_version="10")

  cci_scores <- calc_cci(sample_data, exp_start = 6)
  expect_equal(dplyr::filter(cci_scores, ID=="KT000001")$CCI, 0)
})