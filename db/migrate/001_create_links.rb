# Put your database migration here!
#
# Each one needs to be named correctly:
# timestamp_[action]_[class]
#
# and once a migration is run, a new one must
# be created with a later timestamp.

class CreateLinks < ActiveRecord::Migration
    # PUT MIGRATION CODE HERE TO SETUP DATABASE
    def change
      create_table :links do |t|
        t.string :original_link
        t.string :short_link

        t.timestamps
      end
    end
end
