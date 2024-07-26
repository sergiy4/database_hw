SELECT 
    u.id AS "id",
    u.username AS "username",
    COALESCE(array_agg(fm.movie_id) FILTER (WHERE fm.movie_id IS NOT NULL), '{}') AS "favorite_movie_ids"
FROM 
    users u
LEFT JOIN 
    favorite_movies fm ON u.id = fm.user_id
GROUP BY 
    u.id, u.username
ORDER BY 
    u.id;
