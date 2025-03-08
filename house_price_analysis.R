ames_data <- read.csv("C:\\Users\\Local Admin\\Downloads\\AmesHousing.csv")

# Load necessary libraries.
library(dplyr)
library(ggplot2)
library(DescTools)

# Remove unnecessary columns.
remove_columns <- c("Utilities", "Street", "Pool.QC", "Misc.Feature",
                    "Condition.2","Land.Slope", "Roof.Matl", "Order", "PID")
ames_data <- ames_data[, !(names(ames_data) %in% remove_columns)]

# Explore and summary the predictor variable.
summary(ames_data$SalePrice)

# Define key numeric variables.
key_num_var <- c("Lot.Frontage", "Lot.Area", "Year.Built", "Year.Remod.Add", 
                 "BsmtFin.SF.1", "BsmtFin.SF.2", "Bsmt.Unf.SF", 
                 "Total.Bsmt.SF", "X1st.Flr.SF", "X2nd.Flr.SF", "Low.Qual.Fin.SF",
                 "Gr.Liv.Area", "Bsmt.Full.Bath", "Bsmt.Half.Bath", "Full.Bath",
                 "Half.Bath", "Bedroom.AbvGr", "Kitchen.AbvGr", "TotRms.AbvGrd",
                 "Fireplaces", "Garage.Yr.Blt", "Garage.Cars", "Garage.Area",
                 "Wood.Deck.SF", "Open.Porch.SF", "Enclosed.Porch", "X3Ssn.Porch",
                 "Pool.Area", "Misc.Val", "Mo.Sold", "Yr.Sold", "MS.SubClass")
print(summary(ames_data[key_num_var]))

# Explore modes and variances for key numerical variables.
for (column in key_num_var) {
  print(paste("Mode of column", column))
  print(Mode(ames_data[[column]], na.rm = TRUE)) # remove missing values using na.rm
  print(paste("Variance of column", column))
  print(var(ames_data[column]))
}

# Visualize the distribution for sale price.
hist(na.omit(ames_data[["SalePrice"]]), xlab = "SalePrice", ylab = "Frequency",
     main = "Histogram of SalePrice (ignore missing values)",
     col = "skyblue", border = "black", breaks = 50)

# Visualize the distributions for key of the key numerical columns.
for (column in key_num_var) {
  if (is.numeric(ames_data[[column]])) {
    hist(na.omit(ames_data[[column]]), xlab = column, ylab = "Frequency",
         main = paste("Histogram of ", column, "(ignore missing values)"),
         col = "skyblue", border = "black",breaks = 35)
  }
}

# Visualize the relationship between sale price and each of the key numerical variables.
for (column in key_num_var) {
  if (is.numeric(ames_data[[column]])) {
    if (column != "SalePrice") {
      scatterplot_column <- ames_data[c(column, "SalePrice")] # only the columns relevant in the scatterplot
      complete_scatterplot_column <- scatterplot_column[complete.cases(scatterplot_column), ] #Remove missing rows
      p <- ggplot(complete_scatterplot_column, aes(complete_scatterplot_column[[column]],
                                                   complete_scatterplot_column[["SalePrice"]])) + geom_point() +
        xlab(column) + ylab("Sale Price") + ggtitle(paste("Correlation between Sale Price and ", column))
      print(p)
    }
  }
  else {
    print(paste("Skipping non-numeric column: ", column))
  }
}

# Load corrplot
library(corrplot)

# Include a new data frame that only considers key numerical variables as columns.
ames_data_cor <- ames_data[key_num_var]

# Include interaction terms
ames_data_cor$YearBuiltXYearRemodAdd <- ames_data$Year.Built * ames_data$Year.Remod.Add
ames_data_cor$GarageCarsXGarageArea <- ames_data$Garage.Cars * ames_data$Garage.Area
ames_data_cor$MSSubClassXLotArea <- ames_data$MS.SubClass * ames_data$Lot.Area
ames_data_cor$TotalBsmtDFXGrLivArea <- ames_data$Total.Bsmt.SF * ames_data$Gr.Liv.Area

# Create a correlation matrix and plot it.
corrplot(cor(na.omit(ames_data_cor)), tl.cex = 0.65, tl.col = "black")

# Visualize relationship between year built and the interaction term.
plot(ames_data_cor$Year.Built, ames_data_cor$YearBuiltXYearRemodAdd,
     xlab = "Year.Built", ylab = "YearBuiltXYearRemodAdd",
     main = "Garage.Yr.Blt vs. Year.Built")

# Visualize relationship between Gr.Liv.Area and Pool.Area.
plot(ames_data_cor$Gr.Liv.Area, ames_data_cor$Pool.Area,
     xlab = "Gr.Liv.Area", ylab = "Pool.Area",
     main = "Pool.Area vs. Gr.Liv.Area")

