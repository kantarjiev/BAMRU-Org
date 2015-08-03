require 'digest'
require 'active_support'
require 'active_support/core_ext'

class Event

  fields = %w(kind title location leaders start finish description lat lon prior gcal_id)
  FIELDS = fields.map(&:to_sym)

  attr_accessor *FIELDS

  def initialize(opts = {}, extend_sig = "")
    i_opts = opts.to_hash.with_indifferent_access
    FIELDS.each {|f| instance_variable_set "@#{f}", i_opts.fetch(f, "TBD")}
    @signature = "#{@title} / #{@location} / #{@start}" + extend_sig
  end

  # ----- instance methods -----

  def id
    hash
  end

  def hash
    Digest::SHA256.hexdigest(@signature).reverse[0..5].reverse
  end
end
