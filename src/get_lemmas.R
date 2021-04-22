library(tidytext)
library(tidyverse)
library(widyr)
library(textstem)
library(stringr)

combine_terms <- Vectorize(function(text) {
  race_dict <- c("black", "white", "negro", "color", "colored")
  gender_dict <- c("woman", "man", "boy", "girl", "lady", "men", "women", "person", "people", "soldier", "officer", "commander")
  for (i in race_dict) {
    for (j in gender_dict) {
      text <- str_replace_all(text, paste(i,j), paste(i,j,sep=""))
    }
  }
  return(text)
})

# S32
s32 <- read.csv(here::here("data", "s32_clean.csv"))

# remove punc
s32$long <- str_replace_all(s32$long, '[^\\w\\s]|\\_', '')

# combine terms
s32$long <- combine_terms(s32$long)

# get tokens
s32_lemmas_ct <- s32 %>%
  select(index, racial_group, long) %>%
  unnest_tokens(word, long) %>%
  filter(!word %in% stop_words$word) %>%
  mutate(lemma = lemmatize_words(word))

write.csv(s32_lemmas_ct, here::here("data", "s32_lemmas_ct.csv"))

# S144
s144 <- read.csv(here::here('data', 's144_clean_v2.csv'))

# remove punc
s144$q85 <- str_replace_all(s144$q85, '[^\\w\\s]|\\_', '')

# combine terms
s144$q85 <- combine_terms(s144$q85)

# get lemmas
s144_lemmas_ct <- s144 %>%
  select(id, q85) %>%
  unnest_tokens(word, q85) %>%
  filter(!word %in% stop_words$word) %>%
  mutate(lemma = lemmatize_words(word))

write.csv(s144_lemmas_ct, here::here('data', 's144_lemmas_ct.csv'))


# S144 Topic Modeling
# read in data
s144_pos <- read.csv(here::here("data", "s144_pos_topics.csv"))
s144_neg <- read.csv(here::here("data", "s144_neg_topics.csv"))
s144_topics <- rbind(s144_neg, s144_pos)

lemmas <- s144_topics %>%
  unnest_tokens(word, q85) %>%
  filter(!word %in% stop_words$word) %>%
  mutate(lemma = textstem::lemmatize_words(word)) 

write.csv(lemmas, here::here('data', 's144_sentiment_topic_lemmas.csv'))
