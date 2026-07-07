function rotate-npm-tokens -d "Rotate NPM_TOKEN secrets across GitHub repos"
    set -l expires 90

    # Colors
    set -l dim (set_color brblack)
    set -l bold (set_color --bold)
    set -l green (set_color green)
    set -l yellow (set_color yellow)
    set -l red (set_color red)
    set -l cyan (set_color cyan)
    set -l magenta (set_color magenta)
    set -l reset (set_color normal)

    argparse 'h/help' 'repo=+' 'scopes=+' 'packages=+' -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: rotate-npm-tokens [--repo owner/repo ...] [--scopes @scope ...] [--packages pkg ...]"
        echo
        echo "Rotate NPM_TOKEN secrets across GitHub repos."
        echo
        echo "Without flags, runs full discovery mode."
        echo "With --repo, creates a token with the given scopes/packages and sets it on the repos."
        return 0
    end

    # Check npm auth
    set -l npm_user (npm whoami 2>/dev/null)
    if test $status -ne 0
        echo $red"Not logged in to npm. Run 'npm login' first."$reset
        return 1
    end
    echo $green"Logged in to npm as $bold$npm_user"$reset

    # Get auth token from .npmrc
    set -l auth_token (string match -r '(?<=//registry.npmjs.org/:_authToken=).+' < ~/.npmrc)
    if test -z "$auth_token"
        echo $red"No auth token found in ~/.npmrc"$reset
        return 1
    end

    # npm API requires password + OTP for token creation
    read -P $dim"npm password: "$reset -s -l npm_password
    or return 1
    echo
    set npm_password (string trim -- $npm_password)
    if test -z "$npm_password"
        echo $red"Password required."$reset
        return 1
    end
    read -P $dim"OTP: "$reset -l npm_otp
    or return 1
    set npm_otp (string trim -- $npm_otp)
    if test -z "$npm_otp"
        echo $red"OTP required."$reset
        return 1
    end

    if set -q _flag_repo
        # Direct mode
        set -l repos $_flag_repo

        echo $bold"Repos:"$reset
        for repo in $repos
            echo "  $cyan$repo$reset"
        end
        if set -q _flag_scopes
            echo $bold"Scopes:"$reset" $magenta"(string join "$reset, $magenta" $_flag_scopes)$reset
        end
        if set -q _flag_packages
            echo $bold"Packages:"$reset" $cyan"(string join "$reset, $cyan" $_flag_packages)$reset
        end

        set -l json_scopes '[]'
        set -l json_packages '[]'
        if set -q _flag_scopes
            set json_scopes (printf '%s\n' $_flag_scopes | jq -R . | jq -sc .)
        end
        if set -q _flag_packages
            set json_packages (printf '%s\n' $_flag_packages | jq -R . | jq -sc .)
        end

        set -l date_suffix "-"(date +%Y-%m-%d)
        set -l token_name "gh-"(string join '-' $repos | string replace -a '/' '-')$date_suffix
        if test (string length "$token_name") -gt 50
            set token_name (string sub -l 47 $token_name)"..."
        end

        set -l json_body (jq -nc \
            --arg name "$token_name" \
            --argjson expires $expires \
            --argjson scopes "$json_scopes" \
            --argjson packages "$json_packages" \
            '{name: $name, expires: $expires, bypass_2fa: true, packages_and_scopes_permission: "read-write"} | if ($scopes | length) > 0 then .scopes = $scopes else . end | if ($packages | length) > 0 then .packages = $packages else . end')

        echo $dim"Token: $token_name  Expires: "$expires"d  Bypass 2FA: yes"$reset

        _rotate_npm_tokens_create $expires $auth_token "$npm_password" "$npm_otp" $token_name "$json_body" $repos
    else
        _rotate_npm_tokens_discover $expires $auth_token "$npm_password" "$npm_otp"
    end
end

