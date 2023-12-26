require 'json'

$issues = []

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

unless File.exist?("rbs_report.txt")
  process_steep_report(`steep check`) do |issue|
    $issues.push(issue)
  end

  docs = File.open("rbs_report.txt", "w")
  $issues.each do |issue|
    docs.write(issue + "\n\n")
  end
  docs.close
end