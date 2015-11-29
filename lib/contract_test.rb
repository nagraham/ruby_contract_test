require 'contracts'


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
  
  # Basic sanity test to make sure this works
  Contract C::Num, C::Num => C::Num
  def self.add(a, b)
    a + b
  end
   
  # Testing methods with hash arguments that return a library Class
  Contract C::KeywordArgs[ :name => C::Optional[String] ] => User
  def self.create_user(request = {})
    return User.new(request)
  end
end

puts ContractTest.add(2, 3) 
p ContractTest.create_user(name: "Alex")
p ContractTest.create_user()