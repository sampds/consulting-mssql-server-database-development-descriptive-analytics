library(ggplot2)
library(maps)
library(mapproj)
library(ggmap)
library(zipcode)
library(stringr)
data(zipcode)
library(odbc)


# create "reference" zip code data frame from built-in zip code data
zipcode.df <- zipcode

# read in the csv and view it in another tab

institution.df <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\InstitutionCampus.csv")
View(institution.df)

# remove the two columns I don't want
# like I'm going to fax them anything!

institution.df <- institution.df[,c(-3,-13)] 

# rename the columns to make them SQL friendly / match my column names in my data base

colnames(institution.df) = c('institution_id'
                             , 'ope_id'
                             , 'institution_name'
                             , 'parent_institution_name'
                             , 'parent_institution_id'
                             , 'institution_type'
                             , 'complete_address'
                             , 'general_phone'
                             , 'admin_name'
                             , 'admin_phone'
                             , 'admin_email'
                             , 'last_updated_by_dept_of_edu')


# extract 5 or 9 digit zip codes from institution addresses to new column
institution.df$zipcode <- str_extract(institution.df$complete_address, "\\d{5}(-\\d{4})?(?=\\n|$)")

# standardize the zip codes so they are all 5 digits
# necessary because our reference data frame uses 5-digit zip codes
institution.df$zipcode <- str_extract(institution.df$zip, "\\d{5}")

# get index of zip code on our reference zip code table
zip.indexes <- match(institution.df$zipcode, zipcode.df$zip)

# use this index to add the city and state that correspond to the zip code of the record in our institution table
institution.df$city <- zipcode.df[zip.indexes,2]
institution.df$inst_state <- zipcode.df[zip.indexes,3]

# reorder the columns
institution.df <- institution.df[,c(1,5,2:4,6,14,15,13,7:12)]

# make institution_id character

institution.df$institution_id <- as.character(institution.df$institution_id)

##############

# uncomment and export as a .csv when ready to export

# write.csv(institution.df, "C:\\Users\\SamDe\\Desktop\\MS\\cleaned.institution_import.csv", row.names = FALSE)

#######
# modify mock student data

# read in the csv and view it in another tab

mock_students.df <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\mock_students.csv")
View(mock_students.df)

# replace the mockaroo zip codes (which are actually random numbers 10001 - 99999) with real zip codes from our zipcode data frame
# do this in two steps
# 1: generate a vector of random zip codes from our list of real codes that has the same number of elements as our mock data has observations
# 2: swap this vector for the current zip codes in our mock data frame

# set seed for reproducible results
set.seed(24)

mock_zips <- sample(zipcode.df$zip, length(mock_students.df$postal_code), replace = TRUE)
mock_students.df$postal_code <- mock_zips

# we are also going to swap the mock cities for the cities that actually correspond to the zip codes we just added
# we will use the same procedure we used before for the institution table

mock.zip.indexes <- match(mock_students.df$postal_code, zipcode.df$zip)

# use this index to add the city and state that correspond to the zip code of the record in our institution table
mock_students.df$city <- zipcode.df[mock.zip.indexes,2]

# now we are going to load in our mock parent data and give them the same zip codes, cities, and street addresses
# for the sake of simplicity we are just going to pretend the parents and students live at the same address

# read in the csv and view it in another tab

mock_parents.df <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\mock_parents.csv")
View(mock_parents.df)

# replace the three columns with values from the mock student data frame

mock_parents.df$city <- mock_students.df$city
mock_parents.df$postal_code <- mock_students.df$postal_code
mock_parents.df$address_line_1 <- mock_students.df$address_line_1

# for the purposes of demonstrating our database, we don't need to match up the family names of parents and students
# now I can write these both as .csvs and then import then into the database
############## uncomment when ready to write, then comment again when done writing!

# write.csv(mock_students.df, "C:\\Users\\SamDe\\Desktop\\MS\\student_import.csv", row.names = FALSE)
# write.csv(mock_parents.df, "C:\\Users\\SamDe\\Desktop\\MS\\parent_import.csv", row.names = FALSE)

