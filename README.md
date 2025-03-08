# Prediction-Of-House-Prices-In-Ames-Iowa

Predicting house prices in Ames, Iowa using LASSO regularization, this project explores the relationships between property features and sale prices, providing insights into the key drivers of housing prices.

Introduction
- This project aims to predict house prices in Ames, Iowa by leveraging Lasso regularization.
- We utilize the Ames Housing Dataset (2006-2010) and R programming language to identify key property features influencing sale prices.

Objectives
- Identify the significant property features affecting sale prices.
- Develop an accurate regression model (high R-squared value and low mean-squared error) to predict house prices.

Methodology
- Data exploration and preprocessing.
- Feature selection using correlation analysis and regression modeling.
- Model development and evaluation using test data.

Key Findings
- The top predictors of house prices are Overall Quality, Above Ground Living Area, and Neighborhood.
- The LASSO regression model achieved a high accuracy with a high R-squared value and a low mean-squared error.
- The model identified significant positive relationships between house prices and features such as Overall Quality, Above Ground Living Area, and Neighborhood.
- The model also identified significant negative relationships between house prices and features such as MS Zoning and Total Rooms Above Grade.

Code and Data
- R code for descriptive data analysis: house_price_analysis.R
- R code for prediction: house_price_prediction.R
- Ames Housing Dataset (2006-2010): ames_housing_dataset.csv

Requirements
- R version 4.1.0 or higher
- RStudio or similar IDE

Data Source
- The Ames Housing dataset was obtained from the Kaggle platform.
- The dataset was compiled by Dean De Cock, Professor of Statistics at Truman State University, for use in data science education.

Data Quality
- The dataset is comprehensive and reliable, originating from the Ames Assessor's Office.
- Missing values were handled by removing columns with more than 20% missing values and using interpolation for numerical variables and mode for categorical variables.

Team Members 
- Lily Hijazi
- Majid Taherkhani
- Maryam Shirinchi
- Nima Nafezi
- Kurt Anand

Course Information
- This project was completed as part of the Quantitative Data Analytics course.

License
- This project is licensed under the MIT License.

Acknowledgments
- We acknowledge the Ames Assessor's Office for providing the dataset and Dean De Cock for compiling and sharing the dataset on Kaggle.



