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

set.seed(1776)

png("hamilton_wordcloud.png", width = 12, height = 8, units = "in", res = 300)
wordcloud(words = d$word, freq = d$freq, min.freq = 5, scale= c(5, .1),
          max.words = Inf, random.order = FALSE)
dev.off()

