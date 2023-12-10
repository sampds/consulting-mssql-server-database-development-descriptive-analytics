# to execute this script:
# First run the Transform_Load script
# load the SQL database
# ensure the libraries and datasets are in memory
# this uses the same libraries and datasets as the Transform_Load script

# replace variables with your environmental variables
# link to a file and use the values here
Sys.setenv(driver = "driver", server = "server", database = "database")

myconn <- DBI::dbConnect(odbc::odbc(),
                         Driver             = driver,
                         Server             = server,
                         Database           = database,
                         Trusted_Connection = "Yes"
)


sqlSelectStatement <- "SELECT * FROM CollegeAppDashboard"

CollegeAppDashboard.df <- dbGetQuery(myconn, sqlSelectStatement)
View(CollegeAppDashboard.df)

CollegeAppDashboard.df$Ranking <- as.numeric(CollegeAppDashboard.df$Ranking)
# now we can sort by ranking

outcomes <- ggplot(data = CollegeAppDashboard.df, aes(x = Student, y = Ranking, color = Decision))
outcomes <- outcomes + geom_point()
outcomes <- outcomes + ylab('National University Ranking') + ggtitle('A1 Students Consistently Gain Admissions to Top Universities')
outcomes



# visualize where our customers live and when
# helps us understand if we are reaching new markets

# make a map of the us
# prepare necessary data to make a map of the US

states.df <- data.frame(state.name, stringsAsFactors = FALSE)
colnames(states.df) = 'state'
states.df$state <- tolower(states.df$state)

# create a variable that contains the map information at the state level
us <- map_data('state') 

# create a map of the us

us.map <- ggplot(states.df, aes(map_id = state)) +
  geom_map(map = us, fill = "white", color = "black") +
  expand_limits(x = us$long, y= us$lat) +
  coord_map() +
  ggtitle('Map of the US')
us.map

# prepare SQL data for mapping
sqlSelectStatement <- "SELECT postal_code, graduation_year FROM student"
studentZipYear.df <- dbGetQuery(myconn, sqlSelectStatement)
View(studentZipYear.df) 

# this is the index I used to generate the mock zip codes in the first place

studentZipYear.df$state <- zipcode.df[mock.zip.indexes, 3]
studentZipYear.df$latitude <- zipcode.df[mock.zip.indexes, 4]
studentZipYear.df$longitude <- zipcode.df[mock.zip.indexes, 5]
# I want to plot the year as a discrete variable so I'm going to make it a factor
studentZipYear.df$graduation_year<- as.factor(studentZipYear.df$graduation_year)
View(studentZipYear.df)
str(studentZipYear.df)

# plot student zips on map

us.map <- us.map + (geom_point(data=studentZipYear.df, aes(x=longitude, y=latitude, color=graduation_year), shape=1))
us.map <- us.map + ggtitle('A1 Students by Zip and HS Graduation Year')
us.map