class Answer
  attr_accessor :answer_id, :body, :correct, :question_id

  def initialize(fields={})
    self.answer_id = fields[:answer_id]
    self.body = fields[:body]
    self.correct = fields[:correct]
    self.question_id = fields[:question_id]
  end

  def self.find(aid)
    res = FBC.client.get("answers/#{aid}")
    new(res.body.with_indifferent_access.merge(answer_id: aid)) if res.success?
  end

  def self.all
    res = FBC.client.get(:answers)
    if res.success? && res.body
      res.body.map { |k, v| new(v.with_indifferent_access.merge(answer_id: k)) }
    end
  end

  def save
    if answer_id.present?
      FBC.client.update("answers/#{answer_id}", body: body, correct: correct, question_id: question_id)
    else
      FBC.client.push(:answers, body: body, correct: correct, question_id: question_id).tap do |res|
        self.answer_id = res.body.with_indifferent_access[:name] if res.body.present?
      end
    end.success?
  end

  def destroy
    FBC.client.delete("answers/#{answer_id}") if answer_id.present?
  end
end