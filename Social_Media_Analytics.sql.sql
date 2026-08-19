-- ==============================================================
-- SQL + GenAI Mini Project : Social Media Analytics
-- Dataset : Social_Media
-- Student Name : _________ SANKATI AKHIL REDDY _____________
-- ==============================================================

-- 🚀 SETUP INSTRUCTIONS (MUST DO FIRST)
-- ==============================================================
-- Before solving this project, make sure you create and load the dataset.
--
-- STEP 1: Open your SQL client (MySQL Workbench, DBeaver, or SQLite Studio).
-- STEP 2: Run the provided dataset file:
--         social_media_analytics_dataset.sql
--
-- This script will:
--   ✅ Create a new database named `Social_Media`
--   ✅ Create all 7 tables (users, posts, comments, likes, followers, hashtags, post_hashtags)
--   ✅ Insert ~7,000 synthetic rows for analysis
--
-- STEP 3: After successful execution, Your Code the database:
--         USE Social_Media;
--
-- STEP 4: Verify the tables:
        SHOW TABLES;
select count(*) FROM users;
select COUNT(*) FROM posts;
--
-- Once you confirm the data is loaded, you can proceed to attempt all project queries.
-- ==============================================================

USE  mini_project;

-- ==============================================================
-- IMPORTANT: BEFORE USING GenAI FOR QUERY GENERATION
-- ==============================================================
-- To help the AI generate accurate SQL, you MUST first share your schema.
-- Paste the following context into ChatGPT (or any GenAI tool) BEFORE you ask your prompts:

/*
You are an expert SQL assistant.  
Before answering any question, refer strictly to the database schema provided below.  
All SQL queries, joins, and analyses must be based ONLY on this schema — table names, column names, and relationships mentioned here.  
Do not assume any extra tables or columns unless explicitly stated.  
If a question is ambiguous, clarify it using the schema context rather than inventing new fields.  
Once you understand the schema, wait for my analytical question and generate the most accurate SQL query for it.

Tables and Key Columns:
  1. users(user_id, username, join_date, country)
  2. posts(post_id, user_id, content, created_at)
  3. comments(comment_id, post_id, user_id, comment_text, created_at)
  4. likes(like_id, post_id, user_id, created_at)
  5. followers(follower_id, user_id, follower_user_id, follow_date)
  6. hashtags(hashtag_id, tag_name, category)
  7. post_hashtags(id, post_id, hashtag_id)

Relationships:
  • Each user can create multiple posts.
  • Each post can have multiple likes and comments.
  • Users can follow each other (self-join in followers table).
  • Posts can be tagged with multiple hashtags (many-to-many via post_hashtags).
*/

-- Once you paste the schema, THEN use prompts like:
--   "Generate SQL to find top 10 active users combining posts and comments."
--   "Find trending hashtags used in more than 20 posts."
-- ==============================================================




-- ==============================================================
-- Q1. Most Active Users (Posts + Comments)
-- ==============================================================
-- Objective : Find top 10 users based on combined number of posts and comments.
-- Example GenAI Prompt :
--   "Write SQL to find top 10 active users combining posts and comments count."
-- Write your query below 👇
-- --------------------------------------------------------------
-- Your Code ...
 

select u.user_id,u.username,
 COUNT(DISTINCT p.post_id) AS post_count,
    COUNT(DISTINCT c.comment_id) AS comment_count,
    COUNT(DISTINCT p.post_id) + COUNT(DISTINCT c.comment_id) AS total_activity
  from users as u
left join posts as p
on u.user_id=p.user_id
left join comments as c
on u.user_id=c.user_id
group by u.user_id,u.username
order by    total_activity   desc
limit 10;



-- Solution Summary -- 
 # Combined the total number of posts and comments for each user using JOINs and aggregate functions. Ranked users based on
 #  their overall activity and displayed the top 10 most active users.

-- ==============================================================
-- Q2. Most Liked Posts and Creators
-- ==============================================================
-- Objective : Identify posts with maximum likes along with their creator.
-- Example GenAI Prompt :
--   "Show top 10 posts with most likes and username."
-- --------------------------------------------------------------
-- Your Code ...
 

select p.post_id,u.username,count(l.like_id) as total_likes from posts as p
inner join users as u
on p.user_id=u.user_id
inner join likes as l
on p.post_id=l.post_id
group by p.post_id,u.username
order by total_likes desc
limit 10;




-- Solution Summary -- 
# Joined the Posts, Users, and Likes tables to count likes received by each post. 
# Identified the top 10 most liked posts along with their respective creators.

-- ==============================================================
-- Q3. Top Countries by Average Engagement
-- ==============================================================
-- Objective : Find countries with the highest average likes per post.
-- Example GenAI Prompt :
--   "Which countries have highest average likes per post?"
-- --------------------------------------------------------------
-- Your Code ...
 

select u.country, 
COUNT(l.like_id) * 1.0 / COUNT(DISTINCT p.post_id) AS avg_likes_per_post  
 from users as u
 join posts as p
using(user_id)
left join likes as l
on l.post_id=p.post_id
group by u.country
order by  avg_likes_per_post  desc
limit 1;

-- Solution Summary -- 
# Calculated the average likes received per post for each country by joining Users, Posts, and Likes.
# Ranked countries based on average engagement.

