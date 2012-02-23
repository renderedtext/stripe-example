# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Seed stripe plans
# Stripe can give an Stripe::InvalidRequestError: Plan already exists. If that occurs, simply move on
stripe_plans = [
  { amount: 1500, interval: 'month', currency: 'usd', id: 'another-plan', name: 'another plan' },
  { amount: 1000, interval: 'month', currency: 'usd', id: 'test-plan',    name: 'test plan'    }
]

stripe_plans.each { |plan| Stripe::Plan.create plan rescue puts "Skipping #{ plan[:name] }"}