# now I need to populate my bridge tables and tables with foreign keys
# I am going to use my stored procedures (4 of them) to do this since I'm importing so much data so quickly
# in the future I would make my stored procedures "smarter", incorporating control flow so that bridge tables
# and tables with foreign keys become populated as new records to strong tables to added

# I am going to randomly generate the records I'll need and automatically generate the statements
# I'm so sorry in advance, this is going to be a bunch of code in SQL

#######
# create vectors that contain all possible values for associative tables
# create samples of the vectors to use for our data
# i'm setting arbitrary probabilities for different values

# to simplify it a little, everyone is going to be either Korean or American
# and have either American citizenship or Korean citizenship
# the actual database allows for multiple citizenships and multiple nationalities
# and it has every country/territory/region

citizenship <- c(
'Korea, Republic of'
,'United States of America')

citizenship.sample <- sample(citizenship
                             , size = length(parent_student_list$parent_email)
                             , replace = TRUE
                             , prob = c(0.3, 0.7))

nationality <- c(
'South Korean', 
'American')

nationality.sample <- sample(nationality
                             , size = length(parent_student_list$parent_email)
                             , replace = TRUE
                             , prob = c(0.8, 0.2))

highest_education_level <- c(
  'No education'
  ,'Some grade/primary school'
  ,'Completed grade/primary school'
  ,'Some high/secondary school'
  ,'Graduated from high/secondary school (or equivalent)'
  ,'Some trade school or community college'
  ,'Graduated from trade school or community college'
  ,'Some college/university'
  ,'Graduated from college/university'
  ,'Some graduate school'
  ,'Graduate school')

highest_education_level.sample <- sample(highest_education_level
                             , size = length(mock_parents.df$email)
                             , replace = TRUE
                             , prob = c(rep(0.05,8),0.4,0.05,0.15)) 
# highest_education_level.sample

# View(parent_education.df)

# we're going to make the degrees in our mock data match up to the highest_education level
# this isn't going to allow for the "professional" degrees or 'other' but it's a pretty good fit

degree_type <- c(
  'No degree'
  ,'GED or equivalent'
  ,"Associate''s (AA, AS)"
  ,"Bachelor''s (BA, BS)"
  ,"Master''s (MA, MS)"
  ,'Business (MBA, MAcc)'
  ,'Law (JD, LLM)'
  ,'Medicine (MD, DO, DVM, DDS)'
  ,'Doctorate (PhD, EdD, etc.)'
  ,'Other')

fit_degree_to_education_level <- function(education_level_vector) {
  if (education_level_vector == 'Graduated from high/secondary school (or equivalent)'){
    matched_degree_type <- "GED or equivalent" 
  } else if (education_level_vector == 'Graduated from trade school or community college'){
    matched_degree_type <- "Associate''s (AA, AS)"
  } else if (education_level_vector == 'Graduated from college/university'){
    matched_degree_type <- "Bachelor''s (BA, BS)"
  } else if (education_level_vector == 'Some graduate school'){
    matched_degree_type <- "Bachelor''s (BA, BS)"
  } else if (education_level_vector == 'Graduate school'){
    matched_degree_type <- "Master''s (MA, MS)"
  } else {
    matched_degree_type <- "No degree"
  }
  return(matched_degree_type)
}

# apply the function to every education level in the sample
fitted_degree_type <- sapply(highest_education_level.sample, fit_degree_to_education_level)
# make a data frame
parent_education.df <- data.frame(highest_education_level.sample, fitted_degree_type)
# rename columns
colnames(parent_education.df) = c('highest_education_level', 'degree_type')

# going to go ahead and make data frames for parent_nationality, parent_citizenship, student_nationality, student_citizenship

parent_citizenship.df <- data.frame(mock_parents.df$email, citizenship.sample)
colnames(parent_citizenship.df) <- c('parent_email', 'citizenship')

student_citizenship.df <- data.frame(mock_students.df$email, citizenship.sample)
colnames(student_citizenship.df) <- c('student_email', 'citizenship')

parent_nationality.df <- data.frame(mock_parents.df$email, nationality.sample)
colnames(parent_nationality.df) <- c('parent_email', 'nationality')

