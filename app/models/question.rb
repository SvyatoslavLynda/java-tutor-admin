class Question
  include SanitizableAttributes

  attr_accessor :_id, :body, :article_id

  def initialize(fields={})
    self._id = fields[:id]
    self.body = fields[:body]
    self.article_id = fields[:article_id]
  end

  def self.find(qid)
    res = FBC.client.get("questions/#{qid}")
    new(res.body.with_indifferent_access.merge(id: qid)) if res.success? && res.body
  end

  def self.all
    res = FBC.client.get(:questions)
    res.body.map { |k,v| new(v.with_indifferent_access.merge(id: k))} if res.success? && res.body
  end

  def save
    sanitize_attribute :body

    if _id.present?
      FBC.client.update("questions/#{_id}", body: body, article_id: article_id)
    else
      FBC.client.push(:questions, body: body, article_id: article_id).tap do |res|
        self._id = res.body.with_indifferent_access[:name] if res.body.present?
      end
    end.success?
  end

  def destroy
    FBC.client.delete("questions/#{_id}") if _id.present?
    answers.each { |a| a.destroy }
  end

  def answers
    res = FBC.client.get(:answers)

    if res.success? && res.body
      res.body.map do |key, val|
        val = val.with_indifferent_access
        Answer.new(val.merge(id: key)) if val[:question_id] == _id
      end.compact
    end
  end
end