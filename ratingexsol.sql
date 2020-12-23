/**************************************************************/
*
/**Movie Ratings Ex1**/
/**Find the titles of all movies directed by Steven Spielberg**/
select m.title
  from Movie as m
 where m.director = 'Steven Spielberg'
;
/**************************************************************/
*
/**Movie Ratings Ex2**/
/**Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order**/
select distinct m.year
           from Movie as m, Rating as r
          where m.mID = r.mID
                and r.stars > 3
       order by m.year
;
/**************************************************************/
*
/**Movie Ratings Ex3**/
/**Find the titles of all movies that have no ratings**/
 select m.title 
   from Movie as m
  where mID not in (  select r.mID
                        from Rating as r
                   )
;
/**************************************************************/
*
/**Movie Ratings Ex4**/
/**Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date**/
select distinct v.name
  from Rating as r
         left outer join Reviewer as v on r.rID = v.rID
 where r.ratingDate is null
;
/**************************************************************/
*
/**Movie Ratings Ex5**/
/**Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars**/
  select v.name
         ,m.title
         ,r.stars
         ,r.ratingDate
    from rating as r
           left outer join reviewer as v on r.rID = v.rID
             left outer join movie as m on r.mID = m.mID
order by v.name
         ,m.title
         ,3
;
/**************************************************************/
*
/**Movie Ratings Ex6**/
/**For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie**/
select  v.name
        ,m.title 
  from  rating as r1
          left outer join reviewer as v on r1.rID = v.rID
            left outer join movie as m on r1.mID = m.mID
 where  exists ( select *
                   from rating as r2 
                  where r1.rID = r2.rID 
                        and r1.mID = r2.mID
                        and r1.stars > r2.stars
                        and r1.ratingDate > r2.ratingDate)
;
/**************************************************************/
*
/**Movie Ratings Ex7**/
/**For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title**/
  select  m.title
          ,max(r.stars) as stars
    from  rating as r
            left outer join movie as m on r.mID = m.mID
group by r.mID
order by m.title
;
/**************************************************************/
*
/**Movie Ratings Ex8**/
/**For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title**/
  select m.title
         ,(max(r.stars)- min(r.stars)) as ratingSpread
    from movie as m
           left outer join rating as r on m.mID = r.mID
group by m.mID
  having (max(r.stars)-min(r.stars)) is not null
order by 2 desc
         ,1
;
/**************************************************************/
*
/**Movie Ratings Ex9**/
/**Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)**/
select avg(pre80.avgstars) - avg(post80.avgstars)
  from ( select m.title
	            ,avg(r.stars) as avgstars
           from rating as r
                  left outer join movie as m on r.mID = m.mID
          where m.year <= 1980
       group by r.mID
       ) as pre80
       ,
      ( select m.title
	           ,avg(r.stars) as avgstars
          from rating as r
                 left outer join movie as m on r.mID = m.mID
         where m.year > 1980
      group by r.mID
      ) as post80
;
/***Gives a slightly different answer ****/
/*
select avg(case when a.year <= 1980 then a.avgstars else null end)
       ,avg(case when a.year > 1980 then a.avgstars else null end) 
       ,avg(case when a.year <= 1980 then a.avgstars else null end) - avg(case when a.year > 1980 then a.avgstars else null end) as avgratingDiff
  from (  select r.mID
                 ,m.title
                 ,m.year
                 ,avg(r.stars) as avgstars
            from rating as r
                   left outer join movie as m on r.mID = m.mID
        group by r.mID
       ) as a
;
*/
/**************************************************************/
*
/**Movie Ratings Extra Ex1**/
/**Find the names of all reviewers who rated Gone with the Wind**/
select distinct v.name
  from rating as r
         left outer join movie as m on r.mID = m.mID
         left outer join reviewer as v on r.rID = v.rID
 where m.title = 'Gone with the Wind'
;
/**************************************************************/
*
/**Movie Ratings Extra Ex2**/
/**For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.**/
select v.name
       ,m.title
       ,r.stars
  from rating as r
         left outer join movie as m on r.mID = m.mID
         left outer join reviewer as v on r.rID = v.rID
 where v.name = m.director
;
/**************************************************************/
*
/**Movie Ratings Extra Ex3**/
/**Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)**/
select m.title as list
  from movie as m 
union
select v.name as list
  from reviewer as v
