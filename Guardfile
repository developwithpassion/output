guard 'shell' do
  watch(/(.*).rb/) { system("pushd proofs;ruby suite.rb;popd") }
end
