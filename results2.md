```
Linear mixed model fit by REML. t-tests use Satterthwaite's method ['lmerModLmerTest']
Formula: log(PPM) ~ Store + (1 | Item) + (1 | seasonal)
   Data: dat

REML criterion at convergence: 249.7

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-2.8950 -0.5207  0.1005  0.5927  3.4906 

Random effects:
 Groups   Name        Variance Std.Dev.
 Item     (Intercept) 1.29763  1.1391  
 seasonal (Intercept) 0.15430  0.3928  
 Residual             0.05586  0.2363  
Number of obs: 421, groups:  Item, 45; seasonal, 2

Fixed effects:
                   Estimate Std. Error        df t value Pr(>|t|)
(Intercept)         0.88819    0.33335   1.82291   2.664 0.128437
StoreCostco         0.08195    0.05133 368.23427   1.596 0.111274
StoreTarget         0.13810    0.04006 368.05591   3.448 0.000631
StoreWalmart        0.19347    0.03991 368.05482   4.848 1.84e-06
StoreHy-Vee         0.27088    0.03991 368.05482   6.788 4.56e-11
StoreCub            0.32698    0.04540 368.13296   7.203 3.36e-12
StoreTrader Joe's   0.33559    0.05014 368.22717   6.694 8.14e-11
StoreKwik Trip      0.60433    0.05447 368.17775  11.094  < 2e-16

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

