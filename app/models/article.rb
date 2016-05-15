class Article
  attr_accessor :article_id, :title, :body

  def initialize(fields={})
    self.article_id = fields[:article_id]
    self.title = fields[:title]
    self.body = fields[:body]
  end

  def self.find(aid)
    res = FBC.client.get("articles/#{aid}")
    new(res.body.with_indifferent_access.merge(article_id: aid)) if res.success? && res.body
  end

  def self.all
    res = FBC.client.get(:articles)
    res.body.map { |k,v| new(v.with_indifferent_access.merge(article_id: k))} if res.success? && res.body
  end

  def save
    if article_id.present?
      FBC.client.update("articles/#{article_id}", title: title, body: body)
    else
      FBC.client.push(:articles, title: title, body: body)
    end.success?
  end

  def destroy
    FBC.client.delete("articles/#{article_id}") if article_id.present?
    questions.each { |q| q.destroy }
  end

  def questions
    res = FBC.client.get(:questions)
    if res.success? && res.body
      res.body.map do |key, val|
        val = val.with_indifferent_access
        Question.new(val.merge(question_id: key)) if val[:article_id] == article_id
      end.compact
    end
  end
end