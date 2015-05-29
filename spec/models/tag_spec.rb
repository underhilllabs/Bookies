# require 'rails_helper'
# 
# describe Tag do
#   let(:tag) { Tag.new }
#   describe "validation" do
# 
#     it "fails without a name" do
#       tag.name = nil
#       expect(tag).to_not be_valid
#     end
# 
#     it "fails without a bookmark" do
#       tag.name = "test"
#       tag.user_id = 1
#       tag.bookmark_id = nil
#       expect(tag).to_not be_valid
#     end
# 
#     it "fails without a user" do
#       tag.name = "test"
#       tag.bookmark_id = 1
#       tag.user_id = nil
#       expect(tag).to_not be_valid
#     end
# 
#     it "succeeds with a user, name and bookmark" do
#       tag.name = "test"
#       tag.bookmark_id = 1
#       tag.user_id = 1
#       expect(tag).to be_valid
#     end
# 
#   end
# end
