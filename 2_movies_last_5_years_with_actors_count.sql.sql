SELECT 
	m.id AS "id",
	m.title AS "title",
	COUNT(DISTINCT unique_actors.person_id) AS "actors_count"
FROM 
	movies m 
JOIN (
	SELECT 
		mc.movie_id, 
        mc.person_id
	FROM 
		movie_casts mc
	UNION 
	SELECT
		cm.movie_id,
		ca.person_id
	FROM 
		character_movies cm
	JOIN 
		character_actors ca ON cm.character_id = ca.character_id
) unique_actors ON m.id = unique_actors.movie_id
WHERE 
    m.release_date >= CURRENT_DATE - INTERVAL '5 years'
GROUP BY 
    m.id, m.title
ORDER BY 
    "actors_count" DESC;