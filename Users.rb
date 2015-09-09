require_relative 'QuestionsDatabase'
require_relative 'Question'
require_relative 'Reply'
require_relative 'QuestionFollow'
require_relative 'QuestionLike'


class User
  attr_accessor :fname, :lname, :id

  def initialize(options = {})
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  #NEED TO FIX THIS!
  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        COUNT(questions.id), --COUNT(questions_likes.id)
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        questions.user_id = ?
    SQL
    data
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?;
    SQL
    return nil if data.empty?
    User.new(data.first)
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    return nil if data.empty?
    User.new(data.first)
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_author_id(id)
  end

end
