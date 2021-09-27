%Get "random" seed for generating random data (the following line is in R)
set.seed(as.integer((as.double(Sys.time())*1000+Sys.getpid()) %% 2^31))
