function filenametoexif -d "Overwrite exif dates from filename in a directory, so long as the existing exif year is 1800"
  argparse 'n/dry-run' 'v/verbose' 'm/match-on-name' 't/tag=?' -- $argv
  set -q _flag_t; or set -l _flag_t "DateTimeOriginal"

  for f in $argv
    if set -q _flag_m
      ___fn2exif__write__ $_flag_n $_flag_v --tag="$_flag_t" $f
      continue
    end

    # Get the EXIF date
    set -l OLDDATE (exiftool "-$_flag_t" $f | awk -F' : ' '{print $2}')

    if test -z $OLDDATE
      set -l _flag_t "CreateDate"
      set OLDDATE (exiftool "-$_flag_t" $f | awk -F' : ' '{print $2}')
    end
    set -l OLDYEAR (echo $OLDDATE | cut -d: -f 1)

    if test -z $OLDYEAR
      test (count $_flag_v) -gt 1 and; echo "Could not find date for $f"
      ___fn2exif__write__ $_flag_n $_flag_v --tag="$_flag_t" $f
      continue
    end

    if test $OLDYEAR -eq 1800
      ___fn2exif__write__ $_flag_n $_flag_v --tag="$_flag_t" --old-date="$OLDDATE" $f
    else if test (count $_flag_v) -gt 1
      echo "$f: $(set_color yellow)SKIP$(set_color normal)"
    end
  end
end

function ___fn2exif__write__
  argparse 'n/dry-run' 'v/verbose' 'm/match-on-name' 'o/old-date=?' 't/tag=?' -- $argv
  set -l MATCH 'match($0, /(20[0-9]{6})/, a) {print a[1]}'
  set -l FORMAT "%Y:%m:%d %H:%M:%S"
  set -l NEWDATE (basename $argv | gawk $MATCH | xargs date +$FORMAT -d)
  set -l C_NEWDATE "$(set_color blue)$NEWDATE$(set_color normal)"
  set -l C_OLDDATE "$(set_color blue)$_flag_o$(set_color normal)"
  if set -q _flag_n
    set -l T "$(set_color yellow)WOULD WRITE$(set_color normal)"
    if set -q _flag_o
      set T "$(set_color yellow)WOULD OVERWRITE$(set_color normal) FROM $C_OLDDATE TO"
    end
    echo "$argv: $T $C_NEWDATE"
  else
    set -l T "$(set_color red)WRITING$(set_color normal)"
    if set -q _flag_o
      set T "$(set_color red)OVERWRITING$(set_color normal) FROM $C_OLDDATE TO"
    end
    if set -q _flag_v
      echo "$argv: $T $C_NEWDATE"
    end
    exiftool "-$_flag_t=$NEWDATE" $argv
  end
end

