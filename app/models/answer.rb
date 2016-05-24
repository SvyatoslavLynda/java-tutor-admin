class Answer
  include SanitizableAttributes

  attr_accessor :_id, :body, :correct, :question_id

  def initialize(fields={})
    self._id = fields[:id]
    self.body = fields[:body]
    self.correct = fields[:correct]
    self.question_id = fields[:question_id]
  end

  def self.find(aid)
    res = FBC.client.get("answers/#{aid}")
    new(res.body.with_indifferent_access.merge(id: aid)) if res.success?
  end

  def self.all
    res = FBC.client.get(:answers)
    if res.success? && res.body
      res.body.map { |k, v| new(v.with_indifferent_access.merge(id: k)) }
    end
  end

  def save
    sanitize_attribute :body

    if _id.present?
      FBC.client.update("answers/#{_id}", body: body, correct: correct, question_id: question_id)
    else
      FBC.client.push(:answers, body: body, correct: correct, question_id: question_id).tap do |res|
        self._id = res.body.with_indifferent_access[:name] if res.body.present?
      end
    end.success?
  end

  def destroy
    FBC.client.delete("answers/#{_id}") if _id.present?
  end
end