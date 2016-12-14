class Client < ApplicationRecord
  has_many :transactions

  def self.from_rut(rut)
    begin
      return Client.find_by! rut: rut
    rescue ActiveRecord::RecordNotFound
      return Client.new rut: rut
    end
  end
end