student_nationality.df <- data.frame(mock_students.df$email, nationality.sample)
colnames(student_nationality.df) <- c('student_email', 'nationality')

# we also need to pair students with parents via email since that's what my procedures do
# this would be done at client intake via access but for now
# i will just use the matches I made in R
# i weighted the probabilities that different relationships would be chosen for our parents and students

relationship <- c(
  'Mother (Biological)'
  ,'Father (Biological)'
  ,'Legal Guardian'
  ,'Aunt'
  ,'Uncle'
  ,'Brother'
  ,'Sister'
  ,'Cousin'
  ,'Stepbrother'
  ,'Stepsister'
  ,'Other')

parent_student_list <- data.frame(
  mock_parents.df$email
  , mock_students.df$email
  , sample(relationship
           , size = length(mock_students.df$email)
           , replace = TRUE
           , prob = c(0.35,0.35,0.14,0.03,0.04,0.02,0.02,0.01,0.01,0.01,0.01)))

# rename columns
colnames(parent_student_list) = c('parent_email', 'student_email', 'relationship')

# the final data we need to generate are our college applications

# i didn't build this in my data base yet but I've compiled a list of the US News and World Report's
# top 25 universities. 
# (which in no way do I believe reflects the top 25 places to get an education,
# but it's a metric to measure success in this industry so)

# I'm going to add these rankings to the data frame as a new column (and name the dataframe something else)
# just in case i accidentally write the csv 

institution.with.rankings.df <- institution.df
# View(institution.with.rankings.df)

# we just need a new vector with the same length as the dataframe so here we go
institution.with.rankings.df$ranking <- institution.df$zipcode

# set all rankings to NA
institution.with.rankings.df$ranking <- NA

# rankings based on most recent US News and World Report

top_25_national_universities_2021 <- c(
  'Princeton University'
  , 'Harvard University'
  , 'Columbia University in the City of New York'
  , 'Massachusetts Institute of Technology'
  , 'Yale University'
  , 'Stanford University'
  , 'University of Chicago'
  , 'University of Pennsylvania'
  , 'California Institute of Technology'
  , 'Johns Hopkins University'
  , 'Northwestern University'
  , 'Duke University'
  , 'Dartmouth College'
  , 'Brown University'
  , 'Vanderbilt University'
  , 'Rice University'
  , 'Washington University in St Louis'
  , 'Cornell University'
  , 'University of Notre Dame'
  , 'University of California - Los Angeles'
  , 'Emory University'
  , 'University of California, Berkeley'
  , 'Georgetown University'
  , 'University of Michigan - Ann Arbor'
  , 'University of Southern California'
)
ranking_values <- c(1:3,4,4,6,6,8,9,9,9,12,13,14,14,16,16,18:23,24,24)
# we need to make our vectors the same length as our data frame vectors, or else, problems
filler_for_rankings <- rep(NA, sum(length(institution.df$institution_id), -25))
top_25_national_universities_2021 <- c(top_25_national_universities_2021, filler_for_rankings)
ranking_values <- c(ranking_values, filler_for_rankings)

# make comparison data frame
top_25_national_universities_2021.df <- data.frame(ranking_values, top_25_national_universities_2021)
colnames(top_25_national_universities_2021.df) = c('ranking', 'institution_name')

# get indexes of top institutions
top.institution.indexes <- match(top_25_national_universities_2021.df$institution_name, institution.with.rankings.df$institution_name)
# top.institution.indexes

# and now we can add the rankings to the correct rows

# remove the NAs (was just necessary for match)

top.institution.indexes <- top.institution.indexes[1:25]

top_25_national_universities_2021.df <- top_25_national_universities_2021.df[1:25,]

institution.with.rankings.df[top.institution.indexes,16] <- top_25_national_universities_2021.df$ranking

########### uncomment to export
# write.csv(institution.with.rankings.df, "C:\\Users\\SamDe\\Desktop\\MS\\cleaned.institution-now_with_rankings-import.csv", row.names = FALSE)

# at long last, our data frame has rankings added to it

# we are going to have our students apply following standard admissions rules, where they can do 1 ED school
# and if they get, they go there
# they can apply to many EA schools and many regular decision schools