-- ==============================================================
-- Q4. Trending Hashtags (Used in >20 Posts)
-- ==============================================================
-- Objective : Find hashtags that appear in more than 20 posts.
-- Example GenAI Prompt :
--   "Find hashtags used in more than 20 posts."
-- --------------------------------------------------------------
-- Your Code ...
select* from hashtags;
select*from post_hashtags;

select h.tag_name,count(*) as post_count
 from post_hashtags as p
join hashtags as h
on h.hashtag_id=p.hashtag_id
group by   h.tag_name
having count(*)>20;




-- Solution Summary -- 
# Counted the number of posts associated with each hashtag using the Post_Hashtags table. Displayed hashtags that were used in more than 20 posts.

-- ==============================================================
-- Q5. Top Influencers (Users with Most Followers)
-- ==============================================================
-- Objective : List users with the highest follower count.
-- Example GenAI Prompt :
--   "Find users with maximum followers."
-- --------------------------------------------------------------
-- Your Code ...
 

select u.username,u.user_id,count(f.follower_user_id) as maXimum  from users as u
inner join followers as f
on f.user_id=u.user_id
group by u.username,u.user_id
order by maXimum desc
limit 1;

-- Solution Summary -- 
# Calculated the follower count for each user using the Followers table. Ranked users to identify those with the highest number of followers.

-- ==============================================================
-- Q6. Followers Who Never Interacted
-- ==============================================================
-- Objective : Identify users who follow others but have never liked or commented.
-- Example GenAI Prompt :
--   "Show users who follow others but never interacted."
-- --------------------------------------------------------------
-- Your Code ...

select*from users;
select*from followers;
select*from likes;
select* from comments;

select u.user_id,u.username from users as u
inner join followers as f
on u.user_id=f.follower_user_id
left join likes as l
on u.user_id=l.user_id
left join comments as c
on u.user_id=c.user_id
where l.user_id is null and c.user_id is null;
 




-- Solution Summary -- 
# Identified users who follow others but have never liked or commented on any post by combining Followers, Likes, and Comments tables.

-- ==============================================================
-- Q7. Hashtags with Highest Engagement
-- ==============================================================
-- Objective : Calculate total engagement (likes + comments) for each hashtag.
-- Example GenAI Prompt :
--   "Calculate engagement score per hashtag."
-- --------------------------------------------------------------
-- Your Code ...
 

select h.tag_name,count(distinct l.like_id)+count(distinct c.comment_id) as total_count from hashtags as h
inner join post_hashtags as ph
on ph.hashtag_id=h.hashtag_id
left join likes as l
on ph.post_id=l.post_id
left join comments as c
on ph.post_id=c.post_id
group by h.tag_name
order by total_count desc;




-- Solution Summary -- 
# Computed total engagement for each hashtag by combining likes and comments received by posts containing that hashtag. Ranked hashtags based on engagement score.

-- ==============================================================
-- Q8. Busiest Posting Hours or Days
-- ==============================================================
-- Objective : Find which hour/day sees most posting activity.
-- Example GenAI Prompt :
--   "Write SQL to show which hour or weekday sees most posts."
-- --------------------------------------------------------------
-- Your Code ...

 
select*from posts;

select dayname(created_at) AS weekday,
 
count(*) as total_posts from posts 
group by hour(created_at),dayname(created_at)
order by total_posts desc
limit 1;



-- Solution Summary -- 
# Analyzed post creation timestamps to determine the day and hour with the highest posting activity, helping identify peak user engagement periods.

-- ==============================================================
-- Q9. Inactive Users
-- ==============================================================
-- Objective : Find users who have never posted, liked, or commented.
-- Example GenAI Prompt :
--   "Find users who have never posted, liked, or commented."
-- --------------------------------------------------------------
-- Your Code ...
select * from users;
select * from posts;
select * from likes;
select * from comments;

select u.user_id,u.username from users as u
left join posts as p
on u.user_id=p.user_id
left join likes as l
on u.user_id=l.user_id
left join comments as c
on u.user_id=c.user_id
where p.user_id is null and l.user_id is null and c.user_id is null
group by u.user_id,u.username
order by u.user_id asc;



-- Solution Summary -- 
# Retrieved users who have never created posts, liked posts, or written comments by checking for missing activity across multiple tables.

-- ==============================================================
-- Q10. Top Countries with Most Influencers
-- ==============================================================
-- Objective : Identify countries with the highest number of influencers.
-- Example GenAI Prompt :
--   "Generate SQL to find countries that have the most followed users."
-- --------------------------------------------------------------
-- Your Code ...

select * from users;
select * from followers;


select u.country,count(distinct u.user_id) as max_follower from users as u
join followers as f
on u.user_id=f.user_id
group by u.country
order by  max_follower desc



-- Solution Summary -- 
# Counted influential users across different countries based on follower relationships. Ranked countries according to the number of highly followed users.

-- ==============================================================
-- BONUS CHALLENGES
-- ==============================================================
-- 1. Engagement rate = (likes + comments) / posts
-- 2. Mutual followers
-- 3. Most used hashtags by top 5 influencers
-- 4. Country-wise engagement leaderboard
-- --------------------------------------------------------------

-- ==============================================================
-- REFLECTION
-- ==============================================================
-- 1. How did GenAI assist you in solving these queries?
-- 2. What optimization tips did you learn?
-- 3. What business insights stood out to you?
-- ==============================================================
