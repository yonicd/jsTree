library(jsTree)
library(testthat)

testthat::test_that('tree html',{

  x <- 'a/b/c'
  
  a <- jsTree::jsTree_old(x,browse = FALSE)
  
  expect_true(file.exists(a))

})