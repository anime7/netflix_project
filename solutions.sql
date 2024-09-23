-- NETFLIX PROJECT
drop table if exists netflix;
create table netflix
( show_id varchar(6),
  type	varchar(10),
  title	 varchar(150),
  director	varchar(208),
  casts	varchar(1000),
  country	varchar(150),
  date_added	varchar(50),
  release_year	int,
  rating	varchar(10),
  duration	varchar(15),
  listed_in	 varchar(150),
  description varchar(250)
);

select * from netflix;


select count(*) as totalcol 
from netflix;

select distinct type
 from netflix;


 --15 problems ---
 
--1. Count the number of Movies vs TV Shows
select type,count(*) as total_content
from netflix
group by type;








--2. Find the most common rating for movies and TV shows
select
     type,
	 rating
	 from
	 (
 select type,
        rating,
        count(*) as total_count,
        rank() over(partition by type order by count(*) desc ) as ranking
 from netflix
 group by 1,2) 
 as t1
 where ranking=1
 --order by 4 desc;



3. List all movies released in a specific year (e.g., 2020)
 select title,release_year
 from netflix
 where (release_year=2020 and type='Movie');



 
4. Find the top 5 countries with the most content on Netflix

select unnest( string_to_array(country,',')) as ct,
count(show_id) 
from netflix group by ct order by 2 Desc limit 5 ;




5. Identify the longest movie

  select title, duration
  from netflix
  where type='Movie' and duration =(select max(duration) from netflix);




6. Find content added in the last 5 years
select *
from netflix
where to_date(date_added,'month dd yyyy')>=(current_date-interval '5 years')
order by date_added asc;



7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
   select * 
   from netflix 
   where director like '%Rajiv Chilaka%';



8. List all TV shows with more than 5 seasons



select * 
from netflix 
where type='TV Show' and split_part(duration,' ',1 ):: numeric > 5 ;




9. Count the number of content items in each genre


select unnest(string_to_array(listed_In,','))as genre,count(show_id)as n_content
from netflix
group by 1;






10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

select 
          extract (year from(to_date(date_added,'month dd,yyyy'))) as year,
          count(show_id),
		 round( count(show_id)::numeric/(select count(*) from netflix where country='India')*100 :: numeric,2) as avg_peryear
from netflix  
where country='India'
group by 1







11. List all movies that are documentaries
  
select * 
from netflix 
where listed_In ilike '%Documentaries%'

12. Find all content without a director

select * from netflix 
where director is null




13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix 
where casts ilike '%Salman Khan%'
and release_year>extract(year from current_date)-10



14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select
unnest(string_to_array(casts,',')),
count(*)
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10;


15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

with newtab as (
select *,
 case
  when (description ilike '%kill%' 
   or
  description ilike '%violence%') then 'Bad Content'
  else 'Good Content'
 end as content_type
 from netflix
 )
 select count(*) as content_count,content_type
 from newtab
 group by 2
  