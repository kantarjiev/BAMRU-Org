require 'active_support'
require 'active_support/core_ext'

class Event

  FIELDS = %i(kind title location leaders start finish description lat lon prior)

  attr_accessor *FIELDS

  def initialize(opts = {})
    i_opts = opts.to_hash.with_indifferent_access
    FIELDS.each {|f| instance_variable_set "@#{f}", i_opts.fetch(f, "TBD")}
  end

  def id
    hash
  end

  # ----- instance methods -----

  def hash
    signature.hash
  end

  def signature
    "#{title} / #{location} / #{start}"
  end
end