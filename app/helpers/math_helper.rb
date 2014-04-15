module MathHelper

  def self.get_random cnt, max
    randoms = Set.new
    loop do
        randoms << rand(max)
        return randoms.to_a if randoms.size >= cnt
    end
  end

end