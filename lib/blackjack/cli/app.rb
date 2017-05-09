require 'tty-prompt'

module Blackjack
  module CLI
    class App
      def initialize
        @prompt = TTY::Prompt.new

        configure_prompt
      end

      def run
        name = @prompt.ask('What is your name?', default: ENV['USER'], convert: :string)
        bankroll = @prompt.ask('What is your bankroll?', default: 100, convert: :int)

        player = Player.new(name, bankroll)

        game_number = 1

        while player.can_afford?(Game::MINIMUM_BET_SIZE)
          puts "Game №#{ game_number }"
          bet = @prompt.ask('What is your bet?', default: Game::MINIMUM_BET_SIZE, convert: :int)

          game = Game.new(player, bet)

          puts "Dealer's hand:"
          puts game.dealer_hand
          puts

          puts "Your initial hand:"
          puts game.player_hands.first
          puts

          until game.over?
            game.player_hands.each_with_index do |hand, hand_index|
              next if hand.options.empty?

              hand_number = hand_index + 1

              message_hand_count_part = game.player_hands.count > 1 ? " (hand №#{ hand_number })" : ''
              message = "What to do next#{ message_hand_count_part }?"

              choice = @prompt.select(message, hand.options)

              game.act(choice, hand_index)

              break if choice == :split
            end

            game.player_hands.each_with_index do |hand, hand_index|
              hand_number = hand_index + 1

              puts game.player_hands.count > 1 ? "Hand №#{ hand_number }:" : 'Your hand:'
              puts hand
              puts
            end
          end

          unless game.player_hands.count == 1 && game.player_hands.first.blackjack?
            puts "Dealer opens his hand and takes cards until 17:"
            puts game.dealer_hand
            puts
          end

          game.player_hands.each_with_index do |hand, hand_index|
            hand_number = hand_index + 1

            if game.player_hands.count > 1
              puts "Hand №#{ hand_number }"
            end

            if hand.blackjack?
              puts 'Blackjack!'
            else
              puts 'Win!' if hand > game.dealer_hand
            end

            puts 'Loose!' if hand < game.dealer_hand
            puts 'Push!' if hand == game.dealer_hand
            puts
          end

          puts "Game is over. Your bankroll: #{ player.bankroll }"
          puts

          game_number += 1
        end

        puts 'Your bankroll is less than the minimum bet size.'
      rescue TTY::Prompt::Reader::InputInterrupt
        puts
        puts 'Bye!'
      end

      private

      def configure_prompt
        @prompt.on(:keypress) do |event|
          case event.value
          when 'j'
            @prompt.trigger(:keydown)
          when 'k'
            @prompt.trigger(:keyup)
          end
        end
      end
    end
  end
end
