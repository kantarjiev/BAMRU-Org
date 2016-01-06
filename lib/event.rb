require 'digest'
require 'active_support'
require 'active_support/core_ext'

class Event
  fields = %w(kind title leaders
              begin_date begin_time finish_date finish_time
              location lat lon description prior gcal_id)
  FIELDS = fields.map(&:to_sym)

  attr_accessor *FIELDS

  def initialize(opts = {}, prev_event = nil)
    @prev_event = prev_event
    hash_opts = opts.to_hash.with_indifferent_access
    FIELDS.each {|f| instance_variable_set "@#{f}", hash_opts.fetch(f, "TBD")}
  end

  # ----- instance methods -----

  def hash
    signature = [title, location, begin_date, begin_time, finish_date, finish_time, description].join(' / ')
    @hash ||= Digest::SHA256.hexdigest(signature).reverse[0..5].reverse

    # Duplicate events can creep in during testing. When everything is functioning
    # correctly duplicate records shouldn't exist. Use the gcal_id as the hash to make
    # duplicate events unique so they are deleted during sync
    if !@prev_event.nil? and @hash == @prev_event.hash
      @hash = gcal_id
      @prev_event = "duplicate"  # simplify event for debug
    else
      @prev_event = nil
    end
    @hash
  end
  alias_method :id, :hash

end
