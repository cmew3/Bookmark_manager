require 'spec_helper'
def reload(resource)
	resource.class.get(resource.id)
end
describe User do

	it 'can reset a password when given a password hash' do 
		user = User.create(:email => "test2@test.com",
					:password => "test2",
					:password_confirmation => "test2",  
					:password_token => "ABCDEFGHIJKLMNO",
					:password_token_timestamp => Time.now-60)
		digest = user.password_digest
		user.reset_password("newpass","newpass")
		user = reload(user)
		expect(user.password_token).to be nil
		expect(user.password_token_timestamp).to be nil
		expect(user.password_digest).not_to eq digest
	end


	it 'does not reset a password if validations fail' do 
		user = User.create(:email => "test5@test.com",
					:password => "test2",	
					:password_confirmation => "test2",  
					:password_token => "ABCDEFGHIJKLMNO",
					:password_token_timestamp => Time.now-60)
		digest = user.password_digest
		user.reset_password("newpass","wrongconfirm")
		user = reload(user)
		expect(user.password_token).not_to be nil
		expect(user.password_token_timestamp).not_to be nil
		expect(user.password_digest).to eq digest
	end

end		