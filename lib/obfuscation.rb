module Obfuscation
  MAX = 2147483647
  PRM = 1580030173
  INV = 59260789
  XOR = 1389398023

  def self.obfuscate(id)
    ((id * PRM) & MAX) ^ XOR
  end

  def self.deobfuscate(id)
    ((id ^ XOR) * INV) & MAX
  end
end
