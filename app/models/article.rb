class Article
  attr_accessor :title, :body

  def initialize(fields={})
    fields.each do |field, value|
      send("#{field}=", value)
    end
  end
end