function jspm-build -d "Request a build from JSPM"
  set -f pkg "$argv[1]"
  if set -q argv[2]
    set -f pkg_version $argv[2]
   else
    set -f pkg_version (npm info $pkg version)
  end
  if set -q JSPM_IO_TOKEN
    set -f url "https://api.jspm.io/build/$pkg@$pkg_version?token=$JSPM_IO_TOKEN"
  else
    set -f url "https://api.jspm.io/build/$pkg@$pkg_version"
  end
  set -f response (curl -s $url)
  set -f error (echo "$response" | jq -r ".error")
  if set -q error
    echo $error
    return 1
  else
    echo $response
  end
end
