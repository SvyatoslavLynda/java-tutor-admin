class Article
  include SanitizableAttributes

  attr_accessor :_id, :title, :body

  def initialize(fields={})
    self._id = fields[:id]
    self.title = fields[:title]
    self.body = fields[:body]
  end

  def self.find(aid)
    res = FBC.client.get("articles/#{aid}")
    new(res.body.with_indifferent_access.merge(id: aid)) if res.success? && res.body
  end

  def self.all
    res = FBC.client.get(:articles)
    res.body.map { |k,v| new(v.with_indifferent_access.merge(id: k))} if res.success? && res.body
  end

  def save  
    sanitize_attribute :body

    if _id.present?
      FBC.client.update("articles/#{_id}", title: title, body: body)
    else
      FBC.client.push(:articles, title: title, body: body).tap do |res|
        self._id = res.body.with_indifferent_access[:name] if res.body.present?
      end
    end.success?
  end

  def destroy
    FBC.client.delete("articles/#{_id}") if _id.present?
    questions.each { |q| q.destroy }
  end

  def questions
    res = FBC.client.get(:questions)
    if res.success? && res.body
      res.body.map do |key, val|
        val = val.with_indifferent_access
        Question.new(val.merge(id: key)) if val[:article_id] == _id
      end.compact
    end
  end
end