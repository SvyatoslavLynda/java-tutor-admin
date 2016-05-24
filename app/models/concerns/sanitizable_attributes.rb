module SanitizableAttributes
  extend ActiveSupport::Concern

  def sanitize_attribute(attr)
    new_value = Rails::Html::WhiteListSanitizer.new.sanitize(
        public_send(attr),
        tags: %w(ul ol li a img font strong em i b u p br h1 h2 h3 h4 h5 h6),
        attributes: %w(href src size color)
    )
    new_value = replace_tag(new_value, old: :strong, new: :b)
    new_value = replace_tag(new_value, old: :em, new: :i)
    new_value = convert_img_sources(new_value)
    public_send "#{attr}=", new_value
  end

  private

  def replace_tag(html, old: , new:)
    html.gsub(/(<\/?)\s*#{old}\s*>/i, "\\1#{new}>")
  end

  def convert_img_sources(html)
    html.gsub(/(?<=src\=")(.*?)(?=")/) {|url| generate_correct_img_src(url.to_s.strip)}
  end

  def generate_correct_img_src(url)
    path = Addressable::URI.parse(url).try(:path)
    return path if path.blank?
    path.insert(0, '/') unless path.first == '/'
    path
  end
end
