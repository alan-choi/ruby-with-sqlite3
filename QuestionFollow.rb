require_relative 'QuestionsDatabase'
require_relative 'Users'
require_relative 'Reply'
require_relative 'Question'
require_relative 'QuestionLike'

class QuestionFollow
  attr_accessor :question_id, :user_id, :id

  def initialize(options)
    @question_id = options["question_id"]
    @user_id = options["user_id"]
    @id = options["id"]
  end

  def self.most_followed_questions(n) #returns an array of the "n" most followed questions
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      GROUP BY
        question_id
      ORDER BY
        COUNT(question_follows.id) DESC
      LIMIT
        ?
    SQL
    data.map {|question| Question.new(question)}
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL
    data.map { |follower|User.new(follower) }
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      WHERE
        user_id = ?
    SQL
    data.map {|item| Question.new(item)}
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_follows
    WHERE
      id = ?
    SQL
    return nil if data.empty?
    QuestionFollow.new(data.first)
  end
end
