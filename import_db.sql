DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body VARCHAR(255),

  author_id INTEGER REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,

  question_id INTEGER REFERENCES questions(id),
  user_id INTEGER REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body VARCHAR(255) NOT NULL,

  parent_id INTEGER REFERENCES replies(id),
  question_id INTEGER REFERENCES questions(id),
  author_id INTEGER REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,

  question_id INTEGER REFERENCES questions(id),
  user_id INTEGER REFERENCES users(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ("Kobe", "Bryant"),
  ("Michael", "Jordan"),
  ("Lebron", "James");

INSERT INTO
  questions(title,  body, author_id)
VALUES
  ("UNIVERSE", "What is the meaning of life?", (SELECT id FROM users WHERE fname = "Lebron")),
  ("Dunking", "How do you dunk?", (SELECT id FROM users WHERE fname = "Lebron")),
  ("Shooting", "How do you shot a ball?", (SELECT id FROM users WHERE fname = "Michael"));

INSERT INTO --replies to the question
  replies(body, question_id,  author_id)
VALUES
  ("you dont know how to dunk??", 2, 1),
  ("learn how to shoot the ball!", 3, 1),
  ("To win RINGS!", 1, 1),
  ("To not lose...", 1, 2);

INSERT INTO --replies to other replies
  replies(body, parent_id, question_id, author_id)
VALUES
  ("Just in games not dunk contests", 1, 2, 3),
  ("We don't teach fools who are scared of dunk contests", 1, 2, 2);

INSERT INTO
  question_follows(question_id, user_id)
VALUES
  (2, 1),
  (2, 2),
  (2, 3),
  (1, 1),
  (1, 2),
  (3, 1);

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (2, 1),
  (2, 2),
  (2, 3),
  (3, 1);
