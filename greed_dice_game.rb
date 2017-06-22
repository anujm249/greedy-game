# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.


class DiceSet

    def initialize
        @players = []
        @final_turn = false
    end

    def calculate_score_and_non_scoring_dice_count(dice)
      score = 0
      if dice.length >= 3
        dice = dice.sort
        if dice.select{|i| i==1}.length >= 3
          score = 1000
          # to remove 3 dice having 1
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
      score = score + dice.select{|x| x == 1}.length * 100
      score = score + dice.select{|x| x == 5}.length * 50
      non_scoring_dice_count = 0
      dice.each do |item|
        non_scoring_dice_count += 1 if item!=1 && item!=5
      end
      [score, non_scoring_dice_count]
    end

    def start_game(no_of_players)
        puts "GAME STARTED !!! Hold your breath !"

        (1..no_of_players).to_a.each do |item|
            puts "Enter name of player " + item.to_s
            player_name = gets.chomp()
            @players << {'player_name' => player_name, 'score'=> 0, 'in_game'=> false}
        end
        puts @players
        begin_game(no_of_players)
    end

    def begin_game(no_of_players)
        while !@final_turn
            (1..no_of_players).to_a.each do |player|
                accumated_score = 0
                dice_to_roll = 5
                while true
                    puts "\n\nChance of player " + @players[player -1]['player_name']
                    puts "Enter to continue"
                    gets
                    dice = roll_dice(dice_to_roll)
                    puts "Your Dice -> " + dice.to_s
                    score = calculate_score_and_non_scoring_dice_count(dice)[0]
                    non_scoring_dice_count = calculate_score_and_non_scoring_dice_count(dice)[1]
                    dice_to_roll = non_scoring_dice_count == 0 ? 5 : non_scoring_dice_count
                    puts "Great! your score is " + score.to_s
                    if !@players[player -1]['in_game']
                      accumated_score = score
                      break
                    end
                    if score == 0
                        accumated_score = 0
                        break
                    else
                        accumated_score = accumated_score + score
                    end
                    puts "accumated_score : " + accumated_score.to_s
                    puts "You can play with #{dice_to_roll} dice for the next turn"
                    puts "Want to skip the chance? y/n"
                    ans = gets.chomp()
                    if ans.include?('y')
                        player_name = @players[player -1]['player_name']
                        puts "#{player_name} your turn is skipped."
                        break
                    end
                end
                update_score(@players[player -1]['player_name'], accumated_score)
                score_board
            end
        end
    end

    def score_board
        puts "\n\n\n\n\n--------------------------------------------------"
        puts "------------------SCORE BOARD---------------------"
        puts "--------------------------------------------------"
        @players.each do |player|
            puts player['player_name'] + "| score: " + player['score'].to_s + "|    |In Game :" + player['in_game'].to_s + "|"
            puts "--------------------------------------------------\n\n\n\n"
        end
    end

    def roll_dice(number)
        puts "Rolling your DICE"
        dice = []
        (1..number).to_a.each do |item|
          dice << rand(1..6)
        end
        dice
    end

    def update_score(player, score)
        @players.each do |p|
            if p['player_name'] == player
                if p['in_game']
                    p['score'] = p['score'] + score
                elsif score >= 300
                    p['score'] = score
                    p['in_game'] = true
                end
            end
        end
        check_game_point
    end

    def check_game_point
        if !@final_turn
            all_score = []
            @players.each { |item| all_score << item['score']}
            if all_score.max >= 3000
                @final_turn = true
                final_rolling
            end
        end
    end

    def final_rolling
        puts "\n\n\nGAME POINT, Final Rolling chance to player that are in game"
        players_in_game = @players.select{|player| player['in_game']}
        if players_in_game.length == 1
          puts "Congrats #{players_in_game[0]['player_name']}, You win the game."
        else
          (1..players_in_game.length).to_a.each do |player|
                  puts "\n\nChance of player " + players_in_game[player -1]['player_name']
                  dice = roll_dice(5)
                  puts "Your dice " + dice.to_s
                  score = calculate_score_and_non_scoring_dice_count(dice)[0]
                  puts "Great your score is " + score.to_s
                  update_score(@players[player -1]['player_name'], score)
          end
          all_score = []

          @players.each { |item| all_score << item['score']}
          all_score = all_score.sort
          if all_score.last == all_score[-2]
              puts "Its a TIE"
          else
              winner = @players.select{|player| player['score'] == all_score.last}[0]['player_name']
              puts "\n\n\n\n\n\n\nAnd the WINNER is -----------"
              puts winner
          end
        end
    end

    def playgame
        loop do
            puts "Please tell the number of players - "
            no_of_players = gets
            if no_of_players.to_i > 1
                start_game(no_of_players.to_i)
                break
            else
                puts "Enter valid number !"
            end
        end
    end
end 

x = DiceSet.new
x.playgame