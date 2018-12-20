# Data wrangling exercise #1

# Load required library
library("tidyverse")

#create object for csv file
products <- read_csv("refine_original.csv")

#convert company column to lowercase
products$company <- tolower(products$company)

# cleanup company names using regex pattern matching & replacement
products$company <- sub(pattern = ".*ps$", replacement = "philips", x = products$company)
products$company <- sub(pattern = "^a.*", replacement = "akzo", x = products$company)
products$company <- sub(pattern = "^u.*", replacement = "unilever", x = products$company)
products$company <- sub(pattern = "^v.*", replacement = "van houten", x = products$company)

# Separate the Product.code...number column
products <- separate(products, "Product code / number", c("product_code", "product_number"), sep = "-")

# Add a column with a readable version of Cateogry
products$product_category <- sub(pattern = "^p$", replacement = "Smartphone", x = sub("^x$", "Laptop", sub("^v$", "TV", sub("^q$", "Tablet", products$product_code))))

# Add a column with the full address separated by commas
products <- mutate(products, full_address = paste(address, city, country, sep = ","))

#new_cols <- c(unique(products$company))
#new_cols <- paste("company_" ,new_cols)
#for(x in new_cols) { 
#products <- mutate(products,x)
#  }


# Create dummy variables for company and product category
products <- mutate(products, company_philips = ifelse(company == "philips", 1, 0))
products <- mutate(products, company_akzo = ifelse(company == "akzo", 1, 0))
products <- mutate(products, company_van_houten = ifelse(company == "van houten", 1, 0))
products <- mutate(products, company_unilever = ifelse(company == "unilever", 1, 0))
products <- mutate(products, product_smartphone = ifelse(product_category == "Smartphone", 1, 0))
products <- mutate(products, product_tv = ifelse(product_category == "TV", 1, 0))
products <- mutate(products, product_laptop = ifelse(product_category == "Laptop", 1, 0))
products <- mutate(products, product_tablet = ifelse(product_category == "Tablet", 1, 0))

# Write to csv
write.csv(products, "refine_clean.csv")



