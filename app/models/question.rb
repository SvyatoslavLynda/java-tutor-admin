class Question
  attr_accessor :question_id, :body, :article_id

  def initialize(fields={})
    self.question_id = fields[:question_id]
    self.body = fields[:body]
    self.article_id = fields[:article_id]
  end

  def self.find(qid)
    res = FBC.client.get("questions/#{qid}")
    new(res.body.with_indifferent_access.merge(question_id: qid)) if res.success? && res.body
  end

  def self.all
    res = FBC.client.get(:questions)
    res.body.map { |k,v| new(v.with_indifferent_access.merge(question_id: k))} if res.success? && res.body
  end

  def save
    if question_id.present?
      FBC.client.update("questions/#{question_id}", body: body, article_id: article_id)
    else
      FBC.client.push(:questions, body: body, article_id: article_id)
    end.success?
  end

  def destroy
    FBC.client.delete("questions/#{question_id}") if question_id.present?
    answers.each { |a| a.destroy }
  end

  def answers
    res = FBC.client.get(:answers)

    if res.success? && res.body
      res.body.map do |key, val|
        val = val.with_indifferent_access
        Answer.new(val.merge(answer_id: key)) if val[:question_id] == question_id
      end.compact
    end
  end
end