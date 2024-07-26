-- Drop tables if they exist
DROP TABLE IF EXISTS "favorite_movies";
DROP TABLE IF EXISTS "movie_casts";
DROP TABLE IF EXISTS "movie_genres";
DROP TABLE IF EXISTS "genres";
DROP TABLE IF EXISTS "person_photos";
DROP TABLE IF EXISTS "character_actors" ;
DROP TABLE IF EXISTS "character_movies";
DROP TABLE IF EXISTS "users";
DROP TABLE IF EXISTS "movies";
DROP TABLE IF EXISTS "characters";
DROP TABLE IF EXISTS "persons";
DROP TABLE IF EXISTS "countries";
DROP TABLE IF EXISTS "files" ;
DROP TYPE IF EXISTS role_type;
DROP TYPE IF EXISTS gender_type;

CREATE TYPE role_type AS ENUM ('leading', 'supporting', 'background');
CREATE TYPE gender_type AS ENUM ('male', 'female');

CREATE TABLE countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "files" (
    id SERIAL PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL UNIQUE,
    mime_type VARCHAR(50) NOT NULL,
    "key" VARCHAR(255) NOT NULL,
    url VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE "users" (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    "password" VARCHAR(255) NOT NULL,
    avatar_id INT UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (avatar_id) REFERENCES "files"(id)
);

CREATE TABLE "persons" (
	id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    biography TEXT,
    date_of_birth DATE,
    gender gender_type,
    country_id INT,
    primary_photo_id INT UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES countries(id),
    FOREIGN KEY (primary_photo_id) REFERENCES "files"(id)
);

CREATE TABLE "person_photos" (
    id SERIAL PRIMARY KEY,
    photo_id INT NOT NULL,
    person_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (photo_id) REFERENCES "files"(id),
    FOREIGN KEY (person_id) REFERENCES persons(id),
	UNIQUE (photo_id, person_id)
);

CREATE TABLE "movies" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    budget FLOAT,
    release_date DATE,
    duration INT,
    director_id INT,
    country_id INT,
    poster_id INT UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (director_id) REFERENCES persons(id),
    FOREIGN KEY (country_id) REFERENCES countries(id),
    FOREIGN KEY (poster_id) REFERENCES "files"(id)
	
);

CREATE TABLE "genres" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "movie_genres" (
	id SERIAL PRIMARY KEY,
    movie_id INT NOT NULL,
    genre_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (genre_id) REFERENCES genres(id),
	UNIQUE (movie_id, genre_id)
);

CREATE TABLE "characters" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    "role" role_type  NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	UNIQUE (name, description, role)
);

