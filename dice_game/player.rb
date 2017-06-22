class Player
  
  attr_accessor :players

  def initialize
    @players = []
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
  end


end