require 'digest'
require 'active_support'
require 'active_support/core_ext'

class Event

  fields = %w(kind title location leaders start finish description lat lon prior gcal_id)
  FIELDS = fields.map(&:to_sym)

  attr_accessor *FIELDS

  def initialize(opts = {}, compare_event = nil)
    i_opts = opts.to_hash.with_indifferent_access   # Called with array and CSV opts
    FIELDS.each {|f| instance_variable_set "@#{f}", i_opts.fetch(f, "TBD")}
    create_signature(i_opts, compare_event)
  end

  # ----- instance methods -----

  def id
    hash
  end

  def hash
    Digest::SHA256.hexdigest(@signature).reverse[0..5].reverse
  end

  private

  def create_signature(opts, c_event)
    @signature = "#{@title} / #{@location} / #{@start}"

    # Handle duplicates, duplicate events are hashed with the
    # gcal_id to make them unique. When everything is functioning
    # correctly duplicate records shouldn't exist but they may creep in
    # during testing.  Try deleting gcal_test.yaml and run sync
    
    if c_event && @title == c_event.title && @location == c_event.location && @start == c_event.start
      @signature += " / #{opts[:gcal_id]}"
      if VERBOSE 
        puts "Event dup: #{opts[:title]} [#{opts[:start]}]"#c if result.body == ""
      end
    end
  end

end