# most schools aren't rolling admissions so I'm not going to write that in at the moment
# generating samples for all college applications

# now for the schools

# this is for all submitted applications only, can build additional control for submitted vs not submitted
# this is not perfect, but it will work ok for my purposes right now

# Chad I'm going to spare you having to read tons more code and I'm only going to do 5 students applying to 10 colleges each for the deliverable
# instead of the 100 students I have in my database

student_applicants <- rep(mock_students.df$email[23:27], 10)
application_type <- c('Early Decision', rep('Early Action', 4), rep('Regular Decision', 10))
student_application_types <- replicate(5, sample(application_type, size = 10, replace = FALSE))
student_institution.sample <- replicate(5, sample(top_25_national_universities_2021.df$institution_name, size = 10, replace = FALSE))
student_application_statuses <- rep('Submitted', 10)
admissions_decision <- c(
  'Accepted'
  ,'Rejected'
  ,'Waitlisted'
  ,'Other')
student_admissions_decision <- replicate(5, sample(admissions_decision, size = 10, replace = TRUE, prob= c(0.20,0.55,0.25,0)))

# i'm just going to add 'Decided to attend' to 1 school (if it's the ED school, then that school) and 'Declined to attend' to all the rest
# i already tried to programatically do it and ran into some trouble and I'm not going to worry about it right now
# i'll add the Decided to attend after I make the tables

default_attendance <- rep('Declined to attend', 10)

student_1_applications <- data.frame(rep(mock_students.df$email[4],10), student_application_types[,1]
                          , student_institution.sample[,1], student_application_statuses
                          , student_admissions_decision[,1], default_attendance)
colnames(student_1_applications) <- c('student_email', 'application_type', 'institution_name', 'application_status', 'admissions_decision', 'attendance_decision')

# I could definitely write a function to do this, but it's just 5 students so I won't worry about it right now

student_2_applications <- data.frame(rep(mock_students.df$email[16],10), student_application_types[,2]
                                     , student_institution.sample[,2], student_application_statuses
                                     , student_admissions_decision[,2], default_attendance)
colnames(student_2_applications) <- c('student_email', 'application_type', 'institution_name', 'application_status', 'admissions_decision', 'attendance_decision')

student_3_applications <- data.frame(rep(mock_students.df$email[25],10), student_application_types[,3]
                                     , student_institution.sample[,3], student_application_statuses
                                     , student_admissions_decision[,3], default_attendance)
colnames(student_3_applications) <- c('student_email', 'application_type', 'institution_name', 'application_status', 'admissions_decision', 'attendance_decision')

student_4_applications <- data.frame(rep(mock_students.df$email[34],10), student_application_types[,4]
                                     , student_institution.sample[,4], student_application_statuses
                                     , student_admissions_decision[,4], default_attendance)
colnames(student_4_applications) <- c('student_email', 'application_type', 'institution_name', 'application_status', 'admissions_decision', 'attendance_decision')

student_5_applications <- data.frame(rep(mock_students.df$email[48],10), student_application_types[,5]
                                     , student_institution.sample[,5], student_application_statuses
                                     , student_admissions_decision[,5], default_attendance)
colnames(student_5_applications) <- c('student_email', 'application_type', 'institution_name', 'application_status', 'admissions_decision', 'attendance_decision')

# I cycled through View(student_n_applications) to see what schools students got into

student_1_applications[4,6] = 'Decided to attend'
student_2_applications[5,6] = 'Decided to attend'
student_3_applications[3,6] = 'Decided to attend'
student_4_applications[6,6] = 'Decided to attend'
student_5_applications[7,6] = 'Decided to attend'

# now that i've generated all my data I can put it in SQL

# the odbc orm has issues with remote access to sql server on this virtual machine
# can use this as a workaround

# this prints the SQL i need to run to populate my parent_student_list table

sp_insert_record_into_parent_student_list <- cat(paste0(
  'EXEC sp_insert_record_into_parent_student_list'
  ," '"
  , parent_student_list$parent_email
  ,"'"
  ,','
  ," '"
  , parent_student_list$student_email
  ,"'"
  ,','
  ," '"
  , parent_student_list$relationship
  ,"'")
  , sep="\n")

