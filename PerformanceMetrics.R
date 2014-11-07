accuracy = function(label, label.hat)
{
  # Return the percentage of time predicting correctly
  # over total number of prediction.
  t = table(label, label.hat)
  sum(diag(t))/sum(t)
}

meanError = function(label, label.hat)
{
  # The penalty function is defined as: If truth is 1:
  # predict 0 has penalty 0.5
  # predict -1 has penalty 1
  # predict 1 correctly has no penalty.
  t = table(label, label.hat)
  (0.5*(t[1,2]+t[2,1]+t[2,3]+t[3,2])+t[1,3]+t[3,1])/sum(t)
}

cutOff = function(label, thres = 0.5, k = 2)
{
  # Given a number x, if x > thres, return 1,
  # if x < -thres, return -1.
  # if - thres <= x <= thres return 0
  # where label > 0.5, set to 1, the rest 0
  x = (label > thres) + 0.0
  # where label < -0.5 set to -1 instead
  if (k == 3) x[label < -thres] = -1
  x
}

cutOffGridSearch = function(label, label.hat, method = accuracy)
{
  # This function perform a grid search to find the best cutoff 
  # value in converting continuous predicted label into discrete
  # Note that if method is "accuracy", extreme must be max, 
  # If method is "meanError", extreme must be min. 
  if (identical(method, accuracy)) 
  {
    extreme = max
  } else if (identical(method, meanError))
  {
    extreme = min
  } else
  {
    warning("Method must be one of: accuracy, meanError")
  }
  thres = seq(0.01, 0.99, by = 0.01)
  s = lapply(thres, 
             function(x) method(label, cutOff(label.hat, x)))
  s = unlist(s)
  thres[s == extreme(s)][1]
}

CalculateTPR <- function(thresh, preds, truth) {
  as.numeric(sum(preds[truth] > thresh) / sum(truth))
}

CalculateFPR <- function(thresh, preds, truth) {
  as.numeric(sum(preds[!truth] > thresh) / sum(!truth))
}

# Don't use this. Way too slow. O(n^2)
auc2 <- function(truth, preds)
{
  positive.classifications <- sapply(preds[!truth],
  FUN = function(threshold) { CalculateFPR(threshold, preds, !truth) })
  sum(positive.classifications) / sum(!truth)
}

# Improved version of auc2. O(nlog(n))
auc3 <- function(truth, preds)
{
  r = truth[order(preds)]
  n.truth = sum(r); n = length(r)
  sum(n.truth - cumsum(r)[!as.logical(r)])/n.truth/(length(r)-n.truth)
}

# Benchmark result
benchmark.auc = function()
{
  truth = rbinom(1e4,1,0.5)
  preds = runif(1e4,-2,2)
  print(system.time(print(pROC::auc(truth, preds))))
  print(system.time(print(glmnet::auc(truth, preds))))
  print(system.time(print(auc2(truth, preds))))
  print(system.time(print(auc3(truth, preds)))) 
  # Area under the curve: 0.5018
  # user  system elapsed 
  # 0.679   0.168   0.856 
  # [1] 0.4981974
  # user  system elapsed 
  # 0.003   0.000   0.004 
  # [1] 0.4981974
  # user  system elapsed 
  # 2.425   0.385   2.817 
  # [1] 0.4981974
  # user  system elapsed 
  # 0.003   0.001   0.003 
}
# benchmark.auc()
aucs = function(truth, preds) 2*glmnet::auc(truth, preds)-1
