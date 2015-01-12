LibName = "EJSON"
Julia = "julia034"
#Julia = "julia04"
TestDir = "test"

MoreFactor = 10
MostFactor = 1000
TimedTestMinFactor = 100
TimedTestMaxFactor = 1000

MainFile = "src/#{LibName}.jl"
Command = "nice -9 time #{Julia} --color=yes -L #{MainFile}"

def runtestfile(filename)
  if File.exist?(filename)
    sh "#{Command} #{filename}"
  else
    # puts "No test file named #{filename} found."
  end
end

desc "Core tests: Use only Base.Test to test the basic Autotest functionality"
task :coretest do
  runtestfile "test/runtests.jl"
end
task :ct => :coretest

def autotest(verbosity = 2, minReps = 30, maxReps = 1000, maxRepTime = 1.0, func = "test", timeToRun = -1.0)
  cmd = "#{Command} -e 'using Autotest; Autotest.#{func}(\"#{LibName}\"; testdir = \"#{TestDir}\", " + 
    "verbosity = #{verbosity}" +
    ", MinRepetitions = #{minReps}, MaxRepetitions = #{maxReps}, MaxRepeatTime = #{maxRepTime}" +
    ", timeToRun = #{timeToRun}" +
    ")'"
  sh cmd
end

desc "Run Autotest tests"
task :test do
  autotest(2, 30, 1000, 1.0)
end
task :default => :test

desc "More self tests: Use Autotest to test itself with more repetitions"
task :testmore do
  autotest(2, 30*MoreFactor, 1000*MoreFactor, 1.0 * 2.0 * Math.log10(MoreFactor))
end

desc "Most self tests: Use Autotest to test itself with most/many repetitions"
task :testmost do
  autotest(2, 30*MostFactor, 1000*MostFactor, 1.0 * 2.0 * Math.log10(MostFactor))
end

def timed_test(numSeconds)
  autotest(2, 30*TimedTestMinFactor, 1000*TimedTestMaxFactor, 1.0 * 2.0 * Math.log10(TimedTestMaxFactor), 
    "test", numSeconds)
end

desc "Run Autotests for 1 minute"
task :test1 do
  timed_test(1 * 60)
end

desc "Run Autotests for 5 minutes"
task :test5 do
  timed_test(5 * 60)
end

def seconds_until_tomorrow_at_time(time = "07:00")
  tnow = Time.now
  (Time.parse(time, tnow + 24*60*60) - tnow).floor
end

desc "Overnight testing: Use Autotest to test itself until around 07:00 the next morning"
task :overnight do
  timed_test(seconds_until_tomorrow_at_time("07:00"))
end

def filter_latest_changed_files(filenames, numLatestChangedToInclude = 1)
  filenames.sort_by{ |f| File.mtime(f) }[-numLatestChangedToInclude, numLatestChangedToInclude]
end

desc "Run only the latest changed test file"
task :testlatest do
  files = filter_latest_changed_files(Dir["test/**/test*.jl"])
  if files == nil || files.length < 1
    puts "No test files found"
    exit(-1)
  end
  latest_changed_test_file = files.first
  sh "#{Command} -e 'using Autotest; Autotest.run_tests_in_file(\"#{LibName}\", \"#{latest_changed_test_file}\")'"
end

desc "Shorthand for testlatest: Run only the latest changed test file"
task :t => :testlatest

desc "Start autotesting on the src and test dirs, will rerun tests when there are changes"
task :autotest do
  autotest(2, 30, 1000, 1.0, "autotest")
end
task :auto => :autotest