require 'contracts'
require 'benchmark'

class User
  
  attr_accessor :name
  
  def initialize(hash = {})
    self.name = hash[:name]
  end
  
  # You need valid? method on the class
  def self.valid? user
    not user.name.nil?
  end
  
end

module ContractTest
  
  include Contracts::Core
  C = Contracts
  
  # Sanity test to make sure the Contract gem is set up correctly
  Contract C::Num, C::Num => C::Num
  def self.add(a, b)
    a + b
  end
  
  def self.add_no_contract(a, b)
    a + b
  end
   
  # Testing methods with hash arguments that return a library Class
  Contract C::KeywordArgs[ :name => C::Optional[String] ] => User
  def self.create_user(request = {})
    return User.new(request)
  end
  
  def self.create_user_no_contract(request = {})
    return User.new(request)
  end
  
end

# Helper method to compare the performance of methods with Contracts
def compare_performance(entity, method, *args)
  no_contract_label = "#{entity}:#{method}_no_contract"
  with_contract_label = "#{entity}:#{method}"
  
  Benchmark.bm(no_contract_label.length) do |x|
    x.report(no_contract_label) { entity.send("#{method}_no_contract", *args) }
    x.report(with_contract_label) { entity.send(method, *args) }
  end
end

#
# --- Executable ---
#
p ContractTest.add(2, 3)
compare_performance(ContractTest, "add", 2, 3)

p ContractTest.create_user(name: "Alex")
compare_performance(ContractTest, "create_user", {name: "Alex"})