function _rotate_npm_tokens_create -d "Create token via npm API and set on repos"
    set -l expires $argv[1]
    set -l auth_token $argv[2]
    set -l npm_password $argv[3]
    set -l npm_otp $argv[4]
    set -l token_name $argv[5]
    set -l json_body_base $argv[6]
    set -l repos $argv[7..]

    # Add password to JSON body
    set -l json_body (echo "$json_body_base" | jq -c --arg pw "$npm_password" '. + {password: $pw}')

    # Colors
    set -l dim (set_color brblack)
    set -l bold (set_color --bold)
    set -l green (set_color green)
    set -l yellow (set_color yellow)
    set -l red (set_color red)
    set -l cyan (set_color cyan)
    set -l reset (set_color normal)

    echo
    read -P "Create this token? ["$bold"Y"$reset"/n/s(kip)] " -l confirm
    or return 1
    switch (string lower $confirm)
        case '' y yes
            # proceed
        case '*'
            echo $yellow"Skipped."$reset
            return 0
    end

    echo $dim"Creating token via npm API..."$reset

    set -l reqfile (mktemp)
    set -l respfile (mktemp)
    printf '%s' "$json_body" > "$reqfile"
    echo $dim"DEBUG request body:"$reset
    jq . "$reqfile" 2>/dev/null || cat "$reqfile"
    echo $dim"DEBUG end"$reset
    set -l http_code (curl -s -o "$respfile" -w '%{http_code}' \
        -X POST \
        -H "Authorization: Bearer $auth_token" \
        -H "Content-Type: application/json" \
        -H "npm-otp: $npm_otp" \
        --data-binary @"$reqfile" \
        "https://registry.npmjs.org/-/npm/v1/tokens")
    set -l body (cat "$respfile")
    rm -f "$reqfile" "$respfile"

    if test "$http_code" -ge 400 2>/dev/null
        echo $red"Token creation failed (HTTP $http_code)"$reset
        echo $dim"$body"$reset
        echo
        if test "$http_code" = 401 -o "$http_code" = 403
            echo $red"Auth failed. Check password, OTP, or auth token."$reset
            return 1
        end
        return 2
    end

    set -l token (echo "$body" | jq -r '.token // empty')
    if test -z "$token"
        echo $red"No token in response"$reset
        echo $dim"$body"$reset
        return 2
    end

    echo $green"Token created."$reset
    echo
    echo $bold$yellow"======================================"$reset
    echo $bold$yellow"  SAVE THIS TOKEN TO BITWARDEN"$reset
    echo $yellow"  Name:    $reset$token_name"
    echo $yellow"  Token:   $reset$token"
    echo $yellow"  Expires: $reset$expires days from now"
    echo $bold$yellow"======================================"$reset
    echo

    read -P "Set this token on repos? ["$bold"Y"$reset"/n] " -l set_confirm
    or return 1
    switch (string lower $set_confirm)
        case '' y yes
            for repo in $repos
                echo -n "  Setting NPM_TOKEN on $cyan$repo$reset... "
                echo $token | gh secret set NPM_TOKEN -R "$repo"
                if test $status -eq 0
                    echo $green"done"$reset
                else
                    echo $red"FAILED"$reset
                end
            end
        case '*'
            echo $yellow"Skipped setting secrets."$reset
    end
    echo
end

