module XmlHelper
  def self.get_key(node, key)
    return node.find(key).first.content
  end

  def self.item_enclosure(item_node)
    return item_node.find('enclosure').first
  end
end
