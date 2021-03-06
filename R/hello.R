#' test
#' @importFrom rstan stan_model sampling cpp_object_initializer
#' @importFrom Rcpp cpp_object_initializer
#' @export
test = function(){

  schools = "
  data {
    int<lower=0> J; // number of schools
    real y[J]; // estimated treatment effects
    real<lower=0> sigma[J]; // s.e. of effect estimates
  }
  parameters {
    real mu;
    real<lower=0> tau;
    real eta[J];
  }
  transformed parameters {
    real theta[J];
    for (j in 1:J)
    theta[j] = mu + tau * eta[j];
  }
  model {
    target += normal_lpdf(eta | 0, 1);
    target += normal_lpdf(y | theta, sigma);
  }
  "

  schools_dat <- list(J = 8,
                      y = c(28,  8, -3,  7, -1,  1, 18, 12),
                      sigma = c(15, 10, 16, 11,  9, 11, 10, 18))

  model <- stan_model(model_code = schools)
  sampling(model, data = schools_dat)
}