library(jsTree)

testthat::test_that('tree html',{
  
  x <- 'a/b/c'
  
  a <- jsTree::jsTree(x,browse = FALSE)
  
  testthat::expect_true(file.exists(a))
  testthat::expect_equal(NROW(readLines(a)),23)
  
})