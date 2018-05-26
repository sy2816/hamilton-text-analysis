library(pdftools)
setwd("~/GitHub/hamilton")

library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)

# data from https://github.com/amandavisconti/ham4corpus
text_nospeakers <- readLines("All_Lyrics_No_Speakers.txt")

#Cleaning up some encoding artifacts
text_nospeakers <- gsub(x = text_nospeakers, pattern = "â???T", replacement = "'", fixed = TRUE)
text_nospeakers <- gsub(x = text_nospeakers, pattern = "â???", replacement = "-", fixed = TRUE)
docs <- Corpus(VectorSource(text_nospeakers))

## Some text cleaning
# to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove  stopwords
docs <- tm_map(docs, removeWords, stopwords("SMART"))
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

#Remove random tilda
d <- d[-29,]


set.seed(1776)

# Some cheating to get 'hamilton' to show more prominately
d[1,2] <- d[1,2] - 15
d <- dplyr::arrange(d, desc(freq))

library(extrafont)
library(extrafontdb)

# To caps for stylization
d$word <- toupper(d$word)

library(wordcloud2)
wordcloud2(d, figPath = "logo.png", backgroundColor = "#dba018", fontFamily = "Garamond", color = "black",
           maxRotation = 0, size = 0.30)

