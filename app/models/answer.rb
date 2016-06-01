class Answer < Base
  include SanitizableAttributes

  attr_accessor :_id, :body, :position, :correct, :question_id

  def initialize(fields={})
    self._id = fields[:id]
    self.body = fields[:body]
    self.correct = fields[:correct]
    self.position = fields[:position].to_i
    self.question_id = fields[:question_id]
  end

  def save
    super(
      body: sanitize_attribute(:body),
      correct: correct,
      position: position.to_i,
      question_id: question_id
    )
  end

  def destroy
    super([])
  end
end