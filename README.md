# Learning R - 101

This is just a folder containing small R projects that I have done to help me understand
the basics of the language

### So... Where did I start?

- [R programming](https://www.coursera.org/learn/r-programming/) course, by Josh Hopkings University is great course to start. It teaches you the basics and give you tools that you can perfect as you gain experience. 
- [SWIRL](https://swirlstats.com/students.html) can also be a great tool if  you are more into learning by doing code.

### And where do I go from there?

- [R for Data Science](https://r4ds.had.co.nz/introduction.html) is a great beginners book that has pretty much all the basics.
- [CRAN](https://cran.r-project.org/) is also a great library where all R functions are described. 
- [Cheat sheets](https://rstudio.com/resources/cheatsheets/) are great when you are working with a specific package that is relatively new to you

### What if want to make graphics?

[R Graphics Cookbook](https://r-graphics.org/index.html) is a good start, as it will have many of the basics on graphs and commands

### And what about maps?

[Geocomputation with R](https://geocompr.robinlovelace.net/) has a lot of information on how to make maps

### How to personalize your graphs?

This has been my toughest challenge so far. I did found resources to help in the design of the output:
- [Top R color palettes](https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/) has a good overall presentation of different palettes and colors available;
- [Color brewer](https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3) is good place if you are looking for a personalized color layout;
- For maps, [tmap](https://cran.r-project.org/web/packages/tmap/vignettes/tmap-getstarted.html), has nice basic layouts;
- The [Cran](https://cran.r-project.org/web/packages/tmap/index.html) for tmap is also very detailed and good if you are looking for specific personalization

### Machine learning with R

R has an extensive biography on machine learning techniques. It also has a variety of packages to help solving all kinds of problems. To learn these techniques, I have been studyng [the classic Titanic Problem](https://www.kaggle.com/c/titanic). The book **Introduction to Machine Learning with R** by **Scott V. Burger** is really the place to start. It gives a detailed look on supervised ML techiniques such as regressions, trees, randomForests and neural networks.

I have also discovered that there are an infinity of packages that will often do the same type of analysis, or at least, very similar analysis. [The caret Package book](http://topepo.github.io/caret/index.html) has often helped me to visualize what different ML packages can do. Section 7 of the book has a great index of what each package does, and what are the tuning parameters in each case.

By trial and error, I have found the following packages to be useful:

#### Tree models
- [rpart](https://cran.r-project.org/web/packages/rpart/index.html) will process data relatively fast and is a flexible model. It is easy to define important parameters using the core function: rpart or the auxiliary rpart.control. The package produces a desision tree, based on weights of information fed to the model, therefore it require a hands on approach, where selecting parameters and pruning the tree is often required to avoid overfitting.
- [party](https://cran.r-project.org/web/packages/party/index.html) processing is not as fast as it is build as a conditional inference tree. Beacuse the tree is already based in tests of significance the results is more consistent - no need for additional steps. Visually it is also a better representation on how trees work.
#### Random Forest models
- As trees, the same distinction can be made in random forests: [randomForest](https://cran.r-project.org/web/packages/randomForest/index.html) is the equivalent of rpart while [party](https://cran.r-project.org/web/packages/party/index.html) also does random Forests.
- The [RRF](https://cran.r-project.org/web/packages/RRF/RRF.pdf) package provides regularization options, which could help on decreasing noise from samples.

### And what is next?

ML is still a large field that I am extremely interested in learning more about. Listing the things that I am planning to do:
- Get a better understanding in the topic of tuning trees and random forests;
- Improving the visualization of trees and forests;
- Start the study of Neural Networks;
- Start studying unsupervised learning techniques.
