LoadTweets = load '/home/meghna/Desktop/DataScience/PigProg/Sentiment-Analysis-on-Demonetization/demonetization-tweets.csv' USING PigStorage(',') ;
dictionary = load '/home/meghna/Desktop/DataScience/PigProg/Sentiment-Analysis-on-Demonetization/AFINN.txt' using PigStorage('\t') AS(word:chararray,rating:int);
--illustrate LoadTweets;
extract_detail = FOREACH LoadTweets GENERATE $0 as id,$1 as text;
tokens = foreach extract_detail generate id,text, FLATTEN(TOKENIZE(text)) As word;
word_rating = join tokens by word left outer, dictionary by word using 'replicated';
rating = foreach word_rating generate tokens::id as id,tokens::text as text, dictionary::rating as rate;
word_group = group rating by (id,text);
avg_rate = foreach word_group generate group, AVG(rating.rate) as tweet_rating;
positive_tweets = filter avg_rate by tweet_rating>=0;
negative_tweets = filter avg_rate by tweet_rating<0;
dump negative_tweets;

