describe "Moment" do
  describe "initializers" do
    it "initializes with no arguments" do
      Moment.new.class.should == Moment
      Moment.new('11-16-1986').class.should == Moment
    end

    it "initializes with an array argument" do
      Moment.new([2019, 12, 22, 12, 0, 0]).class.should == Moment
    end

    it "initializes with a string argument" do
      Moment.new('12-27-2019').class.should == Moment
    end

    it "initializes with a string argument and format" do
      Moment.new('12/22/2019', format: "M/d/y").class.should == Moment
    end

    # This doesn't work as it would appear to.

    # it "initializes with a string in a given locale" do
    #   tc = Moment.new('12-22-2019', format: "mm-dd-YYYY", locale_identifier: 'fr_FR')
    #   tc.should.not == nil
    #   tc.locale.should == 'fr_FR'
    # end
  end

  it "considers a valid date valid" do
    Moment.new('12-22-2019').should.be.valid
  end

  it "considers an invalid date invalid" do
    Moment.new('2a2/31/2019').should.not.be.valid
  end

  it "fetches an NSDate on request" do
    Moment.new('12-22-2019').date.class.should == Time
  end

  describe "formatting" do
    it "formats a date using no string format" do
      Moment.new('12-29-2019').format.should.match /2019-12-29T12:00:00/
    end

    it "formats a date using a string format" do
      Moment.new('11-16-1986').format("MMM dd, ''YY").should == "Nov 16, '86"
    end
  end

  describe "relational operators" do
    it "tests equality" do
      (Moment.new('11-16-1986') == Moment.new('11-16-1986')).should == true
      (Moment.new('11-16-1986').eql(Moment.new('11-16-1986'), 0)).should == true
      (Moment.new('11-16-1986') == Moment.new('11-16-1986')).should == true
      (Moment.new('11-16-1986 3:01:01PM') == Moment.new('11-16-1986 3:02:00')).should == true
      (Moment.new('11-16-1986 3:01:01PM') == Moment.new('11-16-1986 3:01:03')).should == true
    end

    it "detects inequality" do
      (Moment.new('11-16-1986') == Moment.new('11-17-1986')).should.not == true
      (Moment.new('11-16-1986 3:01PM') == Moment.new('11-17-1986 3:02PM')).should.not == true
    end

    it "properly words 'from now'" do
      Moment.new('11-16-1986').from_now.should.match /years ago/
    end

    it "properly words 'from now' without a suffix" do
      Moment.new('11-16-1986').from_now(suffix: false).should.match /years ago/
    end

    it "properly words 'from date'" do
      Moment.new('12-22-2019').from_date(Moment.new('12-15-2019').date).should.match /in 7 days/
    end

    it "properly words 'from date' without a suffix" do
      Moment.new('12-22-2019').from_date(Moment.new('12-15-2019').date, suffix: false).should.match /7 days/
    end

    it "properly words 'from moment'" do
      Moment.new('11-18-13 @ 5:00 PM').from_moment(Moment.new('11-18-13 @ 6:00 PM')).should == 'an hour ago'
    end
  end
end
