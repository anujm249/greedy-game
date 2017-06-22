require_relative 'player'
require_relative 'dice_set'

class Game

  def initialize
    @final_turn = false
    @players = Player.new
  end

  def score_board
    puts "\n\n\n\n\n--------------------------------------------------"
    puts "------------------SCORE BOARD---------------------"
    puts "--------------------------------------------------"
    @players.players.each do |player|
        puts player['player_name'] + "| score: " + player['score'].to_s + "|    |In Game :" + player['in_game'].to_s + "|"
        puts "--------------------------------------------------\n\n\n\n"
    end
  end

  def final_rolling
    puts "\n\n\nGAME POINT, Final Rolling chance to player that are in game"
    players_in_game = @players.players.select{|player| player['in_game']}
    if players_in_game.length == 1
      puts "Congrats #{players_in_game[0]['player_name']}, You win the game."
    else
      (1..players_in_game.length).to_a.each do |player|
        puts "\n\nChance of player " + players_in_game[player -1]['player_name']
        dice = DiceSet.roll_dice(5)
        puts "Your dice " + dice.to_s
        score = DiceSet.score(dice)
        puts "Great your score is " + score.to_s
        @players.update_score(@players.players[player -1]['player_name'], score)
      end
      all_score = []
      @players.players.each { |item| all_score << item['score']}
      all_score = all_score.sort
      if all_score.last == all_score[-2]
        puts "Its a TIE"
      else
        winner = @players.players.select{|player| player['score'] == all_score.last}[0]['player_name']
        puts "\n\n\n\n\n\n\nAnd the WINNER is -----------"
        puts winner
      end
    end
  end

  def check_game_point
    if !@final_turn
      all_score = []
      @players.players.each { |item| all_score << item['score']}
      if all_score.max >= 3000
        @final_turn = true
        final_rolling
      end
    end
  end
  
  def begin_game(no_of_players)
    while !@final_turn
      (1..no_of_players).to_a.each do |player|
        accumated_score = 0
        dice_to_roll = 5
        while true
          puts "\n\nChance of player " + @players.players[player -1]['player_name']
          puts "Enter to continue"
          gets
          dice = DiceSet.roll_dice(dice_to_roll)
          puts "Your Dice -> " + dice.to_s
          score = DiceSet.score(dice)
          non_scoring_dice_count = DiceSet.non_scoring_dice_count(dice)
          dice_to_roll = non_scoring_dice_count == 0 ? 5 : non_scoring_dice_count
          puts "Great! your score is " + score.to_s
          if !@players.players[player -1]['in_game']
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
            player_name = @players.players[player -1]['player_name']
            puts "#{player_name} your turn is skipped."
            break
          end
        end
        @players.update_score(@players.players[player -1]['player_name'], accumated_score)
        check_game_point
        score_board
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

  def start_game(no_of_players)
    puts "GAME STARTED !!! Hold your breath !"

    (1..no_of_players).to_a.each do |item|
        puts "Enter name of player " + item.to_s
        player_name = gets.chomp()
        @players.players << {'player_name' => player_name, 'score'=> 0, 'in_game'=> false}
    end
    puts @players.players
    begin_game(no_of_players)
  end

end

x = Game.new
x.playgame