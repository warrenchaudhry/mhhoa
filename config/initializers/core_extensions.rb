Dir["#{Rails.root}/lib/core_extensions/*.rb"].each { |file| require file }
String.include CoreExtensions::Booleanize::String
Integer.include CoreExtensions::Booleanize::Integer
TrueClass.include CoreExtensions::Booleanize::TrueClass
FalseClass.include CoreExtensions::Booleanize::FalseClass
NilClass.include CoreExtensions::Booleanize::NilClass