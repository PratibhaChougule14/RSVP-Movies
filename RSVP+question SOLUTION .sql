USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb'
ORDER BY table_rows ASC;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT count(*) 
FROM MOVIE 
WHERE id IS NULL OR 
 TITLE IS NULL OR  
 YEAR IS NULL OR 
 DATE_PUBLISHED IS NULL OR  
 DURATION IS NULL OR  
 COUNTRY IS NULL OR  
 worlwide_gross_income IS NULL OR 
 languages IS NULL OR 
 production_company IS NULL;

SELECT 
    sum(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id, 
    sum(CASE WHEN title IS NULL THEN 1 ELSE 0 END) as title, 
    sum(CASE WHEN year IS NULL THEN 1 ELSE 0 END) as year,
    sum(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) as date_published,
    sum(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) as duration,
    sum(CASE WHEN country IS NULL THEN 1 ELSE 0 END) as country,
    sum(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) as worlwide_gross_income,
    sum(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) as languages,
    sum(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) as production_company
from movie; 
-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 

-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- movies released each year
Select year, count(title) as number_of_movies from movie group by year;

-- movies released per month
Select month(date_published) as month_num, count(title) as number_of_movies 
from movie
group by month(date_published)
order by month(date_published) asc;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select country, count(title) as movies 
from movie 
where YEAR = '2019' OR COUNTRY = 'USA' OR COUNTRY = 'India'
group by country;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
Select genre, count(movie_id) as no_of_movies
from genre
group by genre
order by no_of_movies desc;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
Select genre, count(movie_id) as no_of_movies
from genre
group by genre
order by no_of_movies desc
limit 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(*) AS no_of_movies_with_one_genre
FROM genre g1
WHERE NOT EXISTS (SELECT 1 FROM genre g2 WHERE g2.movie_id = g1.movie_id AND g2.genre <> g1.genre);
 
/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

SELECT Genre.Genre, AVG (Movie.duration) AS AVG_DURATION
FROM Genre, Movie 
WHERE (Movie.ID)=(Genre.Movie_id)
GROUP BY Genre.Genre
ORDER BY AVG_DURATION ASC;

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT GENRE, COUNT(MOVIE_ID) AS MOVIE_COUNT, RANK() OVER (order by GENRE) AS GENRE_RANK
FROM GENRE
GROUP BY GENRE
ORDER BY MOVIE_COUNT DESC;

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT MIN(AVG_RATING) AS MIN_AVG_RATING,
	   MAX(AVG_RATING) AS MAX_AVG_RATING,
       MIN(TOTAL_VOTES) AS MIN_TOTAL_VOTES,
	   MAX(TOTAL_VOTES) AS MAX_TOTAL_VOTES,
       MIN(MEDIAN_RATING) AS MIN_MEDIAN_RATING,
	   MAX(MEDIAN_RATING) AS MAX_MEDIAN_RATING
FROM RATINGS;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT title, avg_rating,
		DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON r.movie_id = m.id
LIMIT 10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:
+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT MEDIAN_RATING, COUNT(MOVIE_ID) AS MOVIE_COUNT
FROM RATINGS
GROUP BY MEDIAN_RATING
ORDER BY MOVIE_COUNT;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT MOVIE.PRODUCTION_COMPANY, COUNT(RATINGS.MOVIE_ID) AS MOVIE_COUNT, 
	   RANK() OVER (PARTITION BY RATINGS.AVG_RATING > 8 
       ORDER BY COUNT(RATINGS.MOVIE_ID) DESC) AS PROD_COMPANY_RANK
FROM MOVIE 
INNER JOIN RATINGS
ON MOVIE.ID = RATINGS.MOVIE_ID 
WHERE AVG_RATING > 8 AND production_company IS NOT NULL
GROUP BY PRODUCTION_COMPANY;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
 
 SELECT GENRE, COUNT(RATINGS.MOVIE_ID) AS MOVIE_COUNT
 FROM GENRE
 INNER JOIN RATINGS USING (MOVIE_ID)
 INNER JOIN MOVIE
 ON MOVIE.ID = RATINGS.MOVIE_ID 
 WHERE MOVIE.YEAR = '2017' AND MOVIE.COUNTRY = 'USA' AND MONTH(MOVIE.DATE_PUBLISHED) = '3' 
		AND RATINGS.TOTAL_VOTES > 1000
 GROUP BY GENRE.GENRE
 ORDER BY MOVIE_COUNT DESC;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT MOVIE.TITLE, RATINGS.AVG_RATING AS AVG_RATING, GENRE.GENRE
FROM MOVIE
INNER JOIN RATINGS ON (Movie.ID)=(Ratings.Movie_id)
INNER JOIN GENRE USING (MOVIE_ID)
WHERE MOVIE.TITLE LIKE 'THE%' AND AVG_RATING > 8 
GROUP BY MOVIE.TITLE
ORDER BY AVG_RATING DESC;

SELECT MOVIE.TITLE, RATINGS.MEDIAN_RATING AS MEDIAN_RATING, GENRE.GENRE
FROM MOVIE
INNER JOIN RATINGS ON (Movie.ID)=(Ratings.Movie_id)
INNER JOIN GENRE USING (MOVIE_ID)
WHERE MOVIE.TITLE LIKE 'THE%' AND  MEDIAN_RATING > 8 
GROUP BY MOVIE.TITLE
ORDER BY MEDIAN_RATING DESC;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT MOVIE.TITLE, MOVIE.DATE_PUBLISHED, RATINGS.MEDIAN_RATING AS MEDIAN_RATING
FROM MOVIE
INNER JOIN RATINGS ON (Movie.ID)=(Ratings.Movie_id)
WHERE MEDIAN_RATING >= 8 OR MOVIE.DATE_PUBLISHED BETWEEN 4/1/2018 AND 4/1/2019
GROUP BY MOVIE.TITLE
ORDER BY MEDIAN_RATING DESC;

-- Once again, try to solve the problem given below.

-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT MOVIE.COUNTRY, RATINGS.TOTAL_VOTES
FROM MOVIE
INNER JOIN RATINGS ON RATINGS.MOVIE_ID = MOVIE.ID
WHERE MOVIE.COUNTRY = 'Germany' OR MOVIE.COUNTRY = 'ITALY'
GROUP BY MOVIE.COUNTRY;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    sum(CASE WHEN NAME IS NULL THEN 1 ELSE 0 END) AS NAME_NULLS, 
    sum(CASE WHEN HEIGHT IS NULL THEN 1 ELSE 0 END) as HEIGHT_NULLS, 
    sum(CASE WHEN DATE_OF_BIRTH IS NULL THEN 1 ELSE 0 END) as DATE_OF_BIRTH_NULLS,
    sum(CASE WHEN KNOWN_FOR_MOVIES IS NULL THEN 1 ELSE 0 END) as KNOWN_FOR_MOVIES_NULLS
FROM NAMES;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genre AS
(
	SELECT g.genre, COUNT(g.movie_id) AS movie_count
	FROM genre AS g
	INNER JOIN ratings AS r
	ON g.movie_id = r.movie_id
	WHERE avg_rating > 8
    GROUP BY genre
    ORDER BY movie_count
    LIMIT 3
),

top_director AS
(
SELECT n.name AS director_name,
		COUNT(g.movie_id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY COUNT(g.movie_id) DESC) AS director_row_rank
FROM names AS n 
INNER JOIN director_mapping AS dm 
ON n.id = dm.name_id 
INNER JOIN genre AS g 
ON dm.movie_id = g.movie_id 
INNER JOIN ratings AS r 
ON r.movie_id = g.movie_id,
top_genre
WHERE g.genre in (top_genre.genre) AND avg_rating>8
GROUP BY director_name
ORDER BY movie_count DESC
)

SELECT *
FROM top_director
WHERE director_row_rank <= 3
LIMIT 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT DISTINCT name AS actor_name, COUNT(r.movie_id) AS movie_count
FROM ratings AS r
INNER JOIN role_mapping AS rm
ON rm.movie_id = r.movie_id
INNER JOIN names AS n
ON rm.name_id = n.id
WHERE median_rating >= 8 AND category = 'actor'
GROUP BY name
ORDER BY movie_count DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT MOVIE.PRODUCTION_COMPANY AS PRODUCTION_COMPANY, SUM(RATINGS.total_votes) AS VOTE_COUNT,
	RANK() OVER (PARTITION BY COUNT(RATINGS.MOVIE_ID)
       ORDER BY SUM(RATINGS.TOTAL_VOTES) DESC) AS PROD_COMPANY_RANK
FROM MOVIE
JOIN RATINGS ON RATINGS.MOVIE_ID = MOVIE.ID
GROUP BY PRODUCTION_COMPANY
ORDER BY VOTE_COUNT DESC
LIMIT 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is 
based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT NAMES.NAME AS ACTOR_NAME, SUM(RATINGS.TOTAL_VOTES) AS TOTAL_VOTES,
	COUNT(MOVIE.ID) AS MOVIE_COUNT, RATINGS.AVG_RATING AS ACTOR_AVG_RATING,
    RANK() OVER (PARTITION BY ROLE_MAPPING.CATEGORY = 'ACTOR'
    ORDER BY RATINGS.AVG_RATING DESC) AS ACTOR_RANK
FROM NAMES
INNER JOIN ROLE_MAPPING ON ROLE_MAPPING.NAME_ID = NAMES.ID
INNER JOIN MOVIE ON MOVIE.ID = ROLE_MAPPING.MOVIE_ID
INNER JOIN RATINGS ON RATINGS.MOVIE_ID = MOVIE.ID
WHERE MOVIE.COUNTRY = 'India'
GROUP BY NAMES.NAME
having count(MOVIE.ID) >= 5
ORDER BY ACTOR_AVG_RATING DESC;
 
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT NAMES.NAME AS ACTRESS_NAME, RATINGS.TOTAL_VOTES,
	COUNT(MOVIE.ID) AS MOVIE_COUNT, 
	ROUND(SUM(RATINGS.AVG_RATING * RATINGS.TOTAL_VOTES)/SUM(RATINGS.TOTAL_VOTES),2) AS ACTRESS_AVG_RATING,
    RANK() OVER (ORDER BY ROUND(SUM(RATINGS.AVG_RATING * RATINGS.TOTAL_VOTES)/SUM(RATINGS.TOTAL_VOTES),2) DESC, TOTAL_VOTES DESC) AS ACTRESS_RANK
FROM NAMES
INNER JOIN ROLE_MAPPING ON ROLE_MAPPING.NAME_ID = NAMES.ID 
INNER JOIN MOVIE ON MOVIE.ID = ROLE_MAPPING.MOVIE_ID 
INNER JOIN RATINGS ON RATINGS.MOVIE_ID = MOVIE.ID
WHERE LANGUAGES LIKE '%Hindi%' AND COUNTRY LIKE '%India%' AND ROLE_MAPPING.CATEGORY = 'ACTRESS'
GROUP BY NAMES.NAME
having COUNT(MOVIE.ID) >= 3
LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT GENRE.GENRE, 
	   MOVIE.TITLE,
	   CASE 
			WHEN RATINGS.AVG_RATING > 8 THEN 'SUPERHIT_MOVIE'
			WHEN RATINGS.AVG_RATING BETWEEN 7 AND 8 THEN 'HIT_MOVIE'
			WHEN RATINGS.AVG_RATING BETWEEN 5 AND 7 THEN  'ONE_TIME_WATCH_MOVIE'
			ELSE 'FLOP_MOVIE'
	   END AS MOVIE_RATING
FROM GENRE
INNER JOIN MOVIE ON MOVIE.ID = GENRE.MOVIE_ID
INNER JOIN RATINGS ON RATINGS.MOVIE_ID = MOVIE.ID
WHERE GENRE.GENRE = 'Thriller';

---- OR

SELECT GENRE.GENRE, MOVIE.TITLE,
		(CASE WHEN (RATINGS.AVG_RATING > 8) THEN 1 ELSE 0 END) AS SUPERHIT_MOVIES,
        (CASE WHEN (RATINGS.AVG_RATING BETWEEN 7 AND 8) THEN 1 ELSE 0 END) AS HIT_MOVIES,
        (CASE WHEN (RATINGS.AVG_RATING BETWEEN 5 AND 7) THEN 1 ELSE 0 END) AS ONE_TIME_WATCH_MOVIES,
        (CASE WHEN (RATINGS.AVG_RATING < 5) THEN 1 ELSE 0 END) AS FLOP_MOVIES
FROM GENRE
INNER JOIN MOVIE ON MOVIE.ID = GENRE.MOVIE_ID
INNER JOIN RATINGS ON RATINGS.MOVIE_ID = MOVIE.ID
WHERE GENRE.GENRE = 'Thriller';

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
\ gere			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:)

