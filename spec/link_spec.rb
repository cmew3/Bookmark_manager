require 'spec_helper'

describe Link do
	
	context 'Demonstration of how datamapper works' do
		
		it 'should be created and then retrieved from the db' do |variable|
			# in the beginning database should be empty
			expect(Link.count).to eq(0)
			Link.create(:title => "Makers Academy",
						:url => "http://www.makersacademy.com/")
			expect(Link.count).to eq(1)
			# let's look at the first (and only) link
			link = Link.first
			expect(link.url).to eq("http://www.makersacademy.com/")
			expect(link.title).to eq("Makers Academy")
			# we can destroy it
			link.destroy
			#so now we have no links in the database
			expect(Link.count).to eq(0)
		end
	end

	end