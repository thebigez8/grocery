```
Linear mixed model fit by REML. t-tests use Satterthwaite's method ['lmerModLmerTest']
Formula: log(PPM) ~ Store + (1 | Item) + (1 | seasonal)
   Data: dat

REML criterion at convergence: 249.1

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-2.8927 -0.5131  0.0945  0.5981  3.4929 

Random effects:
 Groups   Name        Variance Std.Dev.
 Item     (Intercept) 1.28073  1.1317  
 seasonal (Intercept) 0.15528  0.3941  
 Residual             0.05586  0.2363  
Number of obs: 421, groups:  Item, 45; seasonal, 2

Fixed effects:
                   Estimate Std. Error        df t value Pr(>|t|)
(Intercept)         0.69381    0.33353   1.80553   2.080 0.186564
StoreCostco         0.08229    0.05133 368.26187   1.603 0.109760
StoreTarget         0.13817    0.04006 368.08131   3.450 0.000627
StoreWalmart        0.19354    0.03990 368.08021   4.850 1.82e-06
StoreHy-Vee         0.27090    0.03990 368.08021   6.789 4.54e-11
StoreCub            0.32719    0.04540 368.15801   7.208 3.25e-12
StoreTrader Joe's   0.33595    0.05014 368.25295   6.701 7.78e-11
StoreKwik Trip      0.60458    0.05447 368.20467  11.099  < 2e-16

Correlation of Fixed Effects:
            (Intr) StrCst StrTrg StrWlm StrH-V StorCb StrTJ'
StoreCostco -0.045                                          
StoreTarget -0.060  0.386                                   
StoreWalmrt -0.060  0.389  0.503                            
StoreHy-Vee -0.060  0.391  0.503  0.505                     
StoreCub    -0.061  0.340  0.442  0.444  0.444              
StorTrdrJ's -0.057  0.311  0.397  0.400  0.399  0.361       
StoreKwkTrp -0.045  0.297  0.366  0.368  0.368  0.326  0.292

```