WITH AVG_MOVIE_DURATION AS
(
SELECT GENRE.GENRE, AVG(MOVIE.DURATION) AS AVG_DURATION 
FROM GENRE
INNER JOIN MOVIE ON MOVIE.ID = GENRE.MOVIE_ID
GROUP BY GENRE.GENRE
)
SELECT *,
		SUM(AVG_DURATION) OVER W1 AS RUNNING_TOTAL,
        AVG(AVG_DURATION) OVER W2 AS RUNNING_TOTAL
FROM AVG_MOVIE_DURATION
WINDOW W1 AS (ORDER BY GENRE ROWS UNBOUNDED PRECEDING),
W2 AS (ORDER BY GENRE ROWS 10 PRECEDING); 

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_3_genre AS
( 	
	SELECT genre, COUNT(movie_id) AS number_of_movies
    FROM genre AS g
    INNER JOIN movie AS m
    ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),

top_5 AS
(
	SELECT genre,
			year,
			title AS movie_name,
			worlwide_gross_income,
			DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
        
	FROM movie AS m 
    INNER JOIN genre AS g 
    ON m.id= g.movie_id
	WHERE genre IN (SELECT genre FROM top_3_genre)
)

SELECT *
FROM top_5
WHERE movie_rank<=5;
-- Top 3 Genres based on most number of movies


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT PRODUCTION_COMPANY, COUNT(RATINGS.MOVIE_ID) AS MOVIE_COUNT, 
		RANK() OVER (ORDER BY COUNT(ID) DESC)
