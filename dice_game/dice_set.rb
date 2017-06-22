class DiceSet

  def self.calculate_score_if_set_of_three_number_present(dice)
    score = 0
    if dice.length >= 3
      dice = dice.sort
      if dice.select{|i| i==1}.length >= 3
        score = 1000
        count = 0
        new_dice = []
        dice.each do |item|
          count += 1 if item == 1
          new_dice << item if item != 1
          new_dice << item if item == 1 and count>3
        end
        dice = new_dice
      elsif dice.length >= 3 && dice.uniq.length <= 3 
        dice.uniq.each do |x|
          count = 0
          req_no = x
          dice.each do |y|
            count += 1 if x == y
            if count == 3
              score = x * 100
              count = 0
              new_dice = []
              dice.each do |item|
                count += 1 if item == x
                new_dice << item if item != x
                new_dice << item if item == x and count>3
              end
              dice = new_dice
              break
            end
          end
        end
      end
    end
    [score, dice]
  end


  def self.score(dice)
    score, dice = self.calculate_score_if_set_of_three_number_present(dice)
    score = score + dice.select{|x| x == 1}.length * 100
    score = score + dice.select{|x| x == 5}.length * 50
    score
  end

  def self.non_scoring_dice_count(dice)
    score, dice = calculate_score_if_set_of_three_number_present(dice)
    non_scoring_dice_count = 0
    dice.each do |item|
      non_scoring_dice_count += 1 if item!=1 && item!=5
    end
    non_scoring_dice_count
  end

  def self.roll_dice(number)
    puts "Rolling your DICE"
    dice = []
    (1..number).to_a.each do |item|
      dice << rand(1..6)
    end
    dice
  end     

end