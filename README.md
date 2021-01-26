# Kaggle-Bike-Sharing
Bike Sharing Competition


a.	What is the overall purpose of this project?
  
  Predict how many bikes will be rented/used under certain conditions.
  
  
b.	What do each file in your repository do?

  Exploration.Rmd was the workbook I was using before I was enlightened about the benefits of using a notebook.
  Exploration.R was the workbook I was converted to. 
  Exploration.nb.html is an html file that contains some data that was in the Rmd file which I knitted to test the knitting function. This was before my conversion.
  
  
c.	What methods did you use to clean the data or do feature engineering?

  I changed the month, season, weather, holiday, and workingday variables to factors. I also created a new variable 'hour' which partitions the datetime variable by   hour. I also did target encoding for the season variable.


d.	What methods did you use to generate predictions?

  I used xgbTree gradient boosting with fine-tuned parameters. I also calculated the log of the count in response to a left skew in the plot of count and hour,       which I then exponentiated
