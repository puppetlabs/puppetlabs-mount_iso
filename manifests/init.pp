# == Define: mount_iso
#
# Mount ISO for Windows
#
# === Parameters
#
# Document parameters here.
#
# [*source*]
#   Location of the ISO you want mounted
# [*drive_letter*]
#   The drive letter you would like it mapped to
#
# === Examples
#
#  mount_iso { 'c:\mySystemRequired.iso':
#    drive_letter => 'H'
#  }
#
# === Authors
#
# Travis Fields
#
define mount_iso ($drive_letter, $source = $title){

  if $::osfamily != 'windows' { fail('Unsupported OS') }
  validate_re($drive_letter, '^[a-zA-Z]$', 'Drive letter must only be a single character')
  validate_absolute_path($source)

  exec{ "Mount-Iso-${source}":
    provider => powershell,
    command  => "Mount-DiskImage -ImagePath '${source}'",
    onlyif   => "if ( (Get-DiskImage -ImagePath '${source}').Attached ){ exit 1 } else { exit 0 }",
    before   => Exec["Change-Mount-Letter-${drive_letter}"],
  }

  exec{ "Change-Mount-Letter-${drive_letter}":
    provider => powershell,
    command  => "gwmi win32_volume -Filter \"Label = '\$((Get-DiskImage -ImagePath '${source}' | Get-Volume).FileSystemLabel)'\" | swmi -Arguments @{DriveLetter=\"${drive_letter}:\"}",
    onlyif   => "if((Get-DiskImage '${source}' | Get-Volume).DriveLetter -ieq '${drive_letter}' ){ exit 1 } exit 0",
  }

}
