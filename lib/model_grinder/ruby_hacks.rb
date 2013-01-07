unless Array.respond_to?(:sample)
  class Array
    def sample(num = 1)
      ret = []
      already_picked = []
      (1..num).each { |i|
        break if i > length
        i2 = rand(length - 1)
        while already_picked.include?(i2)
          i2 = rand(length - 1)
        end
        already_picked << i2
        ret << self[i2]
      }
      ret
    end
  end
end