CREATE TABLE character_movies (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL,
    movie_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (character_id) REFERENCES characters(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    UNIQUE (character_id, movie_id) 
);


CREATE TABLE character_actors (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL,
    person_id INT ,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (character_id) REFERENCES "characters"(id),
    FOREIGN KEY (person_id) REFERENCES "persons"(id),
	UNIQUE (character_id, person_id)
);

CREATE TABLE movie_casts (
    id SERIAL PRIMARY KEY,
    movie_id INT NOT NULL,
    person_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (person_id) REFERENCES persons(id),
	UNIQUE (movie_id, person_id)
);

CREATE TABLE favorite_movies (
    id SERIAL PRIMARY KEY,
    movie_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (user_id) REFERENCES "users"(id),
	UNIQUE (movie_id, user_id)
);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add triggers for each table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON countries
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON "files"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON "users"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON persons
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON person_photos
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON movies
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON genres
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON movie_genres
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON characters
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON movie_casts
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON favorite_movies
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON character_actors
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON character_movies
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();


-- INSERT DATA
INSERT INTO countries (name) VALUES
('USA'), ('UK'), ('Canada'), ('Australia'), ('Germany');

INSERT INTO "files" (file_name, mime_type, "key", url) VALUES
('avatar1.png', 'image/png', 'avatars/avatar1.png', 'http://example.com/avatars/avatar1.png'),
('avatar2.png', 'image/png', 'avatars/avatar2.png', 'http://example.com/avatars/avatar2.png'),
('avatar3.png', 'image/png', 'avatars/avatar3.png', 'http://example.com/avatars/avatar3.png'),
('avatar4.png', 'image/png', 'avatars/avatar4.png', 'http://example.com/avatars/avatar4.png'),
('avatar5.png', 'image/png', 'avatars/avatar5.png', 'http://example.com/avatars/avatar5.png'),
('poster1.jpg', 'image/jpeg', 'posters/poster1.jpg', 'http://example.com/posters/poster1.jpg'),
('poster2.jpg', 'image/jpeg', 'posters/poster2.jpg', 'http://example.com/posters/poster2.jpg'),
('poster3.jpg', 'image/jpeg', 'posters/poster3.jpg', 'http://example.com/posters/poster3.jpg'),
('poster4.jpg', 'image/jpeg', 'posters/poster4.jpg', 'http://example.com/posters/poster4.jpg'),
('poster5.jpg', 'image/jpeg', 'posters/poster5.jpg', 'http://example.com/posters/poster5.jpg');

INSERT INTO "users" (username, first_name, last_name, email, "password", avatar_id) VALUES
('user1', 'John', 'Doe', 'john.doe@example.com', 'password123', 1),
('user2', 'Jane', 'Doe', 'jane.doe@example.com', 'password123', 2),
('user3', 'Alice', 'Smith', 'alice.smith@example.com', 'password123', 3),
('user4', 'Bob', 'Brown', 'bob.brown@example.com', 'password123', 4),
('user5', 'Charlie', 'Black', 'charlie.black@example.com', 'password123', 5);

INSERT INTO "persons" (first_name, last_name, biography, date_of_birth, gender, country_id, primary_photo_id) VALUES
('Quentin', 'Tarantino', 'Director known for non-linear stories', '1963-03-27', 'male', 1, 6),
('Leonardo', 'DiCaprio', 'Award-winning actor', '1974-11-11', 'male', 1, 7),
('Kate', 'Winslet', 'Award-winning actress', '1975-10-05', 'female', 2, NULL),
('Brad', 'Pitt', 'Award-winning actor', '1963-12-18', 'male', 1, 9),
('Natalie', 'Portman', 'Award-winning actress', '1981-06-09', 'female', 3, NULL),
('Christopher', 'Nolan', 'Director known for complex narratives', '1970-07-30', 'male', 1, 10),
('Emma', 'Thompson', 'Award-winning actress and screenwriter', '1959-04-15', 'female', 2, NULL),
('Tom', 'Hardy', 'Award-winning actor known for versatile roles', '1977-09-15', 'male', 1, 8);

INSERT INTO "movies" (title, description, budget, release_date, duration, director_id, country_id, poster_id) VALUES
('Inception', 'A thief who steals corporate secrets through the use of dream-sharing technology.', 160000000, '2023-07-16', 148, 6, 1, 1),
('Titanic', 'A seventeen-year-old aristocrat falls in love with a kind but poor artist.', 200000000, '1997-12-19', 195, 1, 1, 2),
('Pulp Fiction', 'The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in four tales of violence and redemption.', 8000000, '1994-10-14', 154, 1, 1, 3),
('Fight Club', 'An insomniac office worker and a devil-may-care soapmaker form an underground fight club.', 63000000, '1999-10-15', 139, 1, 1, 4),
('Black Swan', 'A committed dancer wins the lead role in a production of Tchaikovsky "Swan Lake".', 13000000, '2024-12-17', 150, 5, 1, 5);

INSERT INTO "genres" (name) VALUES
('Action'), ('Drama'), ('Thriller'), ('Romance'), ('Sci-Fi');

INSERT INTO "movie_genres" (movie_id, genre_id) VALUES
(1, 1),(1, 2), (1, 5), (2, 2), (2, 4), (3, 1), (3, 2), (4, 1), (4, 2), (5, 2),(5, 1), (5, 3);

INSERT INTO "characters" (name, description, "role") VALUES
('Dom Cobb', 'A skilled thief and the protagonist of Inception.', 'leading'),
('Jack Dawson', 'A kind but poor artist in Titanic.', 'leading'),
('Mia Wallace', 'The wife of a gangster in Pulp Fiction.', 'leading'),
('Tyler Durden', 'A soapmaker and the protagonist of Fight Club.', 'leading'),
('Nina Sayers', 'A committed dancer in Black Swan.', 'leading'),
('Mal Cobb', 'Dom Cobb wife in Inception.', 'supporting'),
('Cal Hockley', 'A wealthy and arrogant fiancé in Titanic.', 'supporting'),
('Marcellus Wallace', 'A gangster in Pulp Fiction.', 'supporting'),
('Robert Fischer', 'A business tycoon in Inception.', 'supporting'),
('Thomas Anderson', 'A computer programmer in The Matrix.', 'leading');

INSERT INTO character_movies (character_id, movie_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 1), (7, 2), (8, 3), (9, 1), (10, 1);

INSERT INTO character_actors (character_id, person_id) VALUES
(1, 2), (2, NULL), (3, 3), (4, 4), (5, NULL), (5, 2), (6, 3), (7, 3), (8, 4), (9, 7), (10, 8);

INSERT INTO movie_casts (movie_id, person_id) VALUES
(1, 2), (1, 7), (1, 8), (2, 2), (2, 3), (3, 3), (3, 4), (4, 4), (5, 5), (5, 7);

INSERT INTO favorite_movies (movie_id, user_id) VALUES
(1, 1), (2, 1),(2, 3),(2, 2), (3, 3), (4, 4), (4, 5),(4, 3),(5, 5);
