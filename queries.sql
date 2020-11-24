-- Join the two
-- tables so that every column and record appears, regardless of
-- if there is not an owner_id. Your output should look like
-- this:

/*
id | first_name | last_name | id |  make  |  model  | year |  price  | owner_id
----+------------+-----------+----+--------+---------+------+---------+----------
  1 | Bob        | Hope      |  1 | Toyota | Corolla | 2002 | 2999.99 |        1
  1 | Bob        | Hope      |  2 | Honda  | Civic   | 2012 |   13000 |        1
  2 | Jane       | Smith     |  3 | Nissan | Altima  | 2016 |   24000 |        2
  2 | Jane       | Smith     |  4 | Subaru | Legacy  | 2006 | 5999.99 |        2
  3 | Melody     | Jones     |  5 | Ford   | F150    | 2012 | 2599.99 |        3
  3 | Melody     | Jones     |  6 | GMC    | Yukon   | 2016 |   13000 |        3
  4 | Sarah      | Palmer    |  7 | GMC    | Yukon   | 2014 |   23000 |        4
  4 | Sarah      | Palmer    |  8 | Toyota | Avalon  | 2009 |   13000 |        4
  4 | Sarah      | Palmer    |  9 | Toyota | Camry   | 2013 |   13000 |        4
  5 | Alex       | Miller    | 10 | Honda  | Civic   | 2001 | 7999.99 |        5
  6 | Shana      | Smith     | 11 | Nissan | Altima  | 1999 | 1899.99 |        6
  6 | Shana      | Smith     | 12 | Lexus  | ES350   | 1998 | 1599.99 |        6
  6 | Shana      | Smith     | 13 | BMW    | 300     | 2012 |   23000 |        6
  6 | Shana      | Smith     | 14 | BMW    | 700     | 2015 |   53000 |        6
  7 | Maya       | Malarkin  |    |        |         |      |         |
(15 rows)
*/

SELECT *
FROM owners LEFT JOIN vehicles ON owners.id=vehicles.owner_id;

-- Count the number of cars for each owner. Display the owners first_name, last_name and count of vehicles. The first_name should be ordered in ascending order. Your output should look like this:
/*
first_name | last_name | count
------------+-----------+-------
Alex       | Miller    |     1
Bob        | Hope      |     2
Jane       | Smith     |     2
Melody     | Jones     |     2
Sarah      | Palmer    |     3
Shana      | Smith     |     4
(6 rows)
*/

SELECT first_name, last_name, COUNT(*) as count
FROM owners JOIN vehicles ON owners.id = vehicles.owner_id
GROUP BY first_name, last_name
ORDER BY first_name asc;

-- Count the number of cars for each owner and display the average price for each of the cars as integers. Display the owners first_name, last_name, average price and count of vehicles. The first_name should be ordered in descending order. Only display results with more than one vehicle and an average price greater than 10000. Your output should look like this:
/*
first_name | last_name | average_price | count
------------+-----------+---------------+-------
Shana      | Smith     |         19875 |     4
Sarah      | Palmer    |         16333 |     3
Jane       | Smith     |         15000 |     2
*/

SELECT first_name, last_name, ROUND(AVG(price)) as average_price, COUNT(*) as count
FROM owners JOIN vehicles ON owners.id = vehicles.owner_id
GROUP BY first_name, last_name
HAVING COUNT(*) > 1 AND AVG(price) > 10000
ORDER BY first_name desc;


-- SQL Zoo Exercises 6 & 7

-- 6 JOIN 

1.
-- The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime

-- Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'

SELECT matchid, player
FROM goal
WHERE teamid = 'GER';

2.
-- From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.

-- Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.

-- Show id, stadium, team1, team2 for just game 1012

SELECT id, stadium, team1, team2
FROM game
WHERE id = 1012;

3.
-- You can combine the two steps into a single query with a JOIN.