function _rotate_npm_tokens_discover -d "Discovery mode: find all repos and rotate tokens"
    set -l expires $argv[1]
    set -l auth_token $argv[2]
    set -l npm_password $argv[3]
    set -l npm_otp $argv[4]

    # Colors
    set -l dim (set_color brblack)
    set -l bold (set_color --bold)
    set -l green (set_color green)
    set -l yellow (set_color yellow)
    set -l red (set_color red)
    set -l cyan (set_color cyan)
    set -l magenta (set_color magenta)
    set -l reset (set_color normal)

    # Step 1: Fetch all packages we can publish
    echo $dim"Fetching publish permissions..."$reset
    set -l npm_output (npm access list packages --json 2>&1)
    if test $status -ne 0
        echo $red"Failed to fetch npm access list."$reset
        echo $npm_output
        return 1
    end

    set -l npm_packages (echo $npm_output | jq -r 'to_entries[] | select(.value == "read-write") | .key')
    if test (count $npm_packages) -eq 0
        echo $red"No packages with read-write access found."$reset
        return 1
    end
    echo $green"Found $bold"(count $npm_packages)"$reset$green publishable packages."$reset

    # Step 2: Look up repository URL for each package in parallel
    echo $dim"Resolving package repositories..."$reset
    set -l tmpdir (mktemp -d)

    printf '%s\n' $npm_packages | xargs -P 20 -I {} sh -c '
        url=$(npm view {} repository.url --json 2>/dev/null | jq -r ". // empty" 2>/dev/null)
        if [ -n "$url" ]; then
            repo=$(echo "$url" | sed -E "s|.*github\.com[:/]||;s|\.git$||")
            if [ -n "$repo" ]; then
                printf "%s\t%s\n" "{}" "$repo"
            fi
        fi
    ' > "$tmpdir/pkg-repos.tsv"

    # Build repo -> packages map from results
    set -l repo_keys
    set -l repo_pkgs

    while read -l pkg repo
        if test -z "$repo"
            continue
        end
        set -l found 0
        for i in (seq (count $repo_keys))
            if test "$repo_keys[$i]" = "$repo"
                set repo_pkgs[$i] "$repo_pkgs[$i],$pkg"
                set found 1
                break
            end
        end
        if test $found -eq 0
            set -a repo_keys "$repo"
            set -a repo_pkgs "$pkg"
        end
    end < "$tmpdir/pkg-repos.tsv"

    rm -rf $tmpdir

    # Load cached manual mappings from XDG cache
    set -l cache_dir (set -q XDG_CACHE_HOME; and echo $XDG_CACHE_HOME; or echo ~/.cache)
    set -l cache_file "$cache_dir/rotate-npm-tokens/pkg-repo-mappings.tsv"

    if test -f "$cache_file"
        while read -l line
            test -z "$line"; and continue
            string match -q '#*' "$line"; and continue
            set -l parts (string split \t $line)
            set -l pkg $parts[1]
            set -l repo $parts[2]
            test -z "$pkg" -o -z "$repo"; and continue
            if contains $pkg $npm_packages
                set -l found 0
                for i in (seq (count $repo_keys))
                    if test "$repo_keys[$i]" = "$repo"
                        if not string match -q "*$pkg*" "$repo_pkgs[$i]"
                            set repo_pkgs[$i] "$repo_pkgs[$i],$pkg"
                        end
                        set found 1
                        break
                    end
                end
                if test $found -eq 0
                    set -a repo_keys "$repo"
                    set -a repo_pkgs "$pkg"
                end
            end
        end < "$cache_file"
    end

    # Report packages with no repository URL
    set -l mapped_pkgs
    for pkgs in $repo_pkgs
        for pkg in (string split ',' $pkgs)
            set -a mapped_pkgs $pkg
        end
    end
    set -l unmapped
    for pkg in $npm_packages
        if not contains $pkg $mapped_pkgs
            set -a unmapped $pkg
        end
    end
    set -l new_mappings
    if test (count $unmapped) -gt 0
        echo $yellow"Packages with no repository URL in npm registry:"$reset
        for pkg in $unmapped
            echo "  $dim$pkg$reset"
        end
        echo
        echo "Add missing mappings as '$cyan""owner/repo$reset $magenta@scope1$reset $magenta""pkg1$reset ...' (blank line to finish):"
        while true
            read -P "$cyan> $reset" -l mapping
            or return 1
            if test -z "$mapping"
                break
            end
            set -l parts (string split ' ' $mapping)
            set -l repo $parts[1]
            for pkg in $parts[2..]
                if string match -q '@*' $pkg; and not string match -q '*/*' $pkg
                    for upkg in $unmapped
                        if string match -q "$pkg/*" $upkg
                            set -a new_mappings "$upkg\t$repo"
                            set -l found 0
                            for i in (seq (count $repo_keys))
                                if test "$repo_keys[$i]" = "$repo"
                                    set repo_pkgs[$i] "$repo_pkgs[$i],$upkg"
                                    set found 1
                                    break
                                end
                            end
                            if test $found -eq 0
                                set -a repo_keys "$repo"
                                set -a repo_pkgs "$upkg"
                            end
                        end
                    end
                else
                    set -a new_mappings "$pkg\t$repo"
                    set -l found 0
                    for i in (seq (count $repo_keys))
                        if test "$repo_keys[$i]" = "$repo"
                            set repo_pkgs[$i] "$repo_pkgs[$i],$pkg"
                            set found 1
                            break
                        end
                    end
                    if test $found -eq 0
                        set -a repo_keys "$repo"
                        set -a repo_pkgs "$pkg"
                    end
                end
            end
        end

        if test (count $new_mappings) -gt 0
            mkdir -p (dirname $cache_file)
            for entry in $new_mappings
                echo -e $entry >> "$cache_file"
            end
            echo $dim"Cached "(count $new_mappings)" mapping(s) to $cache_file"$reset
        end
    end

    echo $green"Mapped packages to $bold"(count $repo_keys)"$reset$green repositories."$reset
    echo

    # Step 3: Check which repos have NPM_TOKEN secrets (parallel)
    echo $dim"Checking for NPM_TOKEN secrets..."$reset
    set -l active_repos
    set -l active_pkgs

    printf '%s\n' $repo_keys | xargs -P 10 -I {} sh -c '
        gh secret list -R "{}" 2>/dev/null | grep -q NPM_TOKEN && echo "{}"
    ' | while read -l repo
        for i in (seq (count $repo_keys))
            if test "$repo_keys[$i]" = "$repo"
                set -a active_repos $repo
                set -a active_pkgs $repo_pkgs[$i]
                echo "  $green$repo$reset"
                break
            end
        end
    end

    if test (count $active_repos) -eq 0
        echo $red"No repos with NPM_TOKEN secret found."$reset
        return 1
    end

    echo
    echo $bold"=== Summary ===""$reset"
    echo

    set -l scope_map
    for i in (seq (count $active_repos))
        set -l repo $active_repos[$i]
        set -l pkgs (string split ',' $active_pkgs[$i])

        set -l scopes
        set -l unscoped

        for pkg in $pkgs
            if string match -q '@*' $pkg
                set -l scope (string replace -r '/.*' '' $pkg)
                if not contains $scope $scopes
                    set -a scopes $scope
                end
            else
                set -a unscoped $pkg
            end
        end

        echo $bold"$repo"$reset":"
        if test (count $scopes) -gt 0
            echo "  scopes:   $magenta"(string join "$reset, $magenta" $scopes)$reset
        end
        if test (count $unscoped) -gt 0
            echo "  packages: $cyan"(string join "$reset, $cyan" $unscoped)$reset
        end

        set -a scope_map "$repo:$active_pkgs[$i]"
    end

    echo
    echo $bold"=== Token Creation ===""$reset"
    echo $dim"Each unique combination of scopes/packages needs its own token."$reset
    echo

    # Build unique token groups
    set -l token_groups
    set -l group_repos

    for entry in $scope_map
        set -l parts (string split ':' $entry)
        set -l repo $parts[1]
        set -l pkgs_str $parts[2]

        set -l scopes
        set -l unscoped

        for pkg in (string split ',' $pkgs_str)
            if string match -q '@*' $pkg
                set -l scope (string replace -r '/.*' '' $pkg)
                if not contains $scope $scopes
                    set -a scopes $scope
                end
            else if test -n "$pkg"
                set -a unscoped $pkg
            end
        end

        set -l scope_key (string join ',' (printf '%s\n' $scopes | sort))
        set -l pkg_key (string join ',' (printf '%s\n' $unscoped | sort))
        set -l group_key "$scope_key|$pkg_key"

        set -l found 0
        for i in (seq (count $token_groups))
            if test "$token_groups[$i]" = "$group_key"
                set group_repos[$i] "$group_repos[$i],$repo"
                set found 1
                break
            end
        end
        if test $found -eq 0
            set -a token_groups "$group_key"
            set -a group_repos "$repo"
        end
    end

    # Process each group
    for i in (seq (count $token_groups))
        set -l group_key $token_groups[$i]
        set -l repos_in_group (string split ',' $group_repos[$i])
        set -l parts (string split '|' $group_key)
        set -l scopes_str $parts[1]
        set -l pkgs_str $parts[2]

        echo $bold"--- Token Group $i ---"$reset
        echo "Repos:"
        for repo in $repos_in_group
            echo "  $cyan$repo$reset"
        end

        set -l json_scopes '[]'
        set -l json_packages '[]'

        if test -n "$scopes_str"
            set -l scopes (string split ',' $scopes_str)
            echo "Scopes: $magenta"(string join "$reset, $magenta" $scopes)$reset
            set json_scopes (printf '%s\n' $scopes | jq -R . | jq -sc .)
        end

        if test -n "$pkgs_str"
            set -l pkgs (string split ',' $pkgs_str)
            echo "Packages: $cyan"(string join "$reset, $cyan" $pkgs)$reset
            set json_packages (printf '%s\n' $pkgs | jq -R . | jq -sc .)
        end

        if test -z "$scopes_str" -a -z "$pkgs_str"
            echo $yellow"No scopes or packages detected. Skipping."$reset
            echo $dim"  (Set NPM_TOKEN manually for: "(string join ', ' $repos_in_group)")"$reset
            echo
            continue
        end

        set -l date_suffix "-"(date +%Y-%m-%d)
        set -l token_name "gh-"(string join '-' $repos_in_group | string replace -a '/' '-')$date_suffix
        if test (string length "$token_name") -gt 50
            set token_name (string sub -l 47 $token_name)"..."
        end

        set -l json_body (jq -nc \
            --arg name "$token_name" \
            --argjson expires $expires \
            --argjson scopes "$json_scopes" \
            --argjson packages "$json_packages" \
            '{name: $name, expires: $expires, bypass_2fa: true, packages_and_scopes_permission: "read-write"} | if ($scopes | length) > 0 then .scopes = $scopes else . end | if ($packages | length) > 0 then .packages = $packages else . end')

        echo $dim"Token: $token_name  Expires: "$expires"d  Bypass 2FA: yes"$reset

        _rotate_npm_tokens_create $expires $auth_token "$npm_password" "$npm_otp" $token_name "$json_body" $repos_in_group
        or return $status
    end

    echo $green$bold"All done!"$reset
end
