class Question
  attr_accessor :body

  def initialize(fields={})
    fields.each do |field, value|
      send("#{field}=", value)
    end
  end
end