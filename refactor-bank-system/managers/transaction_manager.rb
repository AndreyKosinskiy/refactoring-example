module Manager
  class TransactionManager
    def create(account:, tax_manager: Manager::TaxManager)
      Model::Transaction(account: account, tax_manager: tax_manager)
    end
  end
end
