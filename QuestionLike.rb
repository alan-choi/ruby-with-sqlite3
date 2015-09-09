require_relative 'QuestionsDatabase'
require_relative 'Users'
require_relative 'QuestionFollow'
require_relative 'Question'
require_relative 'Reply'

class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end

  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        * --,  COUNT(question_likes.id)
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      GROUP BY
        question_likes.question_id
      ORDER BY
        COUNT(question_likes.id) DESC
      LIMIT
       ?
    SQL
    data.map { |question| Question.new(question) }
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes ON questions.author_id = question_likes.user_id
      WHERE
        questions.author_id = ? AND questions.id IN (
          SELECT
            question_likes.question_id
          FROM
            question_likes
        )
    SQL
    data.map {|question| Question.new(question)}
  end

  def self.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_likes ON user.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL
    data.map{ |user| User.new(user) }
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(id)
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    data.first.values
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      id = ?
    SQL

    return nil if data.empty?
    QuestionLike.new(data.first)
  end
end