# going to use the same method for the other stored procedures
# parent demographic tables

sp_insert_parent_records_into_demographic_tables <- cat(paste0(
  'EXEC sp_insert_parent_records_into_demographic_tables'
  ," '"
  , mock_parents.df$email
  ,"'"
  ,','
  ," '"
  , parent_education.df$highest_education_level
  ,"'"
  ,','
  ," '"
  , parent_education.df$degree_type
  ,"'"
  ,','
  ," '"
  , parent_citizenship.df$citizenship
  ,"'"
  ,','
  ," '"
  , parent_nationality.df$nationality
  ,"'")
  , sep="\n")

# student demographic tables

sp_insert_student_records_into_demographic_tables <- cat(paste0(
  'EXEC sp_insert_student_records_into_demographic_tables'
  ," '"
  , mock_students.df$email
  ,"'"
  ,','
  ," '"
  , student_citizenship.df$citizenship
  ,"'"
  ,','
  ," '"
  , student_nationality.df$nationality
  ,"'")
  , sep="\n")

# college applications

sp_insert_record_into_college_application <- cat(paste0(
  'EXEC sp_insert_record_into_college_application'
  ," '"
  , student_1_applications$student_email
  ,"'"
  ,','
  ," '"
  , student_1_applications$application_type
  ,"'"
  ,','
  ," '"
  , student_1_applications$institution_name
  ,"'"
  ,','
  ," '"
  , student_1_applications$application_status
  ,"'"
  ,','
  ," '"
  , student_1_applications$admissions_decision
  ,"'"
  ,','
  ," '"
  , student_1_applications$attendance_decision
  ,"'")
  , sep="\n")


sp_insert_record_into_college_application <- cat(paste0(
  'EXEC sp_insert_record_into_college_application'
  ," '"
  , student_2_applications$student_email
  ,"'"
  ,','
  ," '"
  , student_2_applications$application_type
  ,"'"
  ,','
  ," '"
  , student_2_applications$institution_name
  ,"'"
  ,','
  ," '"
  , student_2_applications$application_status
  ,"'"
  ,','
  ," '"
  , student_2_applications$admissions_decision
  ,"'"
  ,','
  ," '"
  , student_2_applications$attendance_decision
  ,"'")
  , sep="\n")


sp_insert_record_into_college_application <- cat(paste0(
  'EXEC sp_insert_record_into_college_application'
  ," '"
  , student_3_applications$student_email
  ,"'"
  ,','
  ," '"
  , student_3_applications$application_type
  ,"'"
  ,','
  ," '"
  , student_3_applications$institution_name
  ,"'"
  ,','
  ," '"
  , student_3_applications$application_status
  ,"'"
  ,','
  ," '"
  , student_3_applications$admissions_decision
  ,"'"
  ,','
  ," '"
  , student_3_applications$attendance_decision
  ,"'")
  , sep="\n")


sp_insert_record_into_college_application <- cat(paste0(
  'EXEC sp_insert_record_into_college_application'
  ," '"
  , student_4_applications$student_email
  ,"'"
  ,','
  ," '"
  , student_4_applications$application_type
  ,"'"
  ,','
  ," '"
  , student_4_applications$institution_name
  ,"'"
  ,','
  ," '"
  , student_4_applications$application_status
  ,"'"
  ,','
  ," '"
  , student_4_applications$admissions_decision
  ,"'"
  ,','
  ," '"
  , student_4_applications$attendance_decision
  ,"'")
  , sep="\n")


sp_insert_record_into_college_application <- cat(paste0(
  'EXEC sp_insert_record_into_college_application'
  ," '"
  , student_5_applications$student_email
  ,"'"
  ,','
  ," '"
  , student_5_applications$application_type
  ,"'"
  ,','
  ," '"
  , student_5_applications$institution_name
  ,"'"
  ,','
  ," '"
  , student_5_applications$application_status
  ,"'"
  ,','
  ," '"
  , student_5_applications$admissions_decision
  ,"'"
  ,','
  ," '"
  , student_5_applications$attendance_decision
  ,"'")
  , sep="\n")



