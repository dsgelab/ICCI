test_that("multiplication works", {
  atc_data <- create_test_atc_data(c("KT0001", "KT0008", "KT0007", "KT0005", "KT0003"), n_samples=10)
  
  med_data <- calc_med(atc_data, 
                   exp_start=0, 
                   exp_end=100)
  expect_res <- tibble::tibble(ID=c("KT0005", "KT0001", "KT0008", "KT0003"),
                               MED=c(0,1,-2,0))
  expect_equal(med_data, expect_res)


  med_data <- calc_med(atc_data, 
                     exp_start=50, 
                     exp_end=70)
  expect_res <- tibble::tibble(ID=c("KT0005", "KT0001", "KT0008", "KT0003"),
                               MED=c(0,1,0,0))

  expect_equal(med_data, expect_res)
})
