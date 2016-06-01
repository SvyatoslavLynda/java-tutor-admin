class Article < Base
  include SanitizableAttributes

  attr_accessor :_id, :title, :body, :position

  def initialize(fields={})
    self._id = fields[:id]
    self.title = fields[:title]
    self.body = fields[:body]
    self.position = fields[:position].to_i
  end

  def save
    super(
      title: title,
      body: sanitize_attribute(:body),
      position: position.to_i,
    )
  end

  def destroy
    super(questions)
  end

  def questions
    res = FBC.client.get(:questions)

    if res.success? && res.body
      res.body.map do |key, val|
        val = val.with_indifferent_access
        Question.new(val.merge(id: key)) if val[:article_id] == _id
      end.compact.sort_by { |q| q.position.to_i }
    else
      []
    end
  end
end