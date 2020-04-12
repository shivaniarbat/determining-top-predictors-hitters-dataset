# Determining Top Predictors for ISLR Hitters Dataset

LASSO, elastic net, Adaptive LASSO, SCAD methods for determining top predictors for each method.

------
###### For Lasso below are the top predictors:
- Hits 1.72206743
- Walks 1.57275905
- CHmRun 0.49835782
- CRuns 0.08740234
- CRBI 0.50979015
- PutOuts 0.18776039

###### For Elastic Net below are the top predictors:
- Hits 1.58604917
- Walks 1.63296070
- CHits 0.03275671
- CHmRun 0.90455877
- CRuns 0.16208771
- CRBI 0.25834082
- DivisionW -1.52527575
- PutOuts 0.17776448

###### For SCAD below are the top predictors:
- AtBat -2.1672572
- Hits 8.1885705
- HmRun -8.8484358
- Walks 6.0337992
- Years -10.2448385
- CHits 0.3680495
- CHmRun 2.9314344
- CWalks -0.5432212
- DivisionW -80.0966560
- PutOuts 0.3353118
- Assists 0.1743041
- NewLeagueN -3.5558069

###### For Adaptive LASSO below are the top predictors:
- Hits 2.3337452
- Walks 3.3849602
- CRBI 0.4805223
------

Hits predictor is common in all methods whoever each method emphasizes different coefficient values. All the methods accept SCAD positive correlation impact on predicting the response variable Salary.

If we look at the pair graphs amongst these variables: CRBI have comparatively more correlation with response variable Salary.
Also, AtBat and Hits are highly correlated.

![](https://github.com/shivaniarbat/determining-top-predictors-hitters-dataset/blob/master/pair-scatterplot.png)

Even though, SCAD does not have CRBI as one of its top predictors.
