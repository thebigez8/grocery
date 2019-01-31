```

Call:
lm(formula = log(PPM) ~ Store + Item, data = dat, subset = timepoint == 
    1)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.60410 -0.09710  0.01953  0.10360  0.62894 

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)
(Intercept)         0.30982    0.10985   2.820 0.005968
StoreCostco         0.17270    0.08311   2.078 0.040725
StoreTarget         0.18305    0.06426   2.849 0.005503
StoreWalmart        0.25138    0.06270   4.009 0.000130
StoreHy-Vee         0.25706    0.06350   4.049 0.000113
ItemApplesauce      0.19637    0.15330   1.281 0.203686
ItemBananas        -0.45149    0.14386  -3.138 0.002335
ItemBeef (80%)      1.87884    0.15330  12.256  < 2e-16
ItemBread           0.68821    0.14386   4.784 7.16e-06
ItemButter          1.25301    0.14386   8.710 2.09e-13
ItemCheese          1.48193    0.14386  10.301  < 2e-16
ItemChicken         1.23330    0.15296   8.063 4.23e-12
ItemChicken Strips  1.94020    0.15296  12.685  < 2e-16
ItemCrackers        0.97336    0.14386   6.766 1.59e-09
ItemCucumber       -0.09567    0.15330  -0.624 0.534265
ItemDeli Turkey     0.94736    0.15330   6.180 2.14e-08
ItemEggs            0.93126    0.14386   6.473 5.88e-09
ItemFlour          -2.46431    0.15330 -16.075  < 2e-16
ItemIce Cream       1.21841    0.15330   7.948 7.21e-12
ItemLettuce         0.09288    0.15330   0.606 0.546209
ItemM&C (Annie's)   1.36972    0.16728   8.188 2.37e-12
ItemMilk (2%)       1.09931    0.14386   7.642 2.96e-11
ItemOJ             -0.33681    0.14386  -2.341 0.021563
ItemOlive Oil      -0.78876    0.16728  -4.715 9.37e-06
ItemPotato Chips    0.65844    0.15330   4.295 4.62e-05
ItemRed Sauce       0.28880    0.15330   1.884 0.063003
ItemSpaghetti       0.79905    0.15330   5.212 1.29e-06
ItemSpinach         0.75528    0.15330   4.927 4.07e-06
ItemStrawberries    0.95718    0.14386   6.654 2.64e-09
ItemSugar          -2.35079    0.15330 -15.335  < 2e-16
ItemTator Tots      1.19444    0.15330   7.792 1.48e-11

Residual standard error: 0.2275 on 85 degrees of freedom
Multiple R-squared:  0.9659,	Adjusted R-squared:  0.9539 
F-statistic: 80.32 on 30 and 85 DF,  p-value: < 2.2e-16


```

