class Moment
  # Creates a new Moment object and initializes it with current date and time
  def self.now
    self.new
  end

  # Initializes in one of four ways:
  #
  # * No argument:          same as Moment.now
  # * String:               parses string into date/time
  # * String:format:        parses string into date/time using given format
  # * String:format:locale: parses string into date/time using given format and locale
  def initialize(arg = nil, options = {})
    @moment = case arg
      when nil
        NSMoment.now
      when NSDate, Time
        NSMoment.momentWithDate arg
      when NSArray, Array
        NSMoment.momentWithArray arg
      when NSString, String
        if options.empty?
          NSMoment.momentWithDateAsString arg
        else
          initialize_with_format arg, options
        end
    end
  end

  def initialize_with_format(arg, options)
    raise ArgumentError.new('requires format: key') unless options[:format]
    return NSMoment.momentWithDateAsString arg, format: options[:format], localeIdentifier: options[:locale_identifier] if options[:locale_identifier]
    NSMoment.momentWithDateAsString arg, format: options[:format]
  end

  # Query validity of current Moment
  def valid?
    @moment.isValid
  end

  # Format Moment. This is done in one of two ways:
  #
  # No format string: Use ISO-8601 format
  # Format string:    Format according to these:
  #
  # Format String         | Output String
  # --------------------- | --------------
  # M/d/y                 | 11/4/2012
  # MM/dd/yy              | 11/04/12
  # MMM d, ''yy           | Nov 4, '12
  # MMMM                  | November
  # E                     | Sun
  # EEEE                  | Sunday
  # 'Week' w 'of 52'      | Week 45 of 52
  # 'Day' D 'of 365'      | Day 309 of 365
  # QQQ                   | Q4
  # QQQQ                  | 4th quarter
  # m 'minutes past' h    | 9 minutes past 8
  # h:mm a                | 8:09 PM
  # HH:mm:ss's'           | 20:09:00s
  # HH:mm:ss:SS           | 20:09:00:00
  # h:mm a zz             | 8:09 PM CST
  # h:mm a zzzz           | 8:09 PM Central Standard Time
  # yyyy-MM-dd HH:mm:ss Z | 2012-11-04 20:09:00 -0600

  def format(format_string = nil)
    if format_string != nil
      @moment.format(format_string)
    else
      @moment.format
    end
  end

  alias_method :to_s, :format

  # Return NSLocale. WARNING: Experimental
  def locale
    @moment.locale
  end

  # Return Time object of the Moment
  def date
    @moment.date
  end

  def eql(other, tolerance_in_seconds)
    @moment.date.timeIntervalSinceDate(other.date).abs <= tolerance_in_seconds
  end

  # Tests equality of two moments. Note equality in Cocoapod doesn't
  # really do anything useful because it uses isEqualToDate, which
  # requires exact comparisons in order to succeed. By default, the
  # tolerance on this test is same minute.
  def ==(other)
    eql(other, 60.0)
  end

  # Gets text representation of relation to now. For example,
  # 11 years ago. Note that suffix provides the relation, so
  # without a suffix, you might get '11 years' but with,
  # '11 years ago'.
  def from_now(options = {suffix: true})
    @moment.fromNowWithSuffix(options[:suffix])
  end

  # Gets text representation of the difference between two dates.
  # Notes about from_now apply regarding suffix.
  def from_date(date, options = {suffix: true})
    @moment.fromDate(date, withSuffix: options[:suffix])
  end

  def from_moment(moment, options = {suffix: true})
    @moment.fromMoment(moment, withSuffix: options[:suffix])
  end
end
