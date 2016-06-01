class Question < Base
  attr_accessor :_id, :body, :position, :article_id

  def initialize(fields={})
    self._id = fields[:id]
    self.body = fields[:body]
    self.position = fields[:position].to_i
    self.article_id = fields[:article_id]
  end

  def save
    super(
      body: sanitize_attribute(:body),
      position: position.to_i,
      article_id: article_id
    )
  end

  def destroy
    super(answers)
  end

  def answers
    res = FBC.client.get(:answers)

    if res.success? && res.body
      res.body.map do |key, val|
        val = val.with_indifferent_access
        Answer.new(val.merge(id: key)) if val[:question_id] == _id
      end.compact.sort_by { |a| a.position.to_i }
    else
      []
    end
  end
end