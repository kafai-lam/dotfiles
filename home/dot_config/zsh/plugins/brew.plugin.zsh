export HOMEBREW_BUNDLE_FILE_GLOBAL="$XDG_CONFIG_HOME/homebrew/Brewfile"

function brew-dump() {
  if [[ -f $HOMEBREW_BUNDLE_FILE_GLOBAL.local ]]; then
    brew bundle dump --no-vscode --no-restart --no-describe --file=- \
    | grep -E "$(brew leaves | xargs printf '%s|')tap|cask" \
    | grep -Fvx -f $HOMEBREW_BUNDLE_FILE_GLOBAL.local \
    > $HOMEBREW_BUNDLE_FILE_GLOBAL
  else
    brew bundle dump --no-vscode --no-restart --no-describe --file=- \
    | grep -E "$(brew leaves | xargs printf '%s|')tap|cask" \
    > $HOMEBREW_BUNDLE_FILE_GLOBAL
  fi
}

function brew-deps() {
  local formulae="$(brew leaves | xargs brew deps --installed --for-each)"
  local casks="$(brew list --cask 2>/dev/null)"

  local blue="$(tput setaf 4)"
  local bold="$(tput bold)"
  local off="$(tput sgr0)"

  echo "${blue}==>${off} ${bold}Formulae${off}"
  echo "${formulae}" | sed "s/^\(.*\):\(.*\)$/\1${blue}\2${off}/"
  echo "\n${blue}==>${off} ${bold}Casks${off}\n${casks}"
}

