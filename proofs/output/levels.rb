require_relative '../proofs_init'

title 'Levels'

proof 'Logging level ordinal numbers correspond to textual names' do
  Output::Writer::Util.level_name(0).prove { self ==  :debug }
  Output::Writer::Util.level_name(1).prove { self ==  :info }
  Output::Writer::Util.level_name(2).prove { self ==  :warn }
  Output::Writer::Util.level_name(3).prove { self ==  :error }
  Output::Writer::Util.level_name(4).prove { self ==  :fatal }
end
