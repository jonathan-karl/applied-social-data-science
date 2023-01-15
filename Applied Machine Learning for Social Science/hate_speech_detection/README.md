# MY474 Classification Challenge

## Overview

Our final project involves classification of personal attacks in Wikipedia talk page comments. The competition page on Kaggle can be accessed [here](https://www.kaggle.com/c/my474-classification-challenge-2021)

Your task is to use what you have learned in class to build a classifier that performs well on a test set with the true labels obfuscated to prevent cheating. All of the comments in the train and test set were hand-labeled by folks at [Jigsaw](https://jigsaw.google.com/).

**Content warning:** This competition makes use of data from a project to automate moderation of toxic speech online. Many comments in this dataset contain hate speech and upsetting content. Please take care as you work on this assignment.

## Competition

Before you begin, please sign up for a new Kaggle account (even if you have one already), but use your **CANDIDATE NUMBER** in place of your name (see instructions below). Note that your candidate number is **NOT** the same as your LSE id number. [Read this page](http://www.lse.ac.uk/accounting/study/New-Arrival/Exams-and-Assessments) if you are having trouble finding your candidate number. You will submit your answers using this account.

1. Go to Kaggle.com and click "Register"
2. Click "Register with your email"
3. Enter your email address and choose a password.
4. Under "Full name" enter "lse" followed by your CANDIDATE NUMBER. For example, if my candidate number were 1234567, I would enter "lse1234567"

For your classifier, you can use any programming language you wish. You will be limited to two submissions per day. Each time you submit you will see your ranking on a public leader board. Your grade in the competition will be based on your final ranking on a private leader board that only I can see. This is to prevent overfitting to the test data. For details on how grades will be calculated look at the assessment criteria document on Moodle and the course website.

## Write-up

Before you begin with the competition, you should study the data you have been given. Compute descriptive statistics and devise some strategies for accurately classifying data into the binary outcome variable (`attack`). Record this exploratory analysis in your writeup.

As you participate in the competition, you should keep track of the models associated with the outputs you submit and record F1 as calculated using train, CV, and test error for models you submit to Kaggle. Each time you submit an answer, please commit the code that gave you this answer to the Github repository so you can recover old code that may have given you a better test score and so that we have a record of how you achieved the score you did. The competition closes at 2:00pm on May 24, 2021 which is also when the writeup is due. Your writeup should be about 3-5 pages and include the following:

* A description of the data using plots, tables, and your written observations of any patterns you have uncovered.
* An outline of potential features that you may use in the analysis (bag of words, word embeddings, etc.) and your thoughts about the usefulness of each feature representation.
* A description of custom features you may have constructed for this classification problem (e.g. comment length, count of consecutive capital letters, etc.) and why you think they might be informative.
* A writeup classification, dimension reduction, or other learning algorithms you will use and how you expect them to perform.
* A write up of your strategy for model selection. How do you select features? How do you select model hyperparameters? Why do some perform better than others? Include tables recording CV error for each approach and test error for models submitted to Kaggle.
* Conclusions and reflections on the modelling process.
* Code should be included in a separate Rmd file (or any other file type if you wish to use a language other than R).
* Both the code file (code for your best model) and the writeup file should be compiled as a PDF before you submit.

## Rules

* You can discuss resources, strategies, and approaches to classification with peers, but must write your own code and understand how it works. No copying and pasting from the web or your peers' code.
* After every submission, you must commit the code that produced your output to the assignment Github repository.
* You can use any pre-trained embeddings, and any external data except for data from Jigsaw or Wikipedia Talk pages.