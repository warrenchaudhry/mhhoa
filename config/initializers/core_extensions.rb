Dir["#{Rails.root}/lib/core_extensions/*.rb"].each {|file| require file }
String.include CoreExtensions::Booleanize::String
Fixnum.include CoreExtensions::Booleanize::Fixnum
TrueClass.include CoreExtensions::Booleanize::TrueClass
FalseClass.include CoreExtensions::Booleanize::FalseClass
NilClass.include CoreExtensions::Booleanize::NilClass