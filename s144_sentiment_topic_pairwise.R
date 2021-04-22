library(tidyverse)
library(tidytext)
library(widyr)

lemmas <- read.csv(here::here('data', 's144_sentiment_topic_lemmas.csv'))

# get pairwise counts by sentiment and topic
cooc <- lemmas %>%
  group_by(sentiment, topic) %>%
  pairwise_count(lemma, id)

# get pairwise cor by sentiment and topic
sentiments <- c("POSITIVE", "NEGATIVE")
all_cor <- FALSE
for (i in seq(length(sentiments))) {
  tmp <- lemmas %>% filter(sentiment == sentiments[i])
  topics <- unique(tmp$topic)
  for (j in seq(length(topics))) {
    cor <- lemmas %>%
      filter(sentiment == sentiments[i]) %>%
      filter(topic == topics[j]) %>%
      pairwise_cor(lemma, id)
    
    cor$sentiment <- sentiments[i]
    cor$topic <- topics[j]
    
    if (all_cor == FALSE) {
      all_cor <- cor
    } else{
      all_cor <- rbind(all_cor, cor)
    }
  }
}

cor <- lemmas %>%
  group_by(sentiment, topic) %>%
  pairwise_cor(lemma, id)

# get word counts by sentiment and topic
word_counts <- lemmas %>%
  group_by(sentiment, topic) %>%
  count(lemma)

write.csv(cooc, here::here('data', 's144_sentiment_topic_cooc.csv'))
write.csv(all_cor, here::here('data', 's144_sentiment_topic_cor.csv'))
write.csv(word_counts, here::here('data', 's144_sentiment_topic_word_counts.csv'))