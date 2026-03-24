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

    # Check npm auth
    set -l npm_user (npm whoami 2>/dev/null)
    if test $status -ne 0
        echo $red"Not logged in to npm. Run 'npm login' first."$reset
        return 1
    end
    echo $green"Logged in to npm as $bold$npm_user"$reset

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

    # Resolve all packages in parallel: output "pkg\towner/repo" lines
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
    if test (count $unmapped) -gt 0
        echo $yellow"Packages with no repository URL in npm registry:"$reset
        for pkg in $unmapped
            echo "  $dim$pkg$reset"
        end
        echo
        echo "Add missing mappings as '$cyan""owner/repo$reset $magenta@scope1$reset $magenta""pkg1$reset ...' (blank line to finish):"
        while true
            read -P "$cyan> $reset" -l mapping
            if test -z "$mapping"
                break
            end
            set -l parts (string split ' ' $mapping)
            set -l repo $parts[1]
            for pkg in $parts[2..]
                # If it's a scope, add all unmapped packages under that scope
                if string match -q '@*' $pkg; and not string match -q '*/*' $pkg
                    for upkg in $unmapped
                        if string match -q "$pkg/*" $upkg
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
                    # Specific package
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

    # For each repo, extract scopes and unscoped packages
    # scope_map stores "repo:pkg1,pkg2,..." for the token creation phase
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
    echo $dim"Tokens will be printed so you can save them to Bitwarden."$reset
    echo

    # Build unique token groups: "scopes|packages" -> repos
    set -l token_groups # "scopes|packages"
    set -l group_repos  # "repo1,repo2"

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

        # Find or create group
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

        set -l token_args --bypass-2fa --expires $expires

        if test -n "$scopes_str"
            set -l scopes (string split ',' $scopes_str)
            echo "Scopes: $magenta"(string join "$reset, $magenta" $scopes)$reset
            for scope in $scopes
                set -a token_args --scopes $scope
            end
        end

        if test -n "$pkgs_str"
            set -l pkgs (string split ',' $pkgs_str)
            echo "Packages: $cyan"(string join "$reset, $cyan" $pkgs)$reset
            for pkg in $pkgs
                set -a token_args --packages $pkg
            end
        end

        if test -z "$scopes_str" -a -z "$pkgs_str"
            echo $yellow"No scopes or packages detected. Skipping."$reset
            echo $dim"  (Set NPM_TOKEN manually for: "(string join ', ' $repos_in_group)")"$reset
            echo
            continue
        end

        set -a token_args --packages-and-scopes-permission read-write

        set -l token_name "gh-"(string join '-' $repos_in_group | string replace -a '/' '-')
        # Truncate name if too long
        if test (string length $token_name) -gt 50
            set token_name (string sub -l 47 $token_name)"..."
        end
        set -a token_args --name $token_name

        echo
        echo $dim"Will run: npm token create $token_args"$reset
        echo

        read -P "Create this token? ["$bold"Y"$reset"/n/s(kip)/e(dit)] " -l confirm
        switch (string lower $confirm)
            case '' y yes
                # Create the token
            case s skip
                echo $yellow"Skipped."$reset
                echo
                continue
            case e edit
                echo "Enter custom npm token create arguments (space-separated):"
                echo $dim"  (base: --bypass-2fa --expires $expires)"$reset
                read -P "$cyan> $reset" -l custom_args
                set token_args --bypass-2fa --expires $expires (string split ' ' $custom_args)
            case '*'
                echo $yellow"Skipped."$reset
                echo
                continue
        end

        # Run npm token create interactively so password/OTP prompts work
        # Retry on 401 (wrong password)
        while true
            echo $dim"Creating token (follow npm prompts)..."$reset
            echo
            npm token create $token_args
            set -l npm_status $status

            if test $npm_status -ne 0
                echo
                read -P $red"Retry?"$reset" ["$bold"Y"$reset"/n/s(kip)] " -l retry_confirm
                switch (string lower $retry_confirm)
                    case '' y yes
                        continue
                    case '*'
                        break
                end
            end
            break
        end

        echo
        echo "Paste the token value from above (or press Enter to skip):"
        read -P $cyan"Token: "$reset -l token

        if test -z "$token"
            echo $yellow"Skipped."$reset
            echo
            continue
        end

        echo
        echo $bold$yellow"======================================"$reset
        echo $bold$yellow"  SAVE THIS TOKEN TO BITWARDEN"$reset
        echo $yellow"  Name:    $reset$token_name"
        echo $yellow"  Token:   $reset$token"
        echo $yellow"  Expires: $reset$expires days from now"
        echo $bold$yellow"======================================"$reset
        echo

        read -P "Set this token on repos? ["$bold"Y"$reset"/n] " -l set_confirm
        switch (string lower $set_confirm)
            case '' y yes
                for repo in $repos_in_group
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

    echo $green$bold"All done!"$reset
end
