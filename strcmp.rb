require 'pry'
require 'English'
$LOAD_PATH.unshift(File.expand_path('lib', __dir__))

require 'expandable_string'
require 'state'
require 'tower'
require 'tower_factory'

# BLACK = 'x'
# WHITE = 'o'
# SPACE = nil
# BAR = '|'
# TODO: rename
class Strcmp < Tower
end
TowerFactory.build(<<-EOS.chomp, Strcmp)
1xxR1
1wxR2
1bxR3
1||R7
2wwR2
2bbR2
2||R4
3wwR3
3bbR3
3||R4
4xxR4
4wxL6
5xxR5
5bxL6
6wwL6
6bbL6
6||L6
6xxL6
6  R1
7xxR7
7  LF
EOS

Strcmp.new(DATA.read.chomp)
__END__
x|x
