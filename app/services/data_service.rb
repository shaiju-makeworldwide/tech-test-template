module DataService
  def self.method_missing(klass, *args, &block) # rubocop:disable Style/MethodMissingSuper, Style/MissingRespondToMissing
    "DataService::#{klass.to_s.camelize}".constantize.perform(*args, &block)
  end
end
