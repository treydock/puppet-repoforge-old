# This is a simple fact to get the Major version of an OS without having to
# have the entire LSB suite installed.  LSB seems to pull in about 300 megs of
# stuff I often don't require. This fact is quick to load so it shouldn't be
# much of an issue.

# Only add this new fact if not already defined by another module
if ! Facter[:os_maj_version]
  Facter.add(:os_maj_version) do
    setcode do
      v = Facter.value(:operatingsystemrelease)
      v.split('.')[0].strip
    end
  end
end