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
define mount_iso (
  Pattern[/^[a-zA-Z]$/]  $drive_letter,
  Optional[Stdlib::Absolutepath] $source = $title
){

  if $::osfamily != 'windows' { fail('Unsupported OS') }

  exec{ "Mount-Iso-${source}":
    provider => powershell,
    command  => "Mount-DiskImage -ImagePath '${source}' -ErrorAction 'Stop'",
    onlyif   => "if ( (Get-DiskImage -ImagePath '${source}').Attached ){ exit 1 } else { exit 0 }",
    before   => Exec["Change-Mount-Letter-${drive_letter}"],
  }

  exec{ "Change-Mount-Letter-${drive_letter}":
    provider => powershell,
    command  => "gwmi win32_volume -Filter \"Label = '\$((Get-DiskImage -ImagePath '${source}' | Get-Volume).FileSystemLabel)'\" | swmi -Arguments @{DriveLetter=\"${drive_letter}:\"}",
    onlyif   => "if((Get-DiskImage '${source}' | Get-Volume).DriveLetter -ieq '${drive_letter}' ){ exit 1 } exit 0",
  }

}
