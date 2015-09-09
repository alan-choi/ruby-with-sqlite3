require_relative 'QuestionsDatabase'
require_relative 'Users'
require_relative 'QuestionFollow'
require_relative 'Question'
require_relative 'QuestionLike'

class Reply
  attr_accessor :id, :parent_id, :body, :question_id, :author_id

  def initialize(options)
    @id = options["id"]
    @parent_id = options["parent_id"]
    @body = options["body"]
    @question_id = options["question_id"]
    @author_id = options["author_id"]
  end

  def child_replies
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies AS child
      WHERE
        child.parent_id = ?
    SQL

    return nil if data.empty?
    Reply.new(data.first)
  end

  def parent_reply
    raise "this response is the parent" if parent_id.nil?
    self.class.find_by_id(parent_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      replies
    WHERE
      author_id = ?;
    SQL

    data.map { |comment| Reply.new(comment) }
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
    data.map { |comment| Reply.new(comment) }
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
    SQL

    return nil if data.empty?
    Reply.new(data.first)
  end
end