# Apply feature engineering techniques to transform variables.
ames_data_cor$log_Lot.Area <- log(ames_data$Lot.Area)
ames_data_cor$inv_Lot.Frontage <- 1 / ames_data$Lot.Frontage
ames_data_cor$log_BsmtFin.SF.1 <- log(ames_data$BsmtFin.SF.1)
ames_data_cor$log_BsmtFin.SF.2 <- log(ames_data$BsmtFin.SF.2)
ames_data_cor$sqrt_Bsmt.Unf.SF <- sqrt(ames_data$Bsmt.Unf.SF)
ames_data_cor$log_Total.Bsmt.SF <- log(ames_data$Total.Bsmt.SF)
ames_data_cor$log_X1st.Flr.SF <- log(ames_data$X1st.Flr.SF)
ames_data_cor$log_X2nd.Flr.SF <- log(ames_data$X2nd.Flr.SF)
ames_data_cor$sqrt_Gr.Liv.Area <- sqrt(ames_data$Gr.Liv.Area)
ames_data_cor$log_Garage.Area <- log(ames_data$Garage.Area)
ames_data_cor$log_Wood.Deck.SF <- log(ames_data$Wood.Deck.SF)
ames_data_cor$log_Enclosed.Porch <- log(ames_data$Enclosed.Porch)
ames_data_cor$inv_X3Ssn.Porch <- 1 / ames_data$X3Ssn.Porch
ames_data_cor$log_Screen.Porch <- log(ames_data$Screen.Porch)

# Remove unwanted terms that will not help with the final model.
remove_columns <- c("Lot.Area", "Lot.Frontage", "BsmtFin.SF.1",
                    "BsmtFin.SF.2", "Bsmt.Unf.SF", "Total.Bsmt.SF", "X1st.Flr.SF",
                    "X2nd.Flr.SF", "Gr.Liv.Area", "Garage.Area", "Wood.Deck.SF", 
                    "Enclosed.Porch", "X3Ssn.Porch", "Screen.Porch",
                    "YearBuiltXYearRemodAdd", "GarageCarsXGarageArea", 
                    "MSSubClassXLotArea", "TotalBsmtDFXGrLivArea")

# Update the data frame and interaction terms accordingly.
ames_data_cor <- ames_data_cor[, !(names(ames_data_cor) %in% remove_columns)]
ames_data_cor$YearBuiltXYearRemodAdd <- ames_data_cor$Year.Built * ames_data_cor$Year.Remod.Add
ames_data_cor$GarageCarsXlog_GarageArea <- ames_data_cor$Garage.Cars * log(ames_data$Garage.Area)
ames_data_cor$MSSubClassXlog_LotArea <- ames_data_cor$MS.SubClass * log(ames_data$Lot.Area)
ames_data_cor$log_TotalBsmtDFXsqrt_GrLivArea <- log(ames_data$Total.Bsmt.SF) * sqrt(ames_data$Gr.Liv.Area)

# Construct a new correlation matrix.
corrplot(cor(na.omit(ames_data_cor)), tl.cex = 0.5, tl.col = "black", number.cex = 0.5)

ames_data <- read.csv("C:\\Users\\Local Admin\\Downloads\\AmesHousing.csv")
## Include sale price as a qualitative column just to be able to compare
qualitative_columns <- ames_data[c("MS.Zoning", "Land.Contour", "Utilities", 
                                   "Lot.Config", "Land.Slope", "Neighborhood", 
                                   "Condition.1", "Condition.2", "Bldg.Type", 
                                   "House.Style", "Roof.Style", "Roof.Matl", 
                                   "Exterior.1st", "Exterior.2nd", "Mas.Vnr.Type", 
                                   "Exter.Qual", "Exter.Cond", "Foundation", 
                                   "Bsmt.Qual", "Bsmt.Cond", "Bsmt.Exposure", 
                                   "BsmtFin.Type.1", "BsmtFin.Type.2", "Heating", 
                                   "Heating.QC", "Central.Air", "Electrical", 
                                   "Kitchen.Qual", "Functional", "Fireplace.Qu", 
                                   "Garage.Type",  "Garage.Finish", "Garage.Qual", 
                                   "Garage.Cond", "Paved.Drive", "Pool.QC", 
                                   "Fence", "Misc.Feature", "SalePrice")]
# Create a data frame that will have all the categorical columns of interest.
key_qualitative_columns <- qualitative_columns[, 
                                               !(names(qualitative_columns) %in% 
                                                   c("Utilities", "Street",  
                                                     "Pool.QC", "Misc.Feature", 
                                                     "Condition.2", "Land.Slope", 
                                                     "Roof.Matl", "Order", 
                                                     "Fireplace.Qu", "Alley", "Fence"))]

for (column in names(key_qualitative_columns)) {
  if (column != "SalePrice") {
    boxplot(key_qualitative_columns$SalePrice ~ key_qualitative_columns[[column]],
            col = "skyblue", las = 2, xlab = "", ylab = "",
            main = paste("Comparison of House Prices across Categories of", column))
  }
}

for (column in colnames(key_qualitative_columns)) {
  if (column != "SalePrice") {
    barplot(table(na.omit(key_qualitative_columns[column])), 
            las = 2, ylab = "Number of Houses", xlab = "", 
            main = paste("Number of Houses by ", column))
  }
}