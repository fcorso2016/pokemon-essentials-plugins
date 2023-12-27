require 'json'

$rules = {}
$issues = []

def process_steep_report(report_contents)
  current_issue = {}
  report_contents.each_line do |line|
    if line =~ /((?:[\w\s]+\/)+[\w\s]+\.(?:rb|rbs)):(\d+):(\d+): \[(\w+)\] (.*)/i
      unless current_issue.empty? && !$issues.any? { |issue| issue == current_issue }
        yield current_issue
      end
      current_issue = {
        "ruleId" => "RBS Type Error",
        "level" => $4.to_s,
        "message" => {
          "text" => $5.to_s
        },
        "locations" => [
          {
            "physicalLocation" => {
              "artifactLocation" => {
                "uri" => $1.to_s.gsub(" ", "%20"),
                "uriBaseId" => "%SRCROOT%"
              },
              "region" => {
                "startLine" => $2.to_i,
                "startColumn" => $3.to_i,
                "endLine" => $2.to_i,
                "endColumn" => $3.to_i
              }
            }
          }
        ]
      }
    elsif !current_issue.empty? && line =~ /Diagnostic ID: (.*)/i
      current_issue["ruleId"] = $1.to_s
      $rules[current_issue["ruleId"]] ||= {
        "id" => current_issue["ruleId"],
        "shortDescription" => {
          "text" => "RBS Type Scan Issue"
        },
        "properties" => {
          "tags" => %w[ruby type-error]
        }
      }
    end
  end
end

if File.exist?("rbs_report.txt")
  docs = File.open("rbs_report.txt", "r")
  process_steep_report(docs.read) do |issue|
    $issues.push(issue)
  end

  File.open("rbs_issues.json", "w") do |output|
    full_json = {
      "$schema" => "http://json.schemastore.org/sarif-2.1.0",
      "version" => "2.1.0",
      "runs" => [
        {
          "tool" => {
            "driver" => {
              "name" => "Steep Type Checker",
              "version" => `steep --version`.strip,
              "rules" => $rules.values
            },
          },
          "results" => $issues
        }
      ]
    }
    output.write(full_json.to_json)
  end
end