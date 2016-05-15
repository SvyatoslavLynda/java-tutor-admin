class Answer
  attr_accessor :body, :correct

  def initialize(fields={})
    self.correct = false

    fields.each do |field, value|
      send("#{field}=", value)
    end
  end
end