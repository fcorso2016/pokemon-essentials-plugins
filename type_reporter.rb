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

      path = $1.to_s
      level = $4.to_s
      description = $5.to_s
      line = $2.to_i
      column = $3.to_i

      current_issue = {
        "ruleId" => "RBS Type Error",
        "level" => level,
        "message" => {
          "text" => description
        },
        "locations" => [
          {
            "physicalLocation" => {
              "artifactLocation" => {
                "uri" => path.gsub(" ", "%20"),
                "uriBaseId" => "%SRCROOT%"
              },
              "region" => {
                "startLine" => line,
                "startColumn" => column,
                "endLine" => line,
                "endColumn" => column
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
          "text" => current_issue["ruleId"]
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
    next if issue["message"]["text"] =~ /Type `\(.* \| nil\)` does not have method `.*`/
    next if issue["message"]["text"] =~ /Cannot pass a value of type `\((.*) \| nil\)` as an argument of type `\1`/i
    next if issue["message"]["text"] =~ /Cannot pass a value of type `\((.*) \| nil\)` as an argument of type `\(\1 \| .*\)`/i
    next if issue["message"]["text"] =~ /Cannot pass a value of type `\((.*) \| nil\)` as an argument of type `\(.* \| \1\)`/i
    next if issue["message"]["text"] =~ /Cannot pass a value of type `\((.*) \| nil\)` as an argument of type `\(.* \| \1 \| .*\)`/i
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
    output.write(JSON.pretty_generate(full_json))
    print "Found #{$issues.size} issues!"
  end
end