FROM MOVIE
INNER JOIN RATINGS ON RATINGS.MOVIE_ID = MOVIE.ID
WHERE POSITION(',' IN MOVIE.languages)>0
GROUP BY PRODUCTION_COMPANY;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT NAMES.NAME AS ACTRESS_NAME, SUM(RATINGS.TOTAL_VOTES) AS TOTAL_VOTES,
	COUNT(MOVIE.ID) AS MOVIE_COUNT, RATINGS.AVG_RATING AS ACTRESS_AVG_RATING,
    RANK() OVER (PARTITION BY ROLE_MAPPING.CATEGORY = 'ACTRESS'
    ORDER BY RATINGS.AVG_RATING DESC) AS ACTRESS_RANK
FROM NAMES
INNER JOIN ROLE_MAPPING ON ROLE_MAPPING.NAME_ID = NAMES.ID AND ROLE_MAPPING.CATEGORY = 'ACTRESS'
INNER JOIN MOVIE ON MOVIE.ID = ROLE_MAPPING.MOVIE_ID
INNER JOIN RATINGS ON RATINGS.MOVIE_ID = MOVIE.ID
INNER JOIN GENRE ON GENRE.MOVIE_ID = MOVIE.ID
WHERE MOVIE.COUNTRY = 'India' AND GENRE.GENRE = 'DRAMA'
GROUP BY NAMES.NAME
having RATINGS.AVG_RATING > 8
ORDER BY ACTRESS_AVG_RATING DESC;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH movie_date_info AS
(
SELECT d.name_id, name, d.movie_id,
	   m.date_published, 
       LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
FROM director_mapping d
	 JOIN names AS n 
     ON d.name_id=n.id 
	 JOIN movie AS m 
     ON d.movie_id=m.id
),

date_difference AS
(
	 SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	 FROM movie_date_info
 ),
 
 avg_inter_days AS
 (
	 SELECT name_id, AVG(diff) AS avg_inter_movie_days
	 FROM date_difference
	 GROUP BY name_id
 ),
 
 final_result AS
 (
	 SELECT d.name_id AS director_id,
		 name AS director_name,
		 COUNT(d.movie_id) AS number_of_movies,
		 ROUND(avg_inter_movie_days) AS inter_movie_days,
		 ROUND(AVG(avg_rating),2) AS avg_rating,
		 SUM(total_votes) AS total_votes,
		 MIN(avg_rating) AS min_rating,
		 MAX(avg_rating) AS max_rating,
		 SUM(duration) AS total_duration,
		 ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
	 FROM
		 names AS n 
         JOIN director_mapping AS d 
         ON n.id=d.name_id
		 JOIN ratings AS r 
         ON d.movie_id=r.movie_id
		 JOIN movie AS m 
         ON m.id=r.movie_id
		 JOIN avg_inter_days AS a 
         ON a.name_id=d.name_id
	 GROUP BY director_id
 )
 SELECT *	
 FROM final_result
 LIMIT 9;