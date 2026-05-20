class ApplicationInteractor
  include Interactor
  include ActiveModel::Validations

  # The `interactor` gem stores before/after/around hooks in class instance
  # variables, which Ruby does not inherit. Without this, `before
  # :validate_context!` declared here would not fire on subclasses.
  def self.inherited(subclass)
    super
    subclass.instance_variable_set(:@before_hooks, before_hooks.dup)
    subclass.instance_variable_set(:@after_hooks, after_hooks.dup)
    subclass.instance_variable_set(:@around_hooks, around_hooks.dup)
  end

  before :validate_context!

  def read_attribute_for_validation(attribute)
    context.public_send(attribute) if context.respond_to?(attribute)
  end

  private

  def validate_context!
    return if valid?

    context.fail!(error: errors.full_messages.to_sentence, errors: errors.to_hash)
  end
end
