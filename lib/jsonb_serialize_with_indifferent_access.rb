class JSONBSerializeWithIndifferentAccess

  def self.dump(hash)
    hash
  end

  def self.load(json)
    HashWithIndifferentAccess.new(json)
  end

end
