# Now it is time to create your own data frame using the tools we have learned this week.
# First, resave this script as: your last name_Week1_Assignment
  # e.g. mine would be Wilson_Week1_Assignemnt


# Create 3 numeric vectors and 2 character vectors that are each 15 values in length with the following structures:
  # One character vector with all unique values
a <- c('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o')
  # One character vector with exactly 3 unique values
b <- c('z','z','z','z','z','y','y','y','y','y','w','w','w','w','w')
  # One numeric vector with all unique values
c <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
  # One numeric vector with some repeated values (number of your choosing)
d <- c(1,2,2,3,3,3,4,4,4,4,5,5,5,5,5)
  # One numeric vector with some decimal values (of your choosing)
e <- c(1,2,3,4.20,5,6.9,7,8.008,9,10,11.11,12,13,14,15)
# Bind the vectors into a single data frame, rename the columns, and make the character vector with unique values the row names.
data <- cbind(a,b,c,d,e)
data
df <- as.data.frame(data)
df
colnames(df) <- c('Apples','Bears','Cashmere','duchess','dirt')
df
row.names(df) <- df$Apples
df
# Remove the character vector with unique values from the data frame.
df[,-1]
df.a <- df[,-1]
df.a
# Add 1 row with unique numeric values to the data frame.
New <- data.frame('q',20,6,15.1)
colnames(New) <- colnames(df.a)
rbind(df.a,New)
df.r <- rbind(df.a,New)
df.r
row.names(df.r)<- c(row.names(df.a[1:15,]),"New")#very nice! I approve of nesting operations.
df.r
# Export the data frame as a .csv file 
write.csv(df.r,"C:/GitHub/R4Eco_2022/Week1/sherinskynl.csv", row.names = TRUE)

# Generate summary statistics of your data frame and copy them as text into your script under a new section heading.
summary(df.r)#These should have been numbers - you were so close to perfection! The numbers needed to be forced to numeric like the tutorial.
#  Bears             Cashmere           duchess              dirt          
# Length:16          Length:16          Length:16          Length:16         
# Class :character   Class :character   Class :character   Class :character  
# Mode  :character   Mode  :character   Mode  :character   Mode  :character 

# Push your script and your .csv file to GitHub in a new "Week1" folder.


