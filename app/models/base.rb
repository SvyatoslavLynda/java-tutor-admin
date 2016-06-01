class Base
  include SanitizableAttributes

  def self.find(record_id)
    res = FBC.client.get("#{self.name.downcase.pluralize}/#{record_id}")

    if res.success? && res.body
      new(res.body.with_indifferent_access.merge(id: record_id))
    end
  end

  def self.all
    res = FBC.client.get(self.name.downcase.pluralize)

    if res.success? && res.body
      res.body.map { |k, v| new(v.with_indifferent_access.merge(id: k))}
        .sort_by(&:position)
    end
  end

  def save(params)
    if _id.present?
      FBC.client.update("#{self.class.name.downcase.pluralize}/#{_id}", params)
    else
      FBC.client.push(self.class.name.downcase.pluralize, params).tap do |res|
        self._id = res.body.with_indifferent_access[:name] if res.body.present?
      end
    end.success?
  end

  def destroy(children)
    if _id.present?
      FBC.client.delete("#{self.class.name.downcase.pluralize}/#{_id}")
      children.each(&:destroy)
    end
  end
end