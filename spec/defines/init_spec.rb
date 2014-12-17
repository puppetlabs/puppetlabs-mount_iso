require 'spec_helper'
RSpec.describe 'mount_iso' do
  let(:title) { 'c:\Users\TestUser\mysystem.iso' }
  let(:params) {
    {:drive_letter => 'H', }
  }
  let(:facts) { {:osfamily => 'windows', } }

  it 'should contain exec for mount' do
    should contain_exec("Mount-Iso-#{title}").with(
               {
                   'command' => "Mount-DiskImage -ImagePath '#{title}'",
                   'onlyif' => "if ( (Get-DiskImage -ImagePath '#{title}').Attached ){ exit 1 } else { exit 0 }",
               }
           )
  end
  it {
    should contain_exec("Change-Mount-Letter-H").with(
               {
                   'command' => "gwmi win32_volume -Filter \"Label = '\$((Get-DiskImage -ImagePath '#{title}' | Get-Volume).FileSystemLabel)'\" | swmi -Arguments @{DriveLetter=\"H:\"}",
                   'onlyif' => "if((Get-DiskImage '#{title}' | Get-Volume).DriveLetter -ieq 'H' ){ exit 1 } exit 0"
               })
  }
end
