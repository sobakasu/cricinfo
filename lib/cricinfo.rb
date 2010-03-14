$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'time'
require 'net/http'
require 'cricinfo/innings'
require 'cricinfo/game'
require 'cricinfo/scores'

module CricInfo
  VERSION = '0.0.1'
end

# array monkey patch
# http://snippets.dzone.com/posts/show/3332
class Array
  def permutations
    return [self] if size < 2
    perm = []
    each { |e| (self - [e]).permutations.each { |p| perm << ([e] + p) } }
    perm
  end
end
