# Significant_Earthquakes_Data_cleaning_SQL
In this project, I use SQL to clean the Significant Earthquakes (1965-2016) from Kaggle (https://www.kaggle.com/datasets/usgs/earthquake-database). The project includes 5 steps: 
- import data into mySQL workbench
- detect and handle data inconsistency, including standardize the date and time column using different functions such as cast(),length(), replace(), substring(),...
- handle blank values: plenty of blank values exist in different columns, and a good understanding of each attribute is necessary to handle null values. However, I didn't use these attributes in my following step analysis; I just replaced all blank values with 0 using CASE statement.
- converte the numerical attributes that were stored as text to double.
- create new columns (year, month) that are necessary for the following step analysis.
- drop unnecessary columns.
After above steps, the dataset is well formatted and ready for futher analysis. 
