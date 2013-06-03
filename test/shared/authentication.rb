# Copyright (C) 2013 10gen Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module AuthenticationTests

  def init_auth
    # enable authentication by creating and logging in as admin user
    @admin = @client['admin']
    @admin.add_user('admin', 'password')
    @admin.authenticate('admin', 'password')
  end

  def teardown
    @admin.logout
    @admin.authenticate('admin','password')
    @admin['system.users'].remove
    @db['system.users'].remove
    @db['test'].remove
    @admin.logout
  end

  def test_add_user
    @db.add_user('bob','user')
    assert @db['system.users'].find_one({:user => 'bob'})
  end

   def test_remove_user
    @db.remove_user('bob')
    assert_nil @db['system.users'].find_one({:user => 'bob'})
  end

  def test_remove_non_existent_user
    assert_equal @db.remove_user('joe'), false
  end

  def test_authenticate
    @db.add_user('peggy', 'user')
    assert @db.authenticate('peggy', 'user')
    @db.remove_user('peggy')
    @db.logout
  end

  def test_authenticate_non_existent_user
    assert_raise Mongo::AuthenticationError do
      @db.authenticate('frank', 'thetank')
    end
  end

  def test_logout
    @db.add_user('peggy', 'user')
    assert @db.authenticate('peggy', 'user')
    assert @db.logout
    @db.remove_user('peggy')
  end

  def test_authenticate_with_special_characters
    assert @db.add_user('foo:bar','@foo')
    assert @db.authenticate('foo:bar','@foo')
    @db.remove_user('foo:bar')
    @db.logout
  end

  def test_authenticate_read_only
    @db.add_user('randy', 'readonly', true)
    assert @db.authenticate('randy', 'readonly')
    @db.remove_user('randy')
    @db.logout
  end
end
