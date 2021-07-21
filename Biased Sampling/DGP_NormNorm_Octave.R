######## Biased sampling  ######## 
setwd("D:/Octave")
rm(list = ls())
source('D:/Octave/CCdata.R')
for (i in 1:2) {
  #set.seed(707)  
  set.seed(as.integer((as.double(Sys.time())*1000+Sys.getpid()) %% 2^31))
  n1 = 100 
  n0 = 100
  n = n1 + n0
  
  # true parameters
  alpha = -4.165 #runif(1, -5, -4)
  beta_X = log(1.5) #log(runif(1, 1, 2))
  beta_Z = log(1.2) #log(runif(1, 1, 2))
  beta_XZ = log(1.3) #log(runif(1, 1, 2))
  
  ### generate data
  dat = simulate_complex(ncase = n1, 
                         ncontrol = n0, 
                         beta0 = alpha, 
                         betaG_normPRS = beta_Z, 
                         betaE_norm = beta_X, 
                         betaGE_normPRS_norm = beta_XZ, 
                         control = list(trace = 1))
  # get data
  pi_1 = dat$pi_1 # true pi_1
  pi_0 = 1- pi_1
  Z = as.matrix(dat$G)
  X = as.matrix(dat$E)  
  D = as.matrix(dat$D)
  
  theta_logit = glm(D~X*Z, family="binomial")
  theta_initial = theta_logit $coefficients
  
  temp = data.frame(cbind(D,X,Z,pi_1,theta_initial))
  names(temp) = c("D", "X", "Z", "pi_1", "theta_initial")
  write.table(temp, file = paste0("NormNorm_Octave_", i, ".csv" ), 
              row.names = F, col.names = F, sep=",")
}