-- SELECT *
--   FROM game JOIN goal ON (id=matchid)
-- The FROM clause says to merge data from the goal table with that from the game table. The ON says how to figure out which rows in game go with which rows in goal - the matchid from goal must match id from game. (If we wanted to be more clear/specific we could say
-- ON (game.id=goal.matchid)

-- The code below shows the player (from the goal) and stadium name (from the game table) for every goal scored.

-- Modify it to show the player, teamid, stadium and mdate for every German goal.

SELECT player, teamid, stadium, mdate
FROM game JOIN goal ON id=matchid
WHERE teamid = 'GER';

4.
-- Use the same JOIN as in the previous question.

-- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'

SELECT team1, team2, player
FROM game JOIN goal ON id=matchid
WHERE player LIKE 'Mario%';

5.
-- The table eteam gives details of every national team including the coach. You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT player, teamid, coach, gtime
FROM goal JOIN eteam ON teamid= id
WHERE gtime<=10

6.
-- To JOIN game with eteam you could use either
-- game JOIN eteam ON (team1=eteam.id) or game JOIN eteam ON (team2=eteam.id)

-- Notice that because id is a column name in both game and eteam you must specify eteam.id instead of just id

-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

SELECT mdate, teamname
FROM game JOIN eteam ON team1 = eteam.id
WHERE coach = 'Fernando Santos';

7.
-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

SELECT player
FROM goal JOIN game ON id = matchid
WHERE stadium = 'National Stadium, Warsaw';

8.
-- The example query shows all goals scored in the Germany-Greece quarterfinal.
-- Instead show the name of all players who scored a goal against Germany.

SELECT DISTINCT player
FROM game JOIN goal ON matchid = id
WHERE (teamid <> 'GER') AND (team1='GER' OR team2='GER');

9.
-- Show teamname and the total number of goals scored.

SELECT teamname, COUNT(*)
FROM eteam JOIN goal ON id=teamid
GROUP BY teamname
ORDER BY teamname;

10.
-- Show the stadium and the number of goals scored in each stadium.

SELECT stadium, COUNT(*)
FROM game JOIN goal ON id = matchid
GROUP BY stadium;

11.
-- For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT matchid, mdate, COUNT(*)
FROM game JOIN goal ON matchid = id
WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid;

12.
-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'

SELECT matchid, mdate, COUNT(*)
FROM game JOIN goal ON matchid = id
WHERE (team1='GER' OR team2='GER') AND teamid = 'GER'
GROUP BY matchid;

13.
-- List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
-- mdate	team1	score1	team2	score2
-- 1 July 2012	ESP	4	ITA	0
-- 10 June 2012	ESP	1	ITA	1
-- 10 June 2012	IRL	1	CRO	3
-- ...
-- Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.

SELECT mdate,
    team1,
    SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1,
    team2,
    SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) score2
FROM game LEFT JOIN goal ON matchid = id
GROUP BY mdate, matchid, team1, team2;


-- 7 MORE JOIN EXERCISES 

1.
-- List the films where the yr is 1962 [Show id, title]

SELECT id, title
FROM movie
WHERE yr=1962;

2.
-- Give year of 'Citizen Kane'.

SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

3.
-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.

SELECT id, title, yr
FROM movie
WHERE title LIKE 'Star Trek%'
ORDER BY yr;

4.
-- What id number does the actor 'Glenn Close' have?

SELECT id
FROM actor
WHERE name = 'Glenn Close';

5.
-- What is the id of the film 'Casablanca'

SELECT id
FROM movie
WHERE title = 'Casablanca';

6.
-- Obtain the cast list for 'Casablanca'.

-- what is a cast list?
-- Use movieid=11768, (or whatever value you got from the previous question)

SELECT name
FROM casting JOIN actor ON casting.actorid = actor.id
WHERE movieid=11768;

7.
-- Obtain the cast list for the film 'Alien'

SELECT name
FROM casting JOIN movie ON casting.movieid = movie.id JOIN actor ON casting.actorid = actor.id
WHERE title = 'Alien';

8.
-- List the films in which 'Harrison Ford' has appeared

SELECT title
FROM casting JOIN movie ON casting.movieid = movie.id JOIN actor ON casting.actorid = actor.id
WHERE name = 'Harrison Ford';

9.
-- List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

SELECT title
FROM casting JOIN movie ON casting.movieid = movie.id JOIN actor ON casting.actorid = actor.id
WHERE name = 'Harrison Ford' AND ord != 1;

10.
-- List the films together with the leading star for all 1962 films.

SELECT title, name
FROM casting JOIN actor ON casting.actorid = actor.id JOIN movie ON casting.movieid=movie.id
WHERE yr = 1962 AND ord = 1;

11.
-- Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

SELECT yr, COUNT(title)
FROM
    movie JOIN casting ON movie.id=movieid
    JOIN actor ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

12.
-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.

SELECT title, name
FROM movie JOIN casting ON (movieid = movie.id AND ord=1) JOIN actor ON (actorid = actor.id)
WHERE movie.id IN (SELECT movieid
FROM casting
WHERE actorid IN (SELECT id
FROM actor
WHERE name='Julie Andrews')
)

13.
-- Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.

SELECT DISTINCT name
FROM actor JOIN casting ON actor.id = actorid
WHERE (SELECT COUNT(ord)
FROM casting
WHERE casting.actorid = actor.id AND ord = 1) >= 15
ORDER BY name;

14.
-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

SELECT title, COUNT(actorid)
FROM movie
    JOIN casting ON (id = movieid)
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) desc, title;

15.
-- List all the people who have worked with 'Art Garfunkel'.


SELECT DISTINCT name
FROM actor JOIN casting ON(actor.id = casting.actorid)
WHERE casting.movieid IN(SELECT movieid
    FROM casting JOIN actor ON (actorid=id)
    WHERE name = 'Art Garfunkel') AND actor.name != 'Art Garfunkel';