RSpec::Matchers.define :validate do |kind, options|

  field      = example.metadata[:example_group][:description_args].first
  validators = described_class.validators_on field

  description { "validate the #{ kind } of #{ field.inspect }" }

  match_for_should do
    validators.any? { |v| v.kind == kind }
  end

  match_for_should_not do
    validators.none? { |v| v.kind == kind }
  end

end
