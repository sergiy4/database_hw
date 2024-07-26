SELECT 
    p.id AS "id",
    p.first_name AS "first_name",
    p.last_name AS "last_name",
    COALESCE(SUM(m.budget), 0) AS "total_movies_budget"
FROM 
    (
        SELECT 
            DISTINCT mc.person_id,
            mc.movie_id
        FROM 
            movie_casts mc
        UNION
        SELECT 
            DISTINCT ca.person_id,
            cm.movie_id
        FROM 
            character_actors ca
        JOIN 
            character_movies cm ON ca.character_id = cm.character_id
    ) AS combined_cast
JOIN 
    persons p ON combined_cast.person_id = p.id
JOIN 
    movies m ON combined_cast.movie_id = m.id
GROUP BY 
    p.id, p.first_name, p.last_name
ORDER BY 
    "total_movies_budget" DESC;