$issues = []
$script_files = {"." => []}

def process_steep_report(report_contents)
  current_issue = ""
  report_contents.each_line do |line|
    if line =~ /(?:(?:[\w\s]+\/)+(?:[\w\s]+)\.(?:rb|rbs)):\d+:\d+: \[(\w+)\]/i
      unless current_issue.empty? && !$issues.any? { |issue| issue == current_issue }
        yield current_issue
      end
      current_issue = line
    elsif !current_issue.empty? && !line.empty?
      current_issue += line
    end
  end
end

Dir.each_child("Data/Scripts") do |item|
  if item =~ /(.*)\.rb/i
    $script_files["."].push(item)
  else
    $script_files[item] ||= []
    $script_files[item].push(Dir.glob("Data/Scripts/#{item}/**/*.rb"))
  end
end
$script_files.each do |scripts|
  print "Processing: #{scripts[0]}\n"
  process_steep_report(`steep check #{scripts[1].join(" ")}`) do |issue|
    $issues.push(issue)
  end
end

$issues.each do |issue|
  print issue
  print "\n\n"
end