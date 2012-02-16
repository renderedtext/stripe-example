RSpec::Matchers.define :validate do |kind, expected_options|

  field     = example.metadata[:example_group][:description_args].first
  validator = described_class.validators_on(field).detect { |v| v.kind == kind }
  options   = validator.options

  diff      = expected_options.present? ? options.diff(expected_options) : nil

  description do
    msg  = "validate the #{ kind } of #{ field.inspect }"
    msg += " with options: #{ expected_options.inspect }" unless expected_options.blank?
    msg
  end

  failure_message_for_should do
    msg  = "Expected #{ described_class } to validate the #{ kind } of #{ field.inspect }"
    if expected_options.present? and diff.present?
      msg += "\n with options: #{ expected_options.inspect }"
      msg += "\n actual options: #{ options.inspect }"
    end
    msg
  end

  failure_message_for_should_not do
    "Did not expect #{ described_class } to validate the #{ kind } of #{ field.inspect }"
  end

  match_for_should     { validator.present? and diff.blank? }
  match_for_should_not { validator.blank? }

end
