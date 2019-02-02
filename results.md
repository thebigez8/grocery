```

Call:
lm(formula = log(PPM) ~ Store + Item, data = dat, subset = timepoint == 
    1)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.60410 -0.09710  0.01953  0.10360  0.62894 

Coefficients:
                    Estimate Std. Error t value Pr(>|t|)
(Intercept)         1.002963   0.109848   9.130 2.94e-14
StoreCostco         0.172697   0.083107   2.078 0.040725
StoreTarget         0.183050   0.064255   2.849 0.005503
StoreWalmart        0.251382   0.062697   4.009 0.000130
StoreHy-Vee         0.257061   0.063495   4.049 0.000113
ItemApplesauce     -0.496774   0.153300  -3.241 0.001704
ItemBananas        -1.144639   0.143860  -7.957 6.92e-12
ItemBeef (80%)      2.166522   0.153300  14.133  < 2e-16
ItemBread          -0.004942   0.143860  -0.034 0.972676
ItemButter          0.559865   0.143860   3.892 0.000197
ItemCheese          1.194249   0.143860   8.301 1.40e-12
ItemChicken         1.233295   0.152957   8.063 4.23e-12
ItemChicken Strips  1.652516   0.152957  10.804  < 2e-16
ItemCrackers        0.280218   0.143860   1.948 0.054734
ItemCucumber        0.127476   0.153300   0.832 0.407993
ItemDeli Turkey     0.947363   0.153300   6.180 2.14e-08
ItemEggs            0.238114   0.143860   1.655 0.101576
ItemFlour          -1.771168   0.153300 -11.554  < 2e-16
ItemIce Cream       0.525258   0.153300   3.426 0.000945
ItemLettuce         0.092881   0.153300   0.606 0.546209
ItemM&C (Annie's)   0.676576   0.167285   4.044 0.000115
ItemMilk (2%)       0.811629   0.143860   5.642 2.16e-07
ItemOJ             -1.029953   0.143860  -7.159 2.69e-10
ItemOlive Oil      -1.481907   0.167285  -8.859 1.04e-13
ItemPotato Chips   -0.034707   0.153300  -0.226 0.821436
ItemRed Sauce       0.001114   0.153300   0.007 0.994221
ItemSpaghetti      -0.181775   0.153300  -1.186 0.239025
ItemSpinach         0.062134   0.153300   0.405 0.686267
ItemStrawberries    0.264035   0.143860   1.835 0.069951
ItemSugar          -1.945327   0.153300 -12.690  < 2e-16
ItemTator Tots      0.095825   0.153300   0.625 0.533590

Residual standard error: 0.2275 on 85 degrees of freedom
Multiple R-squared:  0.9588,	Adjusted R-squared:  0.9442 
F-statistic: 65.89 on 30 and 85 DF,  p-value: < 2.2e-16


```

