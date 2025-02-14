require "bundler/inline"
require "benchmark/ips"
require "memo_wise"
require "memoist"
require "memorex"

strategies = {
  "Control" => Class.new {
    def value
      @value ||= 100
    end
  },
  "Memorex" => Class.new {
    extend Memorex
    memoize def value = 100
  },
  "Memoist" => Class.new {
    extend Memoist
    memoize def value = 100
  },
  "MemoWise" => Class.new {
    prepend MemoWise
    memo_wise def value = 100
  }
}

# See: https://github.com/evanphx/benchmark-ips?tab=readme-ov-file#custom-suite
class SuiteWithoutGC
  def warming(*)
    run_gc
  end

  def running(*)
    run_gc
  end

  def warmup_stats(*)
  end

  def add_report(*)
  end

  private

  def run_gc
    GC.enable
    GC.start
    GC.disable
  end
end

puts "== Cold cache =="
Benchmark.ips do |x|
  x.config(warmup: 2, time: 5, suite: SuiteWithoutGC.new)
  strategies.each do |name, klass|
    x.report(name) { klass.new.value }
  end
  x.compare!(order: :baseline)
end

puts "== Warm cache =="
Benchmark.ips do |x|
  x.config(warmup: 2, time: 5, suite: SuiteWithoutGC.new)
  strategies.each do |name, klass|
    instance = klass.new
    instance.value
    x.report(name) { instance.value }
  end
  x.compare!(order: :baseline)
end
