/**************************************************************/
*
/**Social Network Ex1**/
/**Find the names of all students who are friends with someone named Gabriel.**/
select h.name
  from highschooler as h
 where h.id in ( select f.id2
                   from friend as f
                          left outer join highschooler as h1 on h1.id = f.id1
                  where h1.name = 'Gabriel'
               )
;
/**************************************************************/
*
/**Social Network Ex2**/
/**For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.**/
select h1.name
       ,h1.grade
       ,h2.name
       ,h2.grade
  from likes as l
         left outer join highschooler as h1 on h1.id = l.id1
         left outer join highschooler as h2 on h2.id = l.id2
 where h1.grade - h2.grade >=2
;
/**************************************************************/
*
/**Social Network Ex3**/
/**For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.**/
select h1.name
       ,h1.grade
       ,h2.name
       ,h2.grade
  from likes as l1
       inner join likes as l2 on l1.id2 = l2.id1
         left outer join highschooler as h1 on h1.id = l1.id1
         left outer join highschooler as h2 on h2.id = l2.id1
 where l1.id1 =l2.id2
       and h1.name < h2.name
;
/**************************************************************/
*
/**Social Network Ex4**/
/**Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.**/
  select h.name
         ,h.grade
    from highschooler as h
   where h.id not in ( select distinct t.id
                       from ( select id1 as id
                                from likes 
                               union
                              select id2 as id
                                from likes 
                            ) as t
                     )
order by h.grade
         ,h.name
;
/**************************************************************/
*
/**Social Network Ex5**/
/**For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.**/
select h1.name
       ,h1.grade
       ,h2.name
       ,h2.grade
  from likes as l
         left outer join highschooler as h1 on h1.id = l.id1
         left outer join highschooler as h2 on h2.id = l.id2
 where l.id2 not in ( select distinct l2.id1
                        from likes as l2
                    )
;
/**************************************************************/
*
/**Social Network Ex6**/
/**Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.**/
  select h.name
         ,h.grade
    from highschooler as h
   where h.id not in ( select distinct f.id1 /*Those who have atleast one friend in a different grade*/
                         from friend as f
                                left outer join highschooler as h1 on h1.id = f.id1
                                left outer join highschooler as h2 on h2.id = f.id2
                        where h1.grade <> h2.grade
                     )
order by h.grade
         ,h.name
;
/**************************************************************/
*
/**Social Network Ex7**/
/**For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.**/
select h1.name
       ,h1.grade
       ,h2.name
       ,h2.grade
       ,h3.name
       ,h3.grade
  from likes as l
         left outer join highschooler as h1 on h1.id = l.id1 /*Name of Liker*/
         left outer join highschooler as h2 on h2.id = l.id2 /*Name of Liked*/
         left outer join friend as f1 on f1.id1 = l.id1      /*Provides the Intermediary*/
           left outer join highschooler as h3 on h3.id = f1.id2 /*Name of Intermediary*/
           left outer join friend as f2 on f2.id1 = f1.id2      /*Friends of Intermediary*/
 where not exists ( select *
                       from friend as f
                      where f.id1 = l.id1 and f.id2=l.id2
                   )
       and l.id2 = f2.id2
;
/**************************************************************/
*
/**Social Network Ex8**/
/** Find the difference between the number of students in the school and the number of different first names.**/
select count (h.id) - count (distinct h.name)
  from highschooler as h
;
/**************************************************************/
*
/**Social Network Ex9**/
/**Find the name and grade of all students who are liked by more than one other student.**/
  select h.name
         ,h.grade
    from highschooler as h
           left outer join likes as l on l.id2 = h.id
group by h.id
  having count(l.id1) > 1
order by h.name asc /*Not necessary*/
;
/**************************************************************/
*
/**Social Network Extras Ex1**/
/**For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. **/
select h1.name
       ,h1.grade
       ,h2.name
       ,h2.grade
       ,h3.name
       ,h3.grade
  from likes as l1
         left outer join highschooler as h1 on h1.id = l1.id1
         left outer join highschooler as h2 on h2.id = l1.id2       
         left outer join likes as l2 on l2.id1= l1.id2
           left outer join highschooler as h3 on h3.id = l2.id2
 where l1.id1 <> l2.id2
 ;
/**************************************************************/
*
/**Social Network Extras Ex2**/
/**Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.**/
select h1.name
       ,h1.grade
  from highschooler as h1
 where h1.id not in ( 
                      select distinct f.id1 /*Alteast one friend in same grade*/
                        from friend as f
                               left outer join highschooler as h2 on h2.id = f.id1
                               left outer join highschooler as h3 on h3.id = f.id2
                       where h2.grade = h3.grade
                    )
;
/**************************************************************/
*
/**Social Network Extras Ex3**/
/**What is the average number of friends per student? (Your result should be just one number.)**/
select avg(t.numfriends)
  from (  select  h.name
                  ,count(f.id2) as numfriends
            from  highschooler as h
                    left outer join friend as f on f.id1 = h.id
        group by  h.id
       ) as t
;
/**************************************************************/
*
/**Social Network Extras Ex4**/
/**Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.**/
select ( select count(f1.id2) as friends
           from friend as f1
                  left outer join highschooler as h1 on h1.id = f1.id1
          where h1.name = 'Cassandra'
       ) + ( select count(f1.id2) as frndsoffrnds
               from friend as f1
                      left outer join highschooler as h1 on h1.id = f1.id1
                      left outer join friend as f2 on f2.id1 = f1.id2
                        left outer join highschooler as h2 on h2.id = f2.id2
              where h1.name = 'Cassandra' and h2.name <> 'Cassandra'
           )
;
/**************************************************************/
*
/**Social Network Extras Ex5**/
/**Find the name and grade of the student(s) with the greatest number of friends. **/
  select h1.name
         ,h1.grade         /*Does not change within the same name*/
    from highschooler as h1
           left outer join friend as f1 on h1.id =f1.id1
group by h1.id
  having count(f1.id2) = (                                 /*This parenthesis is necessary*/
	                     select max(ct.numoffriends)
                               from ( select f2.id1
                                             ,count(*) as numoffriends
                                        from friend as f2
                                    group by f2.id1
                                    ) as ct
                         )
;
/**************************************************************/
*
/**Social Network Modification Ex1**/
/**It's time for the seniors to graduate. Remove all 12th graders from Highschooler. **/
delete from highschooler
      where grade = 12
;
/**************************************************************/
*
/**Social Network Modification Ex2**/
/**If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.**/
delete from likes
 where id2 in ( select f1.id2
                  from friend as f1
                 where f1.id1 = likes.id1 
              )
       and id2 not in ( select l2.id1
                          from likes as l2
                         where l2.id2 = likes.id1
		      )/*Liked person from l2 likes the other reciprocally*/
/**************************************************************/
*
/**Social Network Modification Ex3**/
/**For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) **/
insert into friend
     select distinct f1.id1
            ,f2.id2
       from friend as f1
              left outer join friend as f2 on f2.id1= f1.id2
      where f1.id1 <> f2.id2 /*Removes friendships with self*/
            and f1.id1 not in ( select f3.id1   
							      from friend as f3
                                 where f3.id2 = f2.id2 /*C*/
                              ) /*Checks against preexisting*/
;
/**************************************************************/



