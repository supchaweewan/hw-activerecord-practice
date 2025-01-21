require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new($stdout)

# Normally a separate file in a Rails app.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Customer < ApplicationRecord
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    Customer.where(first: "Candice")
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    Customer.where("email LIKE '%@%'")
  end
  # etc. - see README.md for more details
  def self.with_dot_org_email
    # return an email with .org
    Customer.where("email LIKE '%.org%'")
  end

  def self.with_invalid_email
    # return an email without @
    Customer.where("email NOT LIKE '%@%'")
  end

  def self.born_before_1980
    # return customer born before 1 Jan 1980
    Customer.where("birthdate < '1980-01-01'")
  end

  def self.with_valid_email_and_born_before_1980
    # return customer with valid email (containing @) and born before 1 Jan 1980
    Customer.where("email LIKE '%@%' AND birthdate < '1980-01-01'")
  end

  def self.with_blank_email
    # return customer with blank email
    Customer.where("email IS NULL")
  end

  def self.last_names_starting_with_b
    # return customer with last name starting with B and sorted by birthdate
    Customer.where("last LIKE 'B%'").order(:birthdate)
  end

  # without where =================================

  def self.twenty_youngest
    # return 20 youngest customers, order/limit
    Customer.order(:birthdate => :desc).limit(20)
  end

  # with tot update ===============================

  def self.update_gussie_murray_birthdate
    # the birthdate of Gussie Murray to February 8,2004 (HINT: lookup `Time.parse`)'

    # Time.parse("February 8, 2004") is a ruby method that converts a string to a time object
    Customer.find_by(first: "Gussie", last: "Murray").update(birthdate: Time.parse("February 8, 2004"))
  end

  def self.change_all_invalid_emails_to_blank
    # change all invalid emails to blank
    Customer.where("email NOT LIKE '%@%'").update_all(email: "")
  end

  def self.delete_meggie_herman
    # database by deleting customer Meggie Herman
    Customer.find_by(first: "Meggie", last: "Herman").destroy
  end

  def self.delete_everyone_born_before_1978
    # deleting all customers born on or before 31 Dec 1977
    Customer.destroy_by("birthdate < '1978-01-01'")
  end
end
