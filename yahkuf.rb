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
class Yahkuf < Tower
end
TowerFactory.build(<<-EOS.chomp, Yahkuf)
1xxR1
1ooR1
1 |L2
2XXL2
2  R6
2oXR3
2xXR4
3 oL5
3xxR3
3ooR3
3||R3
3XXR3
4 xL5
4xxR3
4ooR3
4||R3
4XXR3
5xxL5
5ooL5
5||L2
6XXR6
6| RF
EOS

Yahkuf.new(DATA.read.chomp)
__END__
x
