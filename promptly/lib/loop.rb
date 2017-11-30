class Loop
  def self.while_success(*statements)
    head = statements.shift
    result = head.call
    return result if result == false
    return result != false unless statements.count > 0
    while_success(*statements)
  end
end