;
/**************************************************************/
*
/**Movie Ratings Extra Ex4**/
/**Find the titles of all movies not reviewed by Chris Jackson.**/
select distinct m.title
  from movie as m
 where m.mID not in ( select distinct r.mID
                        from rating as r 
                               left outer join reviewer as v on r.rID = v.rID
                       where v.name = 'Chris Jackson'
                    )
;
/**************************************************************/
*
/**Movie Ratings Extra Ex5**/
/**For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.**/
  select distinct t1.name
         ,t2.name
    from (rating as r1
            left outer join reviewer as v on r1.rID = v.rID) as t1
         ,
	 (rating as r2
            left outer join reviewer as v on r2.rID = v.rID) as t2
   where t1.mID = t2.mID
         and t1.name < t2.name
order by t1.name
         ,t2.name
;
/**************************************************************/
*
/**Movie Ratings Extra Ex6**/
/**For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.**/
select distinct v.name 
       ,m.title
       ,r1.stars
from rating as r1
       left outer join movie as m on r1.mID = m.mID
       left outer join reviewer as v on r1.rID = v.rID
where r1.stars = ( select min(r.stars) as minrating 
                         from rating as r
                 )
;
/**************************************************************/
*
/**Movie Ratings Extra Ex7**/
/**List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.**/
  select m.title
         ,avg(r.stars) as avgrating
    from rating as r
           left outer join movie as m on r.mID = m.mID
group by r.mID
order by 2 desc
         ,m.title
;
/**************************************************************/
*
/**Movie Ratings Extra Ex8**/
/**Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)**/
/*
  select v.name
    from rating as r
           left outer join reviewer as v on r.rID = v.rID
group by r.rID
  having count(r.rID)>=3
;
*/
select v.name
  from reviewer as v
 where (  select count(r.rID)
            from rating as r
           where r.rID = v.rID
        /*group by r.rID*/
       ) >= 3
;
/**************************************************************/
*
/**Movie Ratings Extra Ex9**/
/**Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)**/
  select m1.title
         ,m1.director
    from movie as m1 
   where (  select count(m2.director)
              from movie as m2
             where m2.director = m1.director
          /*group by m.director*/
         ) > 1
order by m1.director
         ,m1.title
;
/**************************************************************/
*
/**Movie Ratings Extra Ex10**/
/**Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)**/
select t.title
       ,max (t.rating)  /*Returns many lines if many movies with the same average rating*/
  from (  select m.title
                 ,avg(r.stars) as rating
            from rating as r
                   left outer join movie as m on r.mID = m.mID
        group by r.mID
       ) as t
;
/**************************************************************/
*
/**Movie Ratings Extra Ex11**/
/**Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)**/
 select t.title
        ,t.rating
   from (  select m.title
                  ,avg(r.stars) as rating
             from rating as r
                    left outer join movie as m on r.mID = m.mID
         group by r.mID
        ) as t
  where t.rating = ( select min(t1.avgrating) 
                       from (select avg(r1.stars) as avgrating
                               from rating as r1
                           group by r1.mID
                            ) as t1
                   )
;
/**************************************************************/
*
/**Movie Ratings Extra Ex12**/
/**For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.**/
  select m.director
         ,m.title
         ,max(r.stars) as rating
    from rating as r
           left outer join movie as m where r.mID = m.mID
group by m.director
  having m.director is not null
;
/*
  SELECT director
         ,title
         ,MAX(stars)
    FROM Movie
         INNER JOIN Rating USING(mId)
   WHERE director IS NOT NULL
GROUP BY director
;
*/
/**************************************************************/
*
/**Movie Ratings Modification Ex1**/
/**Add the reviewer Roger Ebert to your database, with an rID of 209.**/
/*
insert into Reviewer
   select 209
          ,'Roger Ebert'
;
*/
insert into Reviewer
   values( 209,'Roger Ebert')
;
/**************************************************************/
*
/**Movie Ratings Modification Ex2**/
/**For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)**/
update movie
   set year = year + 25
 where mID in  (
                  select r.mID  
                    from rating as r 
                group by r.mID 
                  having avg(r.stars) >= 4
                )
;
/**************************************************************/
*
/**Movie Ratings Modification Ex3**/
/**Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.**/
delete from rating 
      where mID in (
                      select m.mID
                        from movie as m 
                       where (m.year < 1970 or m.year > 2000) 
                   )
            and stars < 4
;
/**************************************************************/        