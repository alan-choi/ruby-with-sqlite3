require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true

    # Typically all the data is returned as strings and not parsed
    # into the appropriate type.
    self.type_translation = true
  end
end
