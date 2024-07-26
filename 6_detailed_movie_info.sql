SELECT 
    m.id AS "id",
    m.title AS "title",
    m.release_date AS "release_date",
    m.duration AS "duration",
    m.description AS "description",
    jsonb_build_object(
        'id', f.id,
        'file_name', f.file_name,
        'mime_type', f.mime_type,
        'key', f.key,
        'url', f.url
    ) AS "poster",
    jsonb_build_object(
        'id', d.id,
        'first_name', d.first_name,
        'last_name', d.last_name,
        'photo', jsonb_build_object(
            'id', df.id,
            'file_name', df.file_name,
            'mime_type', df.mime_type,
            'key', df.key,
            'url', df.url
        )
    ) AS "director",
    (
        SELECT jsonb_agg(
            jsonb_build_object(
                'id', a.id,
                'first_name', a.first_name,
                'last_name', a.last_name,
                'photo', jsonb_build_object(
                    'id', af.id,
                    'file_name', af.file_name,
                    'mime_type', af.mime_type,
                    'key', af.key,
                    'url', af.url
                )
            )
        )
        FROM movie_casts mc
        JOIN persons a ON mc.person_id = a.id
        LEFT JOIN files af ON a.primary_photo_id = af.id
        WHERE mc.movie_id = m.id
    ) AS "actors",
    (
        SELECT jsonb_agg(
            jsonb_build_object(
                'id', g.id,
                'name', g.name
            )
        )
        FROM movie_genres mg
        JOIN genres g ON mg.genre_id = g.id
        WHERE mg.movie_id = m.id
    ) AS "genres"
FROM movies m
LEFT JOIN files f ON m.poster_id = f.id
LEFT JOIN persons d ON m.director_id = d.id
LEFT JOIN files df ON d.primary_photo_id = df.id
WHERE m.id = 1;
