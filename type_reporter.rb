require 'json'
require 'digest'

$issues = []

def process_steep_report(report_contents)
  current_issue = {}
  report_contents.each_line do |line|
    if line =~ /((?:[\w\s]+\/)+[\w\s]+\.(?:rb|rbs)):(\d+):\d+: \[(\w+)\] (.*)/i
      unless current_issue.empty? && !$issues.any? { |issue| issue == current_issue }
        yield current_issue
      end
      current_issue = {
        "description" => $4.to_s,
        "check_name" => "Unknown Error Type",
        "fingerprint" => Digest::MD5.hexdigest(line),
        "severity" => $3.to_s,
        "location" => {
          "path" => $1.to_s,
          "lines" => {
            "begin" => $2.to_i
          }
        }
      }
    elsif !current_issue.empty? && line =~ /Diagnostic ID: (.*)/i
      current_issue["check_name"] = $1.to_s
    end
  end
end

if File.exist?("rbs_report.txt")
  docs = File.open("rbs_report.txt", "r")
  process_steep_report(docs.read) do |issue|
    $issues.push(issue)
  end

  File.open("rbs_issues.json", "w") do |output|
    output.write($issues.to_json)
  end
end