function brew-recent() {
  local formulae_requested=0
  local cask_requested=0
  local force_refresh=0
  local -a positional_args=()
  local arg

  while (( $# )); do
    arg="$1"
    shift
    case "$arg" in
      --formula)
        formulae_requested=1
        ;;
      --cask)
        cask_requested=1
        ;;
      --refresh)
        force_refresh=1
        ;;
      --)
        positional_args+=("$@")
        break
        ;;
      -*)
        echo >&2 "Error: unknown option: $arg"
        echo >&2 'Usage: brew-recent [--formula] [--cask] [--refresh] [<git date expression>]'
        return 2
        ;;
      *)
        positional_args+=("$arg")
        ;;
    esac
  done

  if (( ${#positional_args} > 1 )); then
    echo >&2 'Usage: brew-recent [--formula] [--cask] [--refresh] [<git date expression>]'
    return 2
  fi

  local include_formulae=1
  local include_casks=1
  if (( formulae_requested || cask_requested )); then
    include_formulae=$formulae_requested
    include_casks=$cask_requested
  fi

  local since="${positional_args[1]:-3 days ago}"
  local command_name
  for command_name in brew git jq ruby try-rs gum open; do
    if (( ! $+commands[$command_name] )); then
      echo >&2 "Error: required command not found: $command_name"
      return 127
    fi
  done

  local now="$(date +%s)"
  local max_age="$(git rev-parse --since="$since" 2>/dev/null)"
  local cutoff="${max_age#--max-age=}"

  if [[ $cutoff != <-> || $cutoff -ge $now ]]; then
    echo >&2 "Error: interval must resolve to a past Git date: $since"
    return 2
  fi

  if (( ! $+functions[_try_rs_get_tries_path] )); then
    echo >&2 'Error: try-rs shell integration is not loaded'
    return 1
  fi

  local tries_path="$(_try_rs_get_tries_path)"
  tries_path="${tries_path/#\~/$HOME}"
  local -a kinds names urls repos refs bases ruby_args
  (( include_formulae )) && {
    kinds+=(formula)
    names+=(homebrew-core)
    urls+=(https://github.com/Homebrew/homebrew-core.git)
  }
  (( include_casks )) && {
    kinds+=(cask)
    names+=(homebrew-cask)
    urls+=(https://github.com/Homebrew/homebrew-cask.git)
  }

  local cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/brew-recent"
  command mkdir -p "$cache_root" || {
    echo >&2 "Error: could not create cache directory: $cache_root"
    return 1
  }

  local index kind name url repo origin default_branch ref base
  local marker refreshed_at
  local -a refresh_indices refresh_pids refresh_markers

  for (( index = 1; index <= ${#names}; index++ )); do
    kind="${kinds[$index]}"
    name="${names[$index]}"
    url="${urls[$index]}"
    repo="$tries_path/$name"

    if [[ ! -e $repo ]]; then
      command try-rs "$url" "$name" >/dev/null 2>&1 || {
        echo >&2 "Error: failed to clone $url"
        return 1
      }
    fi

    if [[ ! -d $repo/.git ]]; then
      echo >&2 "Error: $repo is not a Git repository"
      return 1
    fi

    origin="$(git -C "$repo" remote get-url origin 2>/dev/null)" || {
      echo >&2 "Error: $repo has no origin remote"
      return 1
    }
    if [[ $origin != "https://github.com/Homebrew/$name"(|.git) &&
          $origin != "git@github.com:Homebrew/$name"(|.git) &&
          $origin != "ssh://git@github.com/Homebrew/$name"(|.git) ]]; then
      echo >&2 "Error: unexpected origin for $repo: $origin"
      return 1
    fi

    default_branch="$(git -C "$repo" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)"
    default_branch="${default_branch#origin/}"
    if [[ -z $default_branch ]]; then
      echo >&2 "Error: could not determine the default branch for $name"
      return 1
    fi

    ref="refs/remotes/origin/$default_branch"
    repos[$index]="$repo"
    refs[$index]="$ref"

    marker="$cache_root/$name-refreshed-at"
    refreshed_at=''
    [[ -f $marker ]] && refreshed_at="$(<$marker)"
    if (( force_refresh )) || [[ $refreshed_at != <-> ]] ||
       (( refreshed_at > now || now - refreshed_at >= 3600 )) ||
       ! git -C "$repo" show-ref --verify --quiet "$ref"; then
      refresh_indices+=($index)
      refresh_markers+=($marker)
    fi
  done

  local refresh_index refresh_pid
  for refresh_index in "${refresh_indices[@]}"; do
    repo="${repos[$refresh_index]}"
    ref="${refs[$refresh_index]}"
    default_branch="${ref#refs/remotes/origin/}"
    git -C "$repo" fetch --quiet --prune origin \
      "+refs/heads/$default_branch:$ref" >/dev/null 2>&1 &
    refresh_pids+=($!)
  done

  local refresh_failed=0
  for (( index = 1; index <= ${#refresh_pids}; index++ )); do
    refresh_index="${refresh_indices[$index]}"
    refresh_pid="${refresh_pids[$index]}"
    if wait "$refresh_pid"; then
      print -r -- "$now" >| "${refresh_markers[$index]}"
    elif git -C "${repos[$refresh_index]}" show-ref --verify --quiet "${refs[$refresh_index]}"; then
      echo >&2 "Warning: failed to refresh ${names[$refresh_index]}; using stale data"
    else
      echo >&2 "Error: failed to refresh ${names[$refresh_index]} and no local data is available"
      refresh_failed=1
    fi
  done
  (( refresh_failed )) && return 1

  for (( index = 1; index <= ${#names}; index++ )); do
    name="${names[$index]}"
    repo="${repos[$index]}"
    ref="${refs[$index]}"
    default_branch="${ref#refs/remotes/origin/}"

    while true; do
      base="$(git -C "$repo" rev-list -1 --before="@$cutoff" "$ref")"
      [[ -n $base ]] && break

      if [[ $(git -C "$repo" rev-parse --is-shallow-repository) == false ]]; then
        echo >&2 "Error: interval predates the $name repository: $since"
        return 1
      fi

      git -C "$repo" fetch --quiet --deepen=5000 origin \
        "+refs/heads/$default_branch:$ref" || {
        echo >&2 "Error: failed to deepen $name history"
        return 1
      }
    done

    bases[$index]="$base"
  done

  for (( index = 1; index <= ${#names}; index++ )); do
    ruby_args+=("${kinds[$index]}" "${repos[$index]}" "${bases[$index]}" "${refs[$index]}")
  done

  local result
  result="$(
    BREW_RECENT_CUTOFF="$cutoff" command ruby - \
      "${ruby_args[@]}" <<'RUBY'
require "json"
require "open3"
require "set"

Repo = Struct.new(:kind, :path, :base, :ref, :prefix, :rename_file, :migrations_file)
Record = Struct.new(:kind, :name, :path, :epoch, :description, :homepage)

def capture!(*command, stdin_data: nil)
  stdout, stderr, status = Open3.capture3(*command, stdin_data: stdin_data)
  raise stderr.strip unless status.success?

  stdout
end

def metadata(repo, file)
  contents, = Open3.capture2("git", "-C", repo.path, "show", "#{repo.ref}:#{file}")
  contents.empty? ? {} : JSON.parse(contents)
rescue JSON::ParserError
  {}
end

def token(path)
  File.basename(path, ".rb")
end

def additions(repo)
  output = capture!(
    "git", "-C", repo.path, "diff-tree", "-r", "--name-status",
    "--diff-filter=AMDR", "-M85%", repo.base, repo.ref
  )

  added = {}
  deleted = Set.new

  output.each_line do |line|
    status, source, destination = line.chomp.split("\t")
    paths = destination ? [source, destination] : [source]
    next unless paths.any? { |path| path&.start_with?(repo.prefix) && path.end_with?(".rb") }

    case status
    when "A"
      added[token(source)] = source
    when "D"
      deleted << token(source)
    when /^R/
      old_name = token(source)
      new_name = token(destination)
      next if old_name == new_name

      deleted << old_name
      added[new_name] = destination
    end
  end

  renamed_targets = metadata(repo, repo.rename_file).values.to_set
  migration_sources = repo.migrations_file ? metadata(repo, repo.migrations_file).keys.to_set : Set.new
  added.reject do |name, _path|
    deleted.include?(name) || renamed_targets.include?(name) || migration_sources.include?(name)
  end
end

def introductions(repo)
  output = capture!(
    "git", "-C", repo.path, "log",
    "--format=commit:%ct", "--name-status", "--diff-filter=AR", "-M85%",
    "#{repo.base}..#{repo.ref}", "--", repo.prefix
  )

  result = {}
  epoch = nil
  output.each_line do |line|
    line = line.chomp
    if line.start_with?("commit:")
      epoch = line.delete_prefix("commit:").to_i
      next
    end
    next if epoch.nil? || line.empty?

    status, source, destination = line.split("\t")
    next unless status == "A" || status.start_with?("R")

    result[destination || source] ||= epoch
  end
  result
end

def source_literal(source, key)
  match = source.match(/^\s*#{Regexp.escape(key)}\s+(?<literal>"(?:\\.|[^"])*")/)
  return unless match

  literal = match[:literal]
  return if literal.include?('#{')

  literal.gsub(/[^\x00-\x7F]/) { |character| "\\u{#{character.ord.to_s(16)}}" }.undump
end

def repository_metadata(repo, path)
  source = capture!("git", "-C", repo.path, "show", "#{repo.ref}:#{path}")
  {
    "description" => source_literal(source, "desc"),
    "homepage" => source_literal(source, "homepage"),
  }
end

def details(repo, records)
  result = {}
  fetch = lambda do |batch|
    json, stderr, status = Open3.capture3(
      { "HOMEBREW_NO_AUTO_UPDATE" => "1" },
      "brew", "info", "--json=v2", "--#{repo.kind}", *batch.map(&:name)
    )

    if status.success?
      key = repo.kind == "formula" ? "formulae" : "casks"
      name_key = repo.kind == "formula" ? "name" : "token"
      lines = capture!(
        "jq", "-c",
        ".#{key}[] | {name: .#{name_key}, description: (.desc // \"(no description)\"), homepage: (.homepage // null)}",
        stdin_data: json
      )
      lines.each_line do |line|
        item = JSON.parse(line)
        result[item.fetch("name")] = {
          "description" => item.fetch("description"),
          "homepage" => item["homepage"],
        }
      end
    elsif stderr.match?(/No available (formula|cask)/) && batch.length > 1
      midpoint = batch.length / 2
      fetch.call(batch.take(midpoint))
      fetch.call(batch.drop(midpoint))
    elsif stderr.match?(/No available (formula|cask)/)
      record = batch.first
      result[record.name] = repository_metadata(repo, record.path)
    else
      raise stderr.strip
    end
  end

  records.each_slice(100) { |batch| fetch.call(batch) }
  result
end

raise "invalid repository arguments" unless ARGV.length.positive? && (ARGV.length % 4).zero?

repos = ARGV.each_slice(4).map do |kind, path, base, ref|
  case kind
  when "formula"
    Repo.new(kind, path, base, ref, "Formula/", "formula_renames.json", "tap_migrations.json")
  when "cask"
    Repo.new(kind, path, base, ref, "Casks/", "cask_renames.json", nil)
  else
    raise "invalid repository kind: #{kind}"
  end
end
records = []

cutoff = ENV.fetch("BREW_RECENT_CUTOFF").to_i
repos.each do |repo|
  added = additions(repo)
  next if added.empty?

  introduced_at = introductions(repo)
  added.each do |name, path|
    epoch = introduced_at.fetch(path) { raise "could not find introduction commit for #{path}" }
    next if epoch < cutoff

    records << Record.new(repo.kind, name, path, epoch)
  end
end

details_by_kind = repos.to_h do |repo|
  grouped = records.select { |record| record.kind == repo.kind }
  [repo.kind, Thread.new { details(repo, grouped) }]
end

repos.each do |repo|
  detail_by_name = details_by_kind.fetch(repo.kind).value
  records.select { |record| record.kind == repo.kind }.each do |record|
    detail = detail_by_name.fetch(record.name, {})
    fallback = if detail["homepage"].to_s.empty? || detail["description"] == "(no description)"
                 repository_metadata(repo, record.path)
               else
                 {}
               end
    record.description = detail["description"] || fallback["description"] || "(no description)"
    record.homepage = if detail["homepage"].to_s.empty?
                       fallback["homepage"]
                     else
                       detail["homepage"]
                     end
  end
end

ordered_records = repos.flat_map do |repo|
  records.select { |record| record.kind == repo.kind }.sort_by { |record| -record.epoch }
end

puts JSON.generate(
  "records" => ordered_records.each_with_index.map do |record, index|
    {
      "index" => index,
      "kind" => record.kind,
      "name" => record.name,
      "description" => record.description,
      "homepage" => record.homepage,
    }
  end
)
RUBY
  )"
  local ruby_status=$?
  if (( ruby_status != 0 )); then
    return "$ruby_status"
  fi

  local scope_label
  if (( include_formulae && include_casks )); then
    scope_label='formulae or casks'
  elif (( include_formulae )); then
    scope_label='formulae'
  else
    scope_label='casks'
  fi

  if [[ ! -t 0 || ! -t 1 ]]; then
    echo >&2 'Error: brew-recent requires an interactive terminal'
    return 1
  fi

  local record_count
  if ! record_count="$(command jq -r '.records | length' <<<"$result")"; then
    echo >&2 'Error: could not read recent Homebrew records'
    return 1
  fi
  if (( record_count == 0 )); then
    echo "No new $scope_label since $since."
    return 0
  fi

  local choices choose_status=0
  choices="$(
    command jq -r '
      .records[] as $record
      | ($record.name + " — "
         + ($record.description | gsub("[\t\r\n]"; " ")))
        + "\t" + ($record | @json)
    ' <<<"$result" |
      command gum choose --no-limit --label-delimiter=$'\t' \
        --header='Select recent Homebrew packages'
  )" || choose_status=$?
  if (( choose_status != 0 )); then
    if (( choose_status == 1 || choose_status == 130 )); then
      return 0
    fi
    echo >&2 'Error: gum choose failed'
    return "$choose_status"
  fi
  [[ -z $choices ]] && return 0

  local selected_json
  if ! selected_json="$(printf '%s\n' "$choices" | command jq -s 'sort_by(.index)')"; then
    echo >&2 'Error: could not read the selected Homebrew records'
    return 1
  fi

  local selected_count selected_summary confirm_prompt confirm_status=0
  selected_count="$(command jq -r 'length' <<<"$selected_json")"
  selected_summary="$(command jq -r '
    map(.name) | join(", ")
  ' <<<"$selected_json")"
  confirm_prompt="Open $selected_count Homebrew homepage"
  (( selected_count != 1 )) && confirm_prompt+='s'
  confirm_prompt+="? $selected_summary"

  command gum confirm "$confirm_prompt" || confirm_status=$?
  if (( confirm_status != 0 )); then
    if (( confirm_status == 1 || confirm_status == 130 )); then
      return 0
    fi
    echo >&2 'Error: gum confirm failed'
    return "$confirm_status"
  fi

  local open_failed=0
  local selected_record selected_kind selected_name selected_homepage fallback_flag
  while IFS= read -r selected_record; do
    selected_kind="$(command jq -r '.kind' <<<"$selected_record")"
    selected_name="$(command jq -r '.name' <<<"$selected_record")"
    selected_homepage="$(command jq -r '.homepage // empty' <<<"$selected_record")"

    if [[ -n $selected_homepage ]]; then
      if ! command open "$selected_homepage"; then
        echo >&2 "Error: failed to open homepage for $selected_kind $selected_name"
        open_failed=1
      fi
      continue
    fi

    if [[ $selected_kind == formula ]]; then
      fallback_flag=--formula
    else
      fallback_flag=--cask
    fi
    if ! command brew home "$fallback_flag" "$selected_name"; then
      echo >&2 "Error: failed to open homepage for $selected_kind $selected_name"
      open_failed=1
    fi
  done < <(command jq -c '.[]' <<<"$selected_json")

  return "$open_failed"
}
