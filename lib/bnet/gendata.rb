require "open-uri"
require_relative "../base"
require_relative "../rake/loggers"

class Bnet
  class GenTestData
    extend Rake::Loggers

    class << self
      def execute

        save_gen_data(create_data)
      end

      def create_data

        x1 = '[LBBFFLXYD]'
        b1 = (Time.now + 1.day).change({ hour: 9 })
        f1 = (Time.now + 2.day).change({ hour: 18 })
        d1 = b1.strftime("%Y-%m-%d,%H%M")+f1.strftime(",%Y-%m-%d,%H%M")

        x2 = '[LBBF-L---]'
        b2 = (Time.now + 2.day).change({ hour: 8 })
        f2 = (Time.now + 4.day).change({ hour: 0 })
        d2 = b2.strftime("%Y-%m-%d,%H%M")+f2.strftime(",%Y-%m-%d,")

        x3 = '[LBB-FL---]'
        b3 = (Time.now + 3.day).change({ hour: 8 })
        f3 = (Time.now + 0.day).change({ hour: 17 })
        d3 = b3.strftime("%Y-%m-%d,%H%M")+f3.strftime(",,%H%M")

        x4 = '[LBB--L---]'
        b4 = (Time.now + 4.day).change({ hour: 11 })
        f4 = (Time.now + 0.day).change({ hour: 0 })
        d4 = b4.strftime("%Y-%m-%d,%H%M")+f4.strftime(",,")

        x5 = '[-B-FFL--D]'
        b5 = (Time.now + 5.day).change({ hour: 0 })
        f5 = (Time.now + 8.day).change({ hour: 14 })
        d5 = b5.strftime("%Y-%m-%d,")+f5.strftime(",%Y-%m-%d,%H%M")

        x6 = '[-B-F-L---]'
        b6 = (Time.now + 6.day).change({ hour: 0 })
        f6 = (Time.now + 10.day).change({ hour: 0 })
        d6 = b6.strftime("%Y-%m-%d,")+f6.strftime(",%Y-%m-%d,")

        x7 = '[-B--FL---]'
        b7 = (Time.now + 7.day).change({ hour: 0 })
        f7 = (Time.now + 0.day).change({ hour: 10 })
        d7 = b7.strftime("%Y-%m-%d,")+f7.strftime(",,%H%M")

        x8 = '[-B---LXYD]'
        b8 = (Time.now + 8.day).change({ hour: 0 })
        f8 = (Time.now + 0.day).change({ hour: 0 })
        d8 = b8.strftime("%Y-%m-%d,")+f8.strftime(",,")

        csv_text =
          [
           "kind,title,leaders,begin_date,begin_time,finish_date,finish_time,location,lat,lon,description",
            "meeting,'C1:Meeting   #{x1}',Lead1,#{d1},Loc 1,37.7207,-122.0962,Desc C1",
           "training,'C2:Training  #{x2}',Lead2,#{d2},Loc 2",
           "training,'C3:Training  #{x3}',Lead3,#{d3},Loc 3",
           "training,'C4:Training  #{x4}',Lead4,#{d4},Loc 4",
           "training,'C5:Training  #{x5}',TBA,#{d5},Loc 5,,,Desc C6",
           "training,'C6:Training  #{x6}',TBA,#{d6},Loc 6",
           "training,'C7:Training  #{x7}','',#{d7},Loc 7",
          "community,'C8:Community #{x8}',,#{d8},Loc 8,37.7207,-122.0962,Desc C8",
          ].join("\n")
      end

      def save_gen_data(csv_text)
        File.open(BNET_DATA_CSV_FILE, 'w') {|f| f.puts csv_text}
        count = CSV.parse(csv_text, headers: true).length
        log "Generated data: Saved #{count} events to #{BNET_DATA_CSV_FILE}"
      end

    end

  end
end
# /*
# D1: 2016-01-01,1300,2016-01-02,1700
# D2: 2016-01-02,1900,2016-01-02
# D3: 2016-01-03,0900,'',1200
# D4: 2016-01-04,'0800','',''
# D5: 2016-01-05,'','2016-01-06',1100
# D6: 2016-01-06,'',2016-01-06,''
# D7: 2016-01-07,'','',1200
# D8: 2016-01-08,'','',''
#         #abort_message           if MM_ENV == 'production'
# */
