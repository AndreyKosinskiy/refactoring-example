module Manager
  class TransactionManager
    def self.create(account:, tax_manager: Manager::TaxManager)
      Model::Transaction.new(account: account, tax_manager: tax_manager)
    end
  end
end
