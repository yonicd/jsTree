library(jsTree)
library(testthat)

testthat::test_that('nesting default',{

  x <- 'a/b/c'
  
  ret <- jsTree:::nest(x)
  
  expect_is(ret,'list')
  
  
})

testthat::test_that('nesting different sep',{
  
  x1 <- 'a/b/c'
  
  ret1 <- jsTree:::nest(x1)
  
  x2 <- 'a-b-c'
  
  ret2 <- jsTree:::nest(x2,sep = '-')
  
  expect_is(ret2,'list')
  
  expect_equal(ret1,ret2)
  
})

testthat::test_that('nesting nodestate',{
  
  x <- c('a/b/c','d/e/f')
  
  ret <- jsTree:::nest(x,nodestate = c(TRUE,FALSE))
  
  expect_true(ret[[1]]$children[[1]]$children[[1]]$children[[1]]$state[[1]])
  expect_false(ret[[1]]$children[[2]]$children[[1]]$children[[1]]$state[[1]])
  
})