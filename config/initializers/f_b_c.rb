class FBC
  def self.client
    @client ||= Firebase::Client.new('https://javatutor.firebaseio.com/')
  